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


@end
