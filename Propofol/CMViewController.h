//
//  CMViewController.h
//  Propofol
//
//  Created by Tim on 22/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *heightPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *weightPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *agePicker;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderControl;
- (IBAction)didTapNextButton:(id)sender;

@end
