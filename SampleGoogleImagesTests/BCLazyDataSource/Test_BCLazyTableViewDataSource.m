//
//  Test_BCLazyDataSource.m
//
//  Created by Ivan Misuno on 08/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCLazyTableViewDataSource.h"
@import NSEnumeratorLinq;
@import Nimble;

///////////////////////////////////////////////////////////////////////

@interface Test_BCLazyDataSource : XCTestCase
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) BCLazyTableViewDataSource *ds;
@property (nonatomic, readonly) NSArray *dataItems;
@end

@implementation Test_BCLazyDataSource

- (void)validateContentsOfTableView:(UITableView *)tableView withDataSource:(BCLazyTableViewDataSource *)ds
{
    expect(@(tableView.numberOfSections)).to(equal(@([ds.bridgeDataSource numberOfSectionsInTableView:tableView])));
    for (NSInteger section = 0; section < self.tableView.numberOfSections; section++)
    {
        expect(@([tableView numberOfRowsInSection:section])).to(equal(@([ds.bridgeDataSource tableView:tableView numberOfRowsInSection:section])));
    }
}

- (void)setUp
{
    [super setUp];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _dataItems = @[@1, @2, @3, @4, @5];

    _ds = [BCLazyTableViewDataSource new];
    self.tableView.dataSource = self.ds.bridgeDataSource;
    self.tableView.delegate = self.ds.bridgeDataSource;
    
    [self validateContentsOfTableView:self.tableView withDataSource:self.ds];
}

- (void)testExample
{
    expect(self.dataItems).to(haveCount(@5));

    expect([self.dataItems.objectEnumerator take:2].toArray).to(equal(@[@1, @2]));
    expect([self.dataItems.objectEnumerator skip:2].toArray).to(equal(@[@3, @4, @5]));

    NSArray *insert = @[@10, @11, @12];

    NSEnumerator *(^newSequence)() = ^{ return [[[self.dataItems.objectEnumerator take:2]
                                                 concat:insert.objectEnumerator]
                                                concat:[self.dataItems.objectEnumerator skip:2]]; };
    expect(newSequence().toArray).to(haveCount(@(self.dataItems.count + insert.count)));
    expect(@([newSequence() count])).to(equal(@(self.dataItems.count + insert.count)));
    [self.dataItems.objectEnumerator all:^BOOL (id v) {
        expect(newSequence().toArray).to(contain(v));
        return YES;
    }];
    [insert.objectEnumerator all:^BOOL (id v) {
        expect(newSequence().toArray).to(contain(v));
        return YES;
    }];
}

- (void)testEmptyDataSourceObject
{
//    BCLazyReusableCellFactory *factory1 = [[BCLazyReusableCellFactory alloc] initWithClass:[BCLazySampleTableCell class] reuseIdentifier:@"cell1"];
}


@end
