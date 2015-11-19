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

- (void)testNewSearchId
{
    SGISearchItem *item = [SGISearchItem createSearchItemWithSearch:@"robbie williams"];
    XCTAssertNotEqual(item.searchId, 0);
}

- (void)testUniqueSearchId
{
    NSMutableSet *ids = [NSMutableSet new];
    for (int i = 0; i < 1000; i++)
    {
        SGISearchItem *item = [SGISearchItem createSearchItemWithSearch:@"robbie williams"];
        [ids addObject:@(item.searchId)];
    }
    XCTAssertEqual(ids.count, 1000); // set contains 1000 unique elements
}

- (void)testToJson
{
    SGISearchItem *item = [SGISearchItem createSearchItemWithSearch:@"robbie williams"];
    NSDictionary *json = item.toJson;
    XCTAssertNotNil(json);
    XCTAssertEqual(json.count, 3);
    XCTAssertTrue([json.allKeys containsObject:@"searchId"]);
    XCTAssertEqualObjects(json[@"search"], @"robbie williams");
}

- (void)testFromValidJson
{
    NSDictionary *json = @{@"searchId":@(1234), @"search": @"robbie williams", @"timestamp":@(1234.56)};
    SGISearchItem *searchItem = [SGISearchItem fromJson:json];
    XCTAssertNotNil(searchItem);
    XCTAssertEqualObjects(searchItem.search, @"robbie williams");
    XCTAssertEqual(searchItem.searchId, 1234);
    XCTAssertEqualWithAccuracy(searchItem.timestamp, 1234.56, 0.001);
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

- (void)testFromNonconformingJson
{
    NSDictionary *json = @{@"asdf": @"qwerty"};
    SGISearchItem *searchItem = [SGISearchItem fromJson:json];
    XCTAssertNil(searchItem);
}

- (void)testToJsonArray
{
    NSArray<SGISearchItem *> *items = @[[SGISearchItem createSearchItemWithSearch:@"robbie williams"],
                                        [SGISearchItem createSearchItemWithSearch:@"david gilmour"]];
    NSArray<NSDictionary *> *jsonArray = [SGISearchItem toJsonArray:items];
    XCTAssertNotNil(jsonArray);
    XCTAssertEqual(jsonArray.count, 2);
    XCTAssertEqualObjects(jsonArray[0][@"search"], @"robbie williams");
    XCTAssertEqualObjects(jsonArray[1][@"search"], @"david gilmour");
}

- (void)testFromJsonArray
{
    NSArray<NSDictionary *> *jsonArray = @[@{@"searchId":@(1234),@"search":@"robbie williams", @"timestamp":@(1234.56)},
                                           @{@"asdf":@"qwerty"}, // will skip this on loading
                                           @{@"searchId":@(1235),@"search":@"david gilmour", @"timestamp":@(1234.56)}];
    NSArray<SGISearchItem *> *items = [SGISearchItem fromJsonArray:jsonArray];
    XCTAssertNotNil(items);
    XCTAssertEqual(items.count, 2);
    XCTAssertEqualObjects(items[0].search, @"robbie williams");
    XCTAssertEqual(items[0].searchId, 1234);
    XCTAssertEqualObjects(items[1].search, @"david gilmour");
    XCTAssertEqual(items[1].searchId, 1235);
}

- (void)testLoadingAllowNonUniqueIds
{
    NSArray<NSDictionary *> *jsonArray = @[@{@"searchId":@(1234),@"search":@"robbie williams", @"timestamp":@(1234.56)},
                                           @{@"searchId":@(1234),@"search":@"david gilmour", @"timestamp":@(1234.56)}];
    NSArray<SGISearchItem *> *items = [SGISearchItem fromJsonArray:jsonArray];
    XCTAssertNotNil(items);
    XCTAssertEqual(items.count, 2);
    XCTAssertEqual(items[0].searchId, 1234);

    // we're writing just a bunch of JSON, don't enforce uniqueness
    XCTAssertEqual(items[1].searchId, 1234);
}

@end
