//
//  Test_SGILazyDataSource.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 08/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SGILazyDataSource.h"
@import OCTotallyLazy;
@import Nimble;

@interface Test_SGILazyDataSource : XCTestCase

@property (nonatomic, readonly) NSArray *dataItems;

@end

@implementation Test_SGILazyDataSource

- (void)setUp
{
    [super setUp];
    _dataItems = @[@1, @2, @3, @4, @5];
}

- (void)testExample
{
    expect(self.dataItems).to(haveCount(@5));

    expect([self.dataItems take:2]).to(equal(@[@1, @2]));
    expect([self.dataItems drop:2]).to(equal(@[@3, @4, @5]));

    NSArray *insert = @[@10, @11, @12];

    NSArray *newSequence = [[[self.dataItems take:2]
                            join:insert]
                            join:[self.dataItems drop:2]];
    expect(newSequence).to(haveCount(@(self.dataItems.count + insert.count)));
    [self.dataItems foreach:^(id v) {
        expect(newSequence).to(contain(v));
    }];
    [insert foreach:^(id v) {
        expect(newSequence).to(contain(v));
    }];
}

@end
