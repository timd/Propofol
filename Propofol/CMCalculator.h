//
//  CMCalculator.h
//  Propofol
//
//  Created by Tim on 22/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMCalculator : NSObject

@property (nonatomic) int age;
@property (nonatomic) int weight;
@property (nonatomic) int height;
@property (nonatomic) int gender;
@property (nonatomic) float targetConcentration;

-(void)logValues;

@end
