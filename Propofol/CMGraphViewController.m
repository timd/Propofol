//
//  CMGraphViewController.m
//  Propofol
//
//  Created by Tim on 22/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMGraphViewController.h"
#import "CMCalculator.h"

@interface CMGraphViewController ()

@property (nonatomic, strong) CPTXYGraph *graph;
@property (nonatomic, strong) NSMutableArray *dataForPlot;

@property (nonatomic, strong) NSMutableDictionary *state;

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graphView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIButton *doseButton;
@property (nonatomic, strong) NSTimer *heartbeat;

@property (nonatomic) int greenValue;

@property (nonatomic) int tickCounter;

@end

@implementation CMGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [self.graph applyTheme:theme];
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.graphView;
    //hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph     = self.graph;
    [hostingView setUserInteractionEnabled:YES];
    
    self.graph.paddingLeft   = 10.0;
    self.graph.paddingTop    = 10.0;
    self.graph.paddingRight  = 10.0;
    self.graph.paddingBottom = 10.0;
    
    self.graph.plotAreaFrame.paddingBottom = 30.0f;
    self.graph.plotAreaFrame.paddingLeft = 30.0f;
    
    [self.graph.plotAreaFrame setBorderLineStyle:nil];

    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(750)];
    plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(5)];
    
    [plotSpace setGlobalXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(750)]];
    [plotSpace setGlobalYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(8)]];
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    [x setLabelFormatter:nil];
    [x setMajorTickLineStyle:nil];
    [x setMinorTickLineStyle:nil];
    
    //x.majorIntervalLength         = CPTDecimalFromString(@"5.0");
    //x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    //x.minorTicksPerInterval       = 0;
    //    NSArray *exclusionRanges = [NSArray arrayWithObjects:
    //                                [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.99) length:CPTDecimalFromFloat(0.02)],
    //                                [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.99) length:CPTDecimalFromFloat(0.02)],
    //                                [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(2.99) length:CPTDecimalFromFloat(0.02)],
    //                                nil];
    //    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength         = CPTDecimalFromString(@"5.0");
    y.minorTicksPerInterval       = 0;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    /*    exclusionRanges               = [NSArray arrayWithObjects:
     [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.99) length:CPTDecimalFromFloat(0.02)],
     [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.99) length:CPTDecimalFromFloat(0.02)],
     [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(3.99) length:CPTDecimalFromFloat(0.02)],
     nil];
     y.labelExclusionRanges = exclusionRanges;
     */
    y.delegate             = self;
    
    // Create a blue plot area
    CPTScatterPlot *boundLinePlot  = [[CPTScatterPlot alloc] init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = @"Blue Plot";
    boundLinePlot.dataSource    = self;
    [self.graph addPlot:boundLinePlot];
    
    // Do a blue gradient
    //CPTColor *areaColor1       = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    //CPTGradient *areaGradient1 = [CPTGradient gradientWithBeginningColor:areaColor1 endingColor:[CPTColor clearColor]];
    //areaGradient1.angle = -90.0f;
    //CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient1];
    //boundLinePlot.areaFill      = areaGradientFill;
    //boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
    
    // Add plot symbols
    //CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    //symbolLineStyle.lineColor = [CPTColor blackColor];
    //CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    //plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    //plotSymbol.lineStyle     = symbolLineStyle;
    //plotSymbol.size          = CGSizeMake(10.0, 10.0);
    //boundLinePlot.plotSymbol = plotSymbol;

    // Create a green plot area
     CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
     lineStyle                        = [CPTMutableLineStyle lineStyle];
     lineStyle.lineWidth              = 3.f;
     lineStyle.lineColor              = [CPTColor greenColor];
     lineStyle.dashPattern            = [NSArray arrayWithObjects:[NSNumber numberWithFloat:5.0f], [NSNumber numberWithFloat:5.0f], nil];
     dataSourceLinePlot.dataLineStyle = lineStyle;
     dataSourceLinePlot.identifier    = @"Green Plot";
     dataSourceLinePlot.dataSource    = self;
    [self.graph addPlot:dataSourceLinePlot];
     

    //  INITIALISE DATA
    self.state = [self.calculator newPatientWithAge:40 andWeight:70 andHeight:170 andMale:YES];
    self.state = [self.calculator giveDrugWithQuantity:50 withState:self.state];

    NSLog(@"state = %@\n\n", self.state);
    
    // Add some initial data
    self.dataForPlot = [[NSMutableArray alloc] init];
    
    /* Initial data dict
    
        "X" : 0.0f
        "Y" : 0.0f
     
    */
    
    self.tickCounter = 0;
    
    NSDictionary *initialData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSNumber numberWithInt:self.tickCounter], @"x",
                                 [NSNumber numberWithFloat:0.0f], @"y",
                                 nil];
    
    [self.dataForPlot addObject:initialData];
    
    self.heartbeat = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doSomethingTimed) userInfo:nil repeats:YES];
    
    
    self.greenValue = 2.5;
    
}

