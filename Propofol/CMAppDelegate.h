//
//  CMAppDelegate.h
//  Propofol
//
//  Created by Tim on 22/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMViewController;

@interface CMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CMViewController *viewController;

@end
