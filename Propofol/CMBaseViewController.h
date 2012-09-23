//
//  CMBaseViewController.h
//  Propofol
//
//  Created by Tim on 23/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMBaseViewController : UIViewController

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRight;

-(IBAction)didSwipLeft:(id)sender;

@end
