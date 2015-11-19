//
//  Test_SGIObjectStore.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SGIObjectStore.h"
#import "NSFileManager+SGICommonDirectories.h"
#import "SGISearchItem.h"

@interface Test_SGISavedSearchManager : XCTestCase

@property (nonatomic, readonly) NSString *tempFilename;
@property (nonatomic, readonly) SGIObjectStore *sut;

@end

@implementation Test_SGISavedSearchManager

+ (NSString *)tempFileName
{
    NSString *timestamp = [NSString stringWithFormat:@"%.0f.temp", [NSDate timeIntervalSinceReferenceDate] * 1000];
    return [[NSFileManager sgi_cachesDir] stringByAppendingPathComponent:timestamp];
}

- (void)setUp
{
    [super setUp];
    _tempFilename = [[self class] tempFileName];
    _sut = [SGIObjectStore new];
    _sut.savedSearchesFilePath = self.tempFilename;
}

- (void)tearDown
{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.tempFilename error:&error];
    [super tearDown];
}

- (void)testLoadMissingFile
{
    NSArray<SGISearchItem *> *result = [self.sut loadSearches];
    // should still return empty array
    XCTAssertNotNil(result);
    XCTAssertTrue([result isKindOfClass:[NSArray class]]);
    XCTAssertEqual(result.count, 0);
}

- (NSArray<SGISearchItem *> *)defaultItems
{
    return @[[SGISearchItem createSearchItemWithSearch:@"robbie williams"],
             [SGISearchItem createSearchItemWithSearch:@"robert guthrie"]];
}

- (void)testSave
{
    NSArray<SGISearchItem *> *items = self.defaultItems;
    [self.sut saveSearches:items];
    [[NSFileManager defaultManager] fileExistsAtPath:self.tempFilename];
}

- (void)testLoad
{
    NSArray<SGISearchItem *> *items = self.defaultItems;
    [self.sut saveSearches:items];

    NSArray<SGISearchItem *> *loadedItems = [self.sut loadSearches];
    XCTAssertNotNil(loadedItems);
    XCTAssertTrue([loadedItems isKindOfClass:[NSArray class]]);
    XCTAssertEqual(loadedItems.count, items.count);

    for (int i = 0; i < items.count; i++)
    {
        XCTAssertEqual(items[i].searchId, loadedItems[i].searchId);
        XCTAssertEqualObjects(items[i].search, loadedItems[i].search);
    }
}

@end
