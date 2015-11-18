//
//  Test_SGISearchItem.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SGISearchItem.h"

@interface Test_SGISearchItem : XCTestCase

@end

@implementation Test_SGISearchItem

- (void)testToJson
{
    SGISearchItem *item = [SGISearchItem searchItemWithSearch:@"robbie williams"];
    NSDictionary *json = item.toJson;
    XCTAssertNotNil(json);
    XCTAssertEqual(json.count, 1);
    XCTAssertEqualObjects(json[@"search"], @"robbie williams");
}

- (void)testFromValidJson
{
    NSDictionary *json = @{@"search": @"robbie williams"};
    SGISearchItem *searchItem = [SGISearchItem fromJson:json];
    XCTAssertNotNil(searchItem);
    XCTAssertEqualObjects(searchItem.search, @"robbie williams");
}

- (void)testFromNilJson
{
    NSDictionary *json = nil;
    SGISearchItem *searchItem = [SGISearchItem fromJson:json];
    XCTAssertNil(searchItem);
}

- (void)testFromNotAJson
{
    id notAJson = @[@"aassa"];
    SGISearchItem *searchItem = [SGISearchItem fromJson:notAJson];
    XCTAssertNil(searchItem);
}

- (void)testFromNonconformigJson
{
    NSDictionary *json = @{@"asdf": @"qwerty"};
    SGISearchItem *searchItem = [SGISearchItem fromJson:json];
    XCTAssertNil(searchItem);
}

@end
