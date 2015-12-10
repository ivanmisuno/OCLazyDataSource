//
//  Test_BCLazyDataSourceSection.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCLazyDataSourceSection.h"
#import "BCLazyDataSourceEnumerator.h"
#import "BCLazyDataSourceItem.h"
#import "NSArray+BCLazyDataSourceEnumerable.h"
@import NSEnumeratorLinq;
@import Nimble;

@interface Test_BCLazyDataSourceSection : XCTestCase
@property (nonatomic, readonly) NSArray *testCollection;
@end

@implementation Test_BCLazyDataSourceSection

- (void)setUp {
    [super setUp];
    _testCollection = @[@1, @2, @3, @4, @5];
}

- (void)testSectionEnumeration
{
    id<BCLazyDataSourceSection> section = lazyDataSourceSection(self.testCollection);

    expect(@([[section.enumerator asNSEnumerator] count])).to(equal(@(self.testCollection.count)));

    NSEnumerator *sourceEnumerator = self.testCollection.objectEnumerator;
    [[section.enumerator asNSEnumerator] all:^BOOL (NSObject<BCLazyDataSourceItem> *lazyDataSourceItem) {
        expect(@([lazyDataSourceItem conformsToProtocol:@protocol(BCLazyDataSourceItem)])).to(beTrue());
        expect(lazyDataSourceItem.sourceItem).to(equal([sourceEnumerator nextObject]));
        expect(lazyDataSourceItem.section).to(equal(section));
        return YES;
    }];
}

@end