-(void)viewDidUnload {
    
    [self.heartbeat invalidate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma Core Plot methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    
    NSNumber *num = [[self.dataForPlot objectAtIndex:index] valueForKey:key];
    
    // Green plot gets shifted above the blue
    if ( [(NSString *)plot.identifier isEqualToString:@"Green Plot"] ) {
        
        if ( fieldEnum == CPTScatterPlotFieldY ) {
            num = [NSNumber numberWithInt:self.greenValue];
        }
    }
    
    return num;
}

#pragma mark -
#pragma mark Data calculation methods

-(void)doSomethingTimed {
    
    self.state = [self.calculator waitTime:0.25f withState:self.state];
    
    float updatedX1value = [[self.state valueForKey:@"x1"] floatValue];
    float updatedXeovalue = [[self.state valueForKey:@"xeo"] floatValue];
    
    self.tickCounter += 10;
    
    // Create new dictionary to add to the data array
    NSDictionary *newDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithFloat:updatedXeovalue], @"y",
                             [NSNumber numberWithFloat:self.tickCounter], @"x", nil];
    
    NSLog(@"state = %@", self.state);
    
    [self.dataForPlot addObject:newDict];
    
    
/*
     int dataPointCount = [self.dataForPlot count];
     
     if (dataPointCount > 50) {
     
         float newXorigin = dataPointCount -100;
         
         CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
         
         CPTMutablePlotRange *mutablePlotXRange = (CPTMutablePlotRange *)plotSpace.globalXRange;
         
         // Current origin
         int currentOrigin = mutablePlotXRange.location._exponent;
         int newOrigin = currentOrigin - 10;
         
//         mutablePlotXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(newXorigin) length:CPTDecimalFromFloat(500.0)];
         mutablePlotXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(newOrigin) length:CPTDecimalFromFloat(500.0)];
  
         CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
         CPTXYAxis *y          = axisSet.yAxis;
         
         int newCoord = axisSet.yAxis.orthogonalCoordinateDecimal._exponent + 10;
         
         y.orthogonalCoordinateDecimal = CPTDecimalFromInt(newCoord); //(newXorigin);// CPTDecimalFromString(@"0");
         
         [plotSpace setXRange:mutablePlotXRange];
         [plotSpace setGlobalXRange:mutablePlotXRange];
         
         NSLog(@"plotRange = %@", mutablePlotXRange);
         
         // Replot the graph
         //[self.graph reloadData];
         
     }

 */
 
    [self.graph reloadData];
    
}


#pragma mark -
#pragma mark Interaction methods

- (IBAction)didTapStopButton:(id)sender {
    
    if ([self.heartbeat isValid]) {
        [self.heartbeat invalidate];
        [self.toggleButton setTitle:@"Start" forState:UIControlStateNormal];
    } else {
        self.heartbeat = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(doSomethingTimed) userInfo:nil repeats:YES];
        [self.toggleButton setTitle:@"Stop" forState:UIControlStateNormal];
    }

}
- (IBAction)didTapUpButton:(id)sender {
    self.greenValue += 1;
}

- (IBAction)didTapDownButton:(id)sender {
    if (self.greenValue > 0) {
        self.greenValue -= 1;
    }
}

-(IBAction)didTapGiveDoseButton:(id)sender {
    
    self.state = [self.calculator giveDrugWithQuantity:50.0f withState:self.state];
    
}

@end
