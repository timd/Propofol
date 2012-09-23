//
//  CMGraphViewController.h
//  Propofol
//
//  Created by Tim on 22/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "CMBaseViewController.h"

@interface CMGraphViewController : CMBaseViewController <CPTPlotDataSource>

- (IBAction)didTapStopButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *toggleButton;

- (IBAction)didTapUpButton:(id)sender;
- (IBAction)didTapDownButton:(id)sender;

@end
