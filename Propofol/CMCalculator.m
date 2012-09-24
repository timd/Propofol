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

-(NSMutableDictionary *)newPatientWithAge:(float)age andWeight:(float)weight andHeight:(float)height andMale:(BOOL)male {
    
    float lbm;
    
    if (male) {
        lbm = 1.1 * weight - 128 * ((weight/height) * (weight/height));
    } else {
        lbm = 1.07 * weight - 148 * ((weight/height) * (weight/height));
    }
    
    float v1 = 4.27;
    float v2 = 18.9 - 0.391 * (age - 53);
    float v3 = 238;
    
    float k10 = 0.443 + 0.0107 * (weight - 77) - 0.0159 * (lbm - 59) + 0.0062 * (height - 177);
    float k12 = 0.302 - 0.0056 * (age - 53);
    float k13 = 0.196;
    float k21 = (1.29 - 0.024 * (age - 53)) / (18.9 - 0.391 * (age - 53));
    float k31 = 0.0035;
    
    float keo = 0.456;
    
    float xeo = 0.0f;
    
//  float ttpe = 1.69;
    
    NSArray *keysArray = [NSArray arrayWithObjects:@"x1", @"x2", @"x3", @"v1", @"v2", @"v3", @"k10", @"k12", @"k13", @"k21", @"k31", @"keo", @"xeo", nil];
    NSArray *valsArray = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:v1],
                          [NSNumber numberWithFloat:v2],
                          [NSNumber numberWithFloat:v3],
                          [NSNumber numberWithFloat:k10],
                          [NSNumber numberWithFloat:k12],
                          [NSNumber numberWithFloat:k13],
                          [NSNumber numberWithFloat:k21],
                          [NSNumber numberWithFloat:k31],
                          [NSNumber numberWithFloat:keo],
                          [NSNumber numberWithFloat:xeo],
                          nil];
    
    NSMutableDictionary *state = [[NSMutableDictionary alloc] initWithObjects:valsArray forKeys:keysArray];
    
    return state;
    
}

-(NSMutableDictionary *)giveDrugWithQuantity:(float)milligrams withState:(NSMutableDictionary *)state {
    
    float currentX1value = [[state objectForKey:@"x1"] floatValue];
    
    float v1 = [[state objectForKey:@"v1"] floatValue];
    
    currentX1value = currentX1value + milligrams / v1;
    
    [state setObject:[NSNumber numberWithFloat:currentX1value] forKey:@"x1"];
    
    return state;
    
}

-(NSMutableDictionary *)waitTime:(float)time withState:(NSMutableDictionary *)s {
    
    float x1 = [[s valueForKey:@"x1"] floatValue];
    float x2 = [[s valueForKey:@"x2"] floatValue];
    float x3 = [[s valueForKey:@"x3"] floatValue];

    float k10 = [[s valueForKey:@"k10"] floatValue];
    float k21 = [[s valueForKey:@"k21"] floatValue];
    float k12 = [[s valueForKey:@"k12"] floatValue];
    float k13 = [[s valueForKey:@"k13"] floatValue];
    float k31 = [[s valueForKey:@"k31"] floatValue];
    float keo = [[s valueForKey:@"keo"] floatValue];
    float xeo = [[s valueForKey:@"xeo"] floatValue];

    float newX1 = x1 + (k21 * x2 + -(k12) * x1 + k31 * x3 + -(k13) * x1 - k10 * x1) * time;
    
    float newX2 = x2 + (-k21 * x2 + k12 * x1) * time;
    
    float newX3 = x3 + (-k31 * x3 + k13 * x1) * time;
    
    float newXeo = xeo + (-keo * xeo + keo * x1) * time;
    
    [s setObject:[NSNumber numberWithFloat:newX1] forKey:@"x1"];
    [s setObject:[NSNumber numberWithFloat:newX2] forKey:@"x2"];
    [s setObject:[NSNumber numberWithFloat:newX3] forKey:@"x3"];
    [s setObject:[NSNumber numberWithFloat:newXeo] forKey:@"xeo"];
    
    return s;
    
}



@end
