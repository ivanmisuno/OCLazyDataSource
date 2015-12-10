//
//  Test_BCLazyDataSourceFlatteningEnumerator.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCLazyDataSourceEnumerator.h"
#import "BCLazyDataSourceFlatteningEnumerator.h"
@import NSEnumeratorLinq;
@import Nimble;

@interface Test_BCLazyDataSourceFlatteningEnumerator : XCTestCase
@end

@implementation Test_BCLazyDataSourceFlatteningEnumerator

- (void)setUp
{
    [super setUp];
}

- (void)testFlatteningEnumeratorAlreadyFlat
{
    NSArray *testCollection = @[@1, @2, @3, @4, @5];
    id<BCLazyDataSourceEnumerator> (^enumerator)() = ^id<BCLazyDataSourceEnumerator> { return lazyDataSourceFlatteningEnumeratorWithNSEnumerator(testCollection.objectEnumerator); };

    expect(@([[enumerator() asNSEnumerator] count])).to(equal(@(testCollection.count)));
    expect([enumerator() asNSEnumerator].allObjects).to(equal(testCollection));
}

- (void)testFlatteningEnumeratorOneLevelDeep
{
    NSArray *flatCollection = @[@1, @2, @3, @4, @5];

    NSArray *testCollection = @[@[@1, @2], @[@3, @4, @5]];
    id<BCLazyDataSourceEnumerator> (^enumerator)() = ^id<BCLazyDataSourceEnumerator> { return lazyDataSourceFlatteningEnumeratorWithNSEnumerator(testCollection.objectEnumerator); };

    expect(@([[enumerator() asNSEnumerator] count])).to(equal(@(flatCollection.count)));
    expect([enumerator() asNSEnumerator].allObjects).to(equal(flatCollection));
}

- (void)testFlatteningEnumeratorArbitraryLevelDeep
{
    NSArray *flatCollection = @[@1, @2, @3, @4, @5];

    NSArray *testCollection = @[@[@[@[@[@[@1]], @2], @3], @4], @5];
    id<BCLazyDataSourceEnumerator> (^enumerator)() = ^id<BCLazyDataSourceEnumerator> { return lazyDataSourceFlatteningEnumeratorWithNSEnumerator(testCollection.objectEnumerator); };

    expect(@([[enumerator() asNSEnumerator] count])).to(equal(@(flatCollection.count)));
    expect([enumerator() asNSEnumerator].allObjects).to(equal(flatCollection));
}

@end
