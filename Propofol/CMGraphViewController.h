//
//  CMGraphViewController.h
//  Propofol
//
//  Created by Tim on 22/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface CMGraphViewController : UIViewController <CPTPlotDataSource>

- (IBAction)didTapStopButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *toggleButton;


@end
