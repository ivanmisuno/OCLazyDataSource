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
    self.sut = @{@"string":@"string", @"number":@1, @"numberAsString":@"2", @"array":@[@"1",@"2",@"3"], @"dictionary":@{@"a":@"1",@"b":@"2",@"c":@"3"}};
}

- (void)testInteger
{
    XCTAssertEqual([self.sut sgi_integerForKey:@"number"], 1);
    XCTAssertEqual([self.sut sgi_integerForKey:@"numberAsString"], 2);
}

- (void)testDouble
{
    XCTAssertEqual([self.sut sgi_doubleForKey:@"number"], 1);
    XCTAssertEqual([self.sut sgi_doubleForKey:@"numberAsString"], 2);
}

- (void)testValueString
{
    XCTAssertNotNil([self.sut sgi_stringForKey:@"string"]);
}
- (void)testValueNotString
{
    XCTAssertNil([self.sut sgi_stringForKey:@"number"]);
}

- (void)testValueNumber
{
    XCTAssertNotNil([self.sut sgi_numberForKey:@"number"]);
}
- (void)testValueNotNumber
{
    XCTAssertNil([self.sut sgi_numberForKey:@"string"]);
}

- (void)testValueArray
{
    XCTAssertNotNil([self.sut sgi_arrayForKey:@"array"]);
}
- (void)testValueNotArray
{
    XCTAssertNil([self.sut sgi_arrayForKey:@"number"]);
}

- (void)testValueDictionary
{
    XCTAssertNotNil([self.sut sgi_dictionaryForKey:@"dictionary"]);
}
- (void)testValueNotDictionary
{
    XCTAssertNil([self.sut sgi_dictionaryForKey:@"number"]);
}

@end
