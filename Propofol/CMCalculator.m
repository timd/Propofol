//
//  CMCalculator.m
//  Propofol
//
//  Created by Tim on 22/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMCalculator.h"

@implementation CMCalculator

-(id)init {
    
    if (self = [super init]) {
        //
    }
    
    return self;
}

-(void)logValues {
    NSLog(@"age = %d", self.age);
    NSLog(@"height = %d", self.height);
    NSLog(@"weight = %d", self.weight);
    NSLog(@"gender = %d", self.gender);
    NSLog(@"targetConcentration = %f", self.targetConcentration);
}

@end