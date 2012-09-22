//
//  CMConcentrationViewController.h
//  Propofol
//
//  Created by Tim on 22/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMCalculator;

@interface CMConcentrationViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) CMCalculator *calculator;

@property (strong, nonatomic) IBOutlet UIPickerView *decimalPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *unitPicker;

- (IBAction)didTapNextButton:(id)sender;
@end
