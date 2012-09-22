//
//  CMGraphViewController.m
//  Propofol
//
//  Created by Tim on 22/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMGraphViewController.h"

@interface CMGraphViewController ()

@property (nonatomic, strong) CPTXYGraph *graph;
@property (nonatomic, strong) NSMutableArray *dataForPlot;

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
    plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(200.0)];
    plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(20.0)];
    
    [plotSpace setGlobalXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(60)]];
    [plotSpace setGlobalYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(60)]];
    
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
     

    // Add some initial data
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
    NSUInteger i;
    for ( i = 0; i < 101; i++ ) {
        
        
        
        
        id x = [NSNumber numberWithFloat:i];
        id y = [NSNumber numberWithFloat:10.0f];
        
        //id x = [NSNumber numberWithFloat:1 + i * 0.05];
        //id y = [NSNumber numberWithFloat:1.2 * rand() / (float)RAND_MAX + 1.2];
        [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
    
    self.dataForPlot = contentArray;
    
#ifdef PERFORMANCE_TEST
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changePlotRange) userInfo:nil repeats:YES];
#endif
    
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
            num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
        }
    }
    return num;
}

@end
