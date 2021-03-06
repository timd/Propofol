//
//  CMViewController.m
//  Propofol
//
//  Created by Tim on 22/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMVitalsViewController.h"
#import "CMConcentrationViewController.h"

#import "CMCalculator.h"

#define kAgePickerTag 300
#define kWeightPickerTag 200
#define kHeightPickerTag 100


@interface CMVitalsViewController ()

@property (nonatomic, strong) NSMutableArray *ageArray;
@property (nonatomic, strong) NSMutableArray *weightArray;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, strong) CMCalculator *calculator;

@end

@implementation CMVitalsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Create and load calculator
    self.calculator = [[CMCalculator alloc] init];
    
    
    // Setup basic stats source data
    self.ageArray = [[NSMutableArray alloc] init];
    self.weightArray = [[NSMutableArray alloc] init];
    self.heightArray = [[NSMutableArray alloc] init];
    
    // Age - 16 to 105
    for (int age = 16; age < 100; age++) {
        //
        [self.ageArray addObject:[NSNumber numberWithInt:age]];
    }
    
    // Weight - kg 0 - 350
    for (int weight = 0; weight < 351; weight += 10) {
        //
        [self.weightArray addObject:[NSNumber numberWithInt:weight]];
    }
    
    // Height - 0 to 250
    for (int height = 0; height < 251; height += 25) {
        //
        [self.heightArray addObject:[NSNumber numberWithInt:height]];
    }
    
    // Setup gender control
    [self.genderControl addTarget:self action:@selector(didChangeGenderValue) forControlEvents:UIControlEventValueChanged];
    
    // Fix settings of gesture recognizers
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
            
        case kAgePickerTag:
            return [self.ageArray count];
            break;
            
        case kWeightPickerTag:
            return [self.weightArray count];
            break;
            
        case kHeightPickerTag:
            return [self.heightArray count];
            break;
            
        default:
            break;
    }
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
            
        case kAgePickerTag:
            return [NSString stringWithFormat:@"%@", [self.ageArray objectAtIndex:row]];
            break;

        case kWeightPickerTag:
            return [NSString stringWithFormat:@"%@", [self.weightArray objectAtIndex:row]];
            break;

        case kHeightPickerTag:
            return [NSString stringWithFormat:@"%@", [self.heightArray objectAtIndex:row]];
            break;

        default:
            break;
    }
    
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
            
        case kAgePickerTag:
            //
            [self.calculator setAge:[[self.ageArray objectAtIndex:row] intValue]];
            break;
            
        case kWeightPickerTag:
            //
            [self.calculator setWeight:[[self.weightArray objectAtIndex:row] intValue]];
            break;
            
        case kHeightPickerTag:
            //
            [self.calculator setHeight:[[self.heightArray objectAtIndex:row] intValue]];
            break;
            
        default:
            break;
    }
    
}

-(void)didChangeGenderValue {
    
    [self.calculator setGender:[self.genderControl selectedSegmentIndex]];
    
}

#pragma mark -
#pragma mark Interaction methods

- (IBAction)didTapNextButton:(id)sender {
    
    CMConcentrationViewController *concVC = [[CMConcentrationViewController alloc] initWithNibName:@"CMConcentrationView" bundle:nil];
    
    [concVC setCalculator:self.calculator];
    
    [self.calculator logValues];
    
    [self.navigationController pushViewController:concVC animated:YES];
    
}
@end
