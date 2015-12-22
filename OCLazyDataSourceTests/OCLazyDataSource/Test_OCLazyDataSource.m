//
//  Test_OCLazyDataSource.m
//
//  Created by Ivan Misuno on 08/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCLazyDataSource.h"
@import NSEnumeratorLinq;
@import Nimble;

///////////////////////////////////////////////////////////////////////

@interface Test_OCLazyDataSource : XCTestCase
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) id<OCLazyDataSource> ds;
@property (nonatomic, readonly) id<OCLazyDataSourceBridge, UITableViewDataSource, UITableViewDelegate> bridge;
@end

@implementation Test_OCLazyDataSource

- (void)validateContentsOfTableView
{
    expect(@(self.tableView.numberOfSections)).to(equal(@([self.bridge numberOfSectionsInTableView:self.tableView])));
    for (NSInteger section = 0; section < self.tableView.numberOfSections; section++)
    {
        expect(@([self.tableView numberOfRowsInSection:section])).to(equal(@([self.bridge tableView:self.tableView numberOfRowsInSection:section])));
    }
}

- (void)setUp
{
    [super setUp];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];

    _bridge = lazyDataSourceBridgeForTableView(self.tableView);
    _ds = lazyDataSourceWithBridge(self.bridge);

    [self validateContentsOfTableView];
}

- (void)testEmptyDataSourceObject
{
    [self validateContentsOfTableView];
    expect(@([self.tableView numberOfSections])).to(equal(@(0)));
}

- (void)testNonConformingSource
{
    expectAction((^{
        NSArray *dataItems1 = @[@1, @2, @3, @4, @5];
        [self.ds setSource:dataItems1];
    })).to(raiseException());
}

- (void)testSingleSection
{
    NSArray *dataItems1 = @[@1, @2, @3, @4, @5];
    id<OCLazyTableViewCellFactory> factory1 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"reuseIdentifier1");
    id<OCLazyDataSourceSection> section1 = lazyDataSourceSectionWithEnumerable(dataItems1, factory1);
    [self.ds setSource:section1];

    [self validateContentsOfTableView];
    expect(@([self.tableView numberOfSections])).to(equal(@(1)));
    expect(@([self.tableView numberOfRowsInSection:0])).to(equal(@(dataItems1.count)));
}

- (void)testTwoSectionsArray
{
    NSArray *dataItems1 = @[@1, @2, @3, @4, @5];
    id<OCLazyTableViewCellFactory> factory1 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"reuseIdentifier1");
    id<OCLazyDataSourceSection> section1 = lazyDataSourceSectionWithEnumerable(dataItems1, factory1);

    NSArray *dataItems2 = @[@11, @12, @13];
    id<OCLazyTableViewCellFactory> factory2 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"reuseIdentifier2");
    id<OCLazyDataSourceSection> section2 = lazyDataSourceSectionWithEnumerable(dataItems2, factory2);

    NSArray *sections = @[section1, section2];
    [self.ds setSource:sections];

    [self validateContentsOfTableView];
    expect(@([self.tableView numberOfSections])).to(equal(@(2)));
    expect(@([self.tableView numberOfRowsInSection:0])).to(equal(@(dataItems1.count)));
    expect(@([self.tableView numberOfRowsInSection:1])).to(equal(@(dataItems2.count)));
}

