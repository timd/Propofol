//
//  PropofolTests.m
//  PropofolTests
//
//  Created by Tim on 23/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "PropofolTests.h"
#import "CMCalculator.h"

@interface PropofolTests()

@property (nonatomic, strong) CMCalculator *calculator;

@end

@implementation PropofolTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    self.calculator = [[CMCalculator alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void)testCalculator {
    STAssertNotNil(self.calculator, @"should not be nil");
}

-(void)testInitialValues {
    
    NSDictionary *testValues = [self.calculator newPatientWithAge:40.0f andWeight:70.0f andHeight:170.0f andMale:YES];
    STAssertNotNil(testValues, @"testValues should not be nil");
    
    NSLog(@"keo = %f", [[testValues objectForKey:@"keo"] floatValue]);
    NSLog(@"k13 = %f", [[testValues objectForKey:@"k13"] floatValue]);
    NSLog(@"k12 = %f", [[testValues objectForKey:@"k12"] floatValue]);
    NSLog(@"k10 = %f", [[testValues objectForKey:@"k10"] floatValue]);
    NSLog(@"k31 = %f", [[testValues objectForKey:@"k31"] floatValue]);
    NSLog(@"k21 = %f", [[testValues objectForKey:@"k21"] floatValue]);
    NSLog(@"v1  = %f", [[testValues objectForKey:@"v1"] floatValue]);
    NSLog(@"v2  = %f", [[testValues objectForKey:@"v2"] floatValue]);
    NSLog(@"v3  = %f", [[testValues objectForKey:@"v3"] floatValue]);
    NSLog(@"x2  = %f", [[testValues objectForKey:@"x2"] floatValue]);
    NSLog(@"x3  = %f", [[testValues objectForKey:@"x3"] floatValue]);
    NSLog(@"x1  = %f", [[testValues objectForKey:@"x1"] floatValue]);
    
}

-(void)testWaitTime {

    NSDictionary *testValues = [self.calculator newPatientWithAge:40.0f andWeight:70.0f andHeight:170.0f andMale:YES];
    STAssertNotNil(testValues, @"testValues should not be nil");

    
    
}

@end
