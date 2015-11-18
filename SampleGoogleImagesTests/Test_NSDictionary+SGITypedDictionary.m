//
//  Test_NSDictionary+SGITypedDictionary.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDictionary+SGITypedDictionary.h"

@interface Test_NSDictionary_SGITypedDictionary : XCTestCase

@property (nonatomic) NSDictionary *sut;

@end

@implementation Test_NSDictionary_SGITypedDictionary

- (void)setUp
{
    [super setUp];
    self.sut = @{@"string":@"string", @"number":@1};
}

- (void)testValueString
{
    XCTAssertNotNil([self.sut sgi_stringForKey:@"string"]);
}

- (void)testValueNotString
{
    XCTAssertNil([self.sut sgi_stringForKey:@"number"]);
}

@end
