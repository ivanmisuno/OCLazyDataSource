//
//  Test_BCLazyDataSourceEnumerator.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCLazyDataSourceEnumerator.h"
@import NSEnumeratorLinq;
@import Nimble;

@interface Test_BCLazyDataSourceEnumerator : XCTestCase
@property (nonatomic, readonly) NSArray *testCollection;
@end

@implementation Test_BCLazyDataSourceEnumerator

- (void)setUp
{
    [super setUp];
    _testCollection = @[@1, @2, @3, @4, @5];
}

- (void)testLazyEnumeratorWithEnumerator
{
    id<BCLazyDataSourceEnumerator> (^enumerator)() = ^id<BCLazyDataSourceEnumerator> { return lazyDataSourceEnumeratorWithEnumerator(self.testCollection.objectEnumerator); };

    expect(@([[enumerator() asNSEnumerator] count])).to(equal(@(self.testCollection.count)));
    expect([enumerator() asNSEnumerator].allObjects).to(equal(self.testCollection));
}

- (void)testLazyEnumeratorWithBlock
{
    id<BCLazyDataSourceEnumerator> (^enumerator)() = ^id<BCLazyDataSourceEnumerator> {
        NSEnumerator *sourceEnumerator = self.testCollection.objectEnumerator;
        return lazyDataSourceEnumeratorWithBlock(^id _Nullable{
            return [sourceEnumerator nextObject];
        });
    };

    expect(@([[enumerator() asNSEnumerator] count])).to(equal(@(self.testCollection.count)));
    expect([enumerator() asNSEnumerator].allObjects).to(equal(self.testCollection));
}

@end
