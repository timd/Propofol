//
//  CMConcentrationViewController.m
//  Propofol
//
//  Created by Tim on 22/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMConcentrationViewController.h"
#import "CMGraphViewController.h"

#import "CMCalculator.h"

#define kUnitPicker 100
#define kDecimalPicker 200

@interface CMConcentrationViewController ()

@property (nonatomic, strong) NSMutableArray *concUnitValues;
@property (nonatomic, strong) NSMutableArray *concDecimalValues;

@property (nonatomic) int currentPickerDecimalValue;
@property (nonatomic) int currentPickerUnitValue;

@end

@implementation CMConcentrationViewController

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
    self.concUnitValues = [[NSMutableArray alloc] init];
    self.concDecimalValues = [[NSMutableArray alloc] init];
    
    for (int unit = 0; unit < 16; unit++) {
        [self.concUnitValues addObject:[NSNumber numberWithInt:unit]];
    }

    for (int dec = 0; dec < 10; dec++) {
        [self.concDecimalValues addObject:[NSNumber numberWithInt:dec]];
    }
    
    [self.swipeRight addTarget:self action:@selector(didTapNextButton:)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIPickerView delegate methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
        case kUnitPicker:
            return [self.concUnitValues count];
            break;

        case kDecimalPicker:
            return [self.concDecimalValues count];
            break;
            
        default:
            break;
    }
    
    return 0;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
        case kUnitPicker:
            return [NSString stringWithFormat:@"%@", [self.concUnitValues objectAtIndex:row]];
            break;
            
        case kDecimalPicker:
            return [NSString stringWithFormat:@"%@", [self.concDecimalValues objectAtIndex:row]];
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
        case kUnitPicker:
            self.currentPickerUnitValue = [[self.concUnitValues objectAtIndex:row] intValue];
            break;

        case kDecimalPicker:
            self.currentPickerDecimalValue = [[self.concDecimalValues objectAtIndex:row] intValue];
            break;

        default:
            break;
    }
    
    NSLog(@"unitPicker = %d", self.currentPickerUnitValue);
    NSLog(@"decimalPicker = %d\n\n", self.currentPickerDecimalValue);
    
    float decimalValue = self.currentPickerDecimalValue * 0.1;
    float concentrationValue = self.currentPickerUnitValue + decimalValue;
    
    NSLog(@"decimalValue = %f", decimalValue);
    NSLog(@"concentrationValue = %f", concentrationValue);
    
    [self.calculator setTargetConcentration:concentrationValue];
    
}

- (IBAction)didTapNextButton:(id)sender {
    
    CMGraphViewController *graphController = [[CMGraphViewController alloc] initWithNibName:@"CMGraphView" bundle:nil];

    [self.navigationController pushViewController:graphController animated:YES];
    
    [self.calculator logValues];
    
}

@end
