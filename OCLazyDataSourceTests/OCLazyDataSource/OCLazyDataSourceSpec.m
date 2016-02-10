//
//  OCLazyDataSourceSpec.m
//
//  Created by Ivan Misuno on 08/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCLazyDataSource.h"
@import NSEnumeratorLinq;
@import Nimble;
@import Quick;

QuickSpecBegin(OCLazyDataSourceSpec)

describe(@"OCLazyDataSource", ^{
    __block UITableView *tableView;
    __block id<OCLazyDataSource> ds;
    __block id<OCLazyDataSourceBridge, UITableViewDataSource, UITableViewDelegate> bridge;

    void(^validateContentsOfTableView)() = ^{
        expect(@(tableView.numberOfSections)).to(equal(@([bridge numberOfSectionsInTableView:tableView])));
        for (NSInteger section = 0; section < tableView.numberOfSections; section++)
        {
            expect(@([tableView numberOfRowsInSection:section])).to(equal(@([bridge tableView:tableView numberOfRowsInSection:section])));
        }
    };

    beforeEach(^{
        tableView = [[UITableView alloc] initWithFrame:CGRectZero];

        bridge = lazyDataSourceBridgeForTableView(tableView);
        ds = lazyDataSourceWithBridge(bridge);

        validateContentsOfTableView();
    });

    it(@"Empty data source -> empty table", ^{
        validateContentsOfTableView();
        expect(@([tableView numberOfSections])).to(equal(@(0)));
    });

    it(@"Non-conforming source data -> exception", ^{
        expectAction((^{
            NSArray *dataItems1 = @[@1, @2, @3, @4, @5];
            [ds setSource:dataItems1];
        })).to(raiseException());
    });

    it(@"Single section data source -> table has 1 section", ^{
        NSArray *dataItems1 = @[@1, @2, @3, @4, @5];
        id<OCLazyTableViewCellFactory> factory1 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"reuseIdentifier1");
        id<OCLazyDataSourceSection> section1 = lazyDataSourceSectionWithEnumerable(dataItems1, factory1);
        [ds setSource:section1];

        validateContentsOfTableView();
        expect(@([tableView numberOfSections])).to(equal(@(1)));
        expect(@([tableView numberOfRowsInSection:0])).to(equal(@(dataItems1.count)));
    });

    it(@"Two sections in an array -> table has two sections", ^{
        NSArray *dataItems1 = @[@1, @2, @3, @4, @5];
        id<OCLazyTableViewCellFactory> factory1 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"reuseIdentifier1");
        id<OCLazyDataSourceSection> section1 = lazyDataSourceSectionWithEnumerable(dataItems1, factory1);

        NSArray *dataItems2 = @[@11, @12, @13];
        id<OCLazyTableViewCellFactory> factory2 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"reuseIdentifier2");
        id<OCLazyDataSourceSection> section2 = lazyDataSourceSectionWithEnumerable(dataItems2, factory2);

        NSArray *sections = @[section1, section2];
        [ds setSource:sections];

        validateContentsOfTableView();
        expect(@([tableView numberOfSections])).to(equal(@(2)));
        expect(@([tableView numberOfRowsInSection:0])).to(equal(@(dataItems1.count)));
        expect(@([tableView numberOfRowsInSection:1])).to(equal(@(dataItems2.count)));
    });

    it(@"Two sections as enumerable -> table has two sections", ^{
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

        [ds setSource:lazyDataSourceEnumerableWithGeneratorBlock(sectionGenerator)];

        validateContentsOfTableView();
        expect(@([tableView numberOfSections])).to(equal(@(2)));
        expect(@([tableView numberOfRowsInSection:0])).to(equal(@(dataItems1.count)));
        expect(@([tableView numberOfRowsInSection:1])).to(equal(@(dataItems2.count)));
    });

    it(@"Split+combine sequences -> all source elements are still in the resulting sequence", ^{
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
    });

    it(@"Two logical sections become three physical", ^{
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
        
        [ds setSource:lazyDataSourceEnumerableWithGeneratorBlock(sectionGenerator)];
        
        validateContentsOfTableView();
        expect(@([tableView numberOfSections])).to(equal(@(3)));
        expect(@([tableView numberOfRowsInSection:0])).to(equal(@(2)));
        expect(@([tableView numberOfRowsInSection:1])).to(equal(@(dataItems2.count)));
        expect(@([tableView numberOfRowsInSection:2])).to(equal(@(dataItems1.count - 2)));
    });

});

QuickSpecEnd
