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

-(NSMutableDictionary *)newPatientWithAge:(float)age andWeight:(float)weight andHeight:(float)height andMale:(BOOL)male;
-(NSMutableDictionary *)giveDrugWithQuantity:(float)milligrams withState:(NSMutableDictionary *)state;
-(NSMutableDictionary *)waitTime:(float)time withState:(NSMutableDictionary *)s;

@end