- (void)testTwoSectionsEnumerable
{
    NSArray *dataItems1 = @[@1, @2, @3, @4, @5];
    id<OCLazyTableViewCellFactory> factory1 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"reuseIdentifier1");
    id<OCLazyDataSourceSection> section1 = lazyDataSourceSectionWithEnumerable(dataItems1, factory1);

    NSArray *dataItems2 = @[@11, @12, @13];
    id<OCLazyTableViewCellFactory> factory2 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"reuseIdentifier2");
    id<OCLazyDataSourceSection> section2 = lazyDataSourceSectionWithEnumerable(dataItems2, factory2);

    id<OCLazyDataSourceEnumerator> (^section1Enumerator)() = ^{ return section1.enumerator; };
    id<OCLazyDataSourceEnumerator> (^section2Enumerator)() = ^{ return section2.enumerator; };

    id<OCLazyDataSourceEnumerator> (^sectionGenerator)() = ^{
        NSEnumerator* enumerator = [section1Enumerator().asNSEnumerator
                concat:section2Enumerator().asNSEnumerator];
        return lazyDataSourceEnumeratorWithNSEnumerator(enumerator);
    };

    [self.ds setSource:lazyDataSourceEnumerableWithGeneratorBlock(sectionGenerator)];

    [self validateContentsOfTableView];
    expect(@([self.tableView numberOfSections])).to(equal(@(2)));
    expect(@([self.tableView numberOfRowsInSection:0])).to(equal(@(dataItems1.count)));
    expect(@([self.tableView numberOfRowsInSection:1])).to(equal(@(dataItems2.count)));
}

- (void)testSequencesManipulation
{
    NSArray *dataItems = @[@1, @2, @3, @4, @5];

    expect(dataItems).to(haveCount(@5));
    expect([dataItems.objectEnumerator take:2].toArray).to(equal(@[@1, @2]));
    expect([dataItems.objectEnumerator skip:2].toArray).to(equal(@[@3, @4, @5]));

    NSArray *insert = @[@11, @12, @13];

    NSEnumerator *(^newSequence)() = ^{ return [[[dataItems.objectEnumerator take:2]
                                                 concat:insert.objectEnumerator]
                                                concat:[dataItems.objectEnumerator skip:2]]; };
    expect(newSequence().toArray).to(haveCount(@(dataItems.count + insert.count)));
    expect(@([newSequence() count])).to(equal(@(dataItems.count + insert.count)));
    [dataItems.objectEnumerator all:^BOOL (id v) {
        expect(newSequence().toArray).to(contain(v));
        return YES;
    }];
    [insert.objectEnumerator all:^BOOL (id v) {
        expect(newSequence().toArray).to(contain(v));
        return YES;
    }];
}

- (void)testTwoLogicalSectionsBecomeThreePhysical
{
    NSArray *dataItems1 = @[@1, @2, @3, @4, @5];
    id<OCLazyTableViewCellFactory> factory1 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"reuseIdentifier1");
    id<OCLazyDataSourceSection> section1 = lazyDataSourceSectionWithEnumerable(dataItems1, factory1);

    NSArray *dataItems2 = @[@11, @12, @13];
    id<OCLazyTableViewCellFactory> factory2 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"reuseIdentifier2");
    id<OCLazyDataSourceSection> section2 = lazyDataSourceSectionWithEnumerable(dataItems2, factory2);

    id<OCLazyDataSourceEnumerator> (^section1Enumerator)() = ^{ return section1.enumerator; };
    id<OCLazyDataSourceEnumerator> (^section2Enumerator)() = ^{ return section2.enumerator; };

    id<OCLazyDataSourceEnumerator> (^sectionGenerator)() = ^{
        NSEnumerator* enumerator = [[[section1Enumerator().asNSEnumerator take:2]
                                    concat:section2Enumerator().asNSEnumerator]
                                    concat:[section1Enumerator().asNSEnumerator skip:2]];
        return lazyDataSourceEnumeratorWithNSEnumerator(enumerator);
    };

    [self.ds setSource:lazyDataSourceEnumerableWithGeneratorBlock(sectionGenerator)];

    [self validateContentsOfTableView];
    expect(@([self.tableView numberOfSections])).to(equal(@(3)));
    expect(@([self.tableView numberOfRowsInSection:0])).to(equal(@(2)));
    expect(@([self.tableView numberOfRowsInSection:1])).to(equal(@(dataItems2.count)));
    expect(@([self.tableView numberOfRowsInSection:2])).to(equal(@(dataItems1.count - 2)));
}

@end
