//
//  Test_BCLazyTableViewCellFactory.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "BCLazyTableViewCellFactory.h"
#import "BCLazySampleTableCell.h"
@import Nimble;

static NSString *const kReuseIdentifier = @"ReuseIdentifier";

@interface Test_BCLazyTableViewCellFactory : XCTestCase <UITableViewDataSource>
@property (nonatomic, readonly) UITableView *tableView;
@end

@implementation Test_BCLazyTableViewCellFactory

- (void)setUp {
    [super setUp];

    _tableView = [UITableView new];
    _tableView.dataSource = self;
}

- (void)testFactoryWithClassName
{
    Class sutClass = [BCLazySampleTableCell class];
    id<BCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithClass(sutClass, kReuseIdentifier);
    [sut registerWithTableView:self.tableView];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [sut dequeueTableViewCell:self.tableView forIndexPath:indexPath];
    expect(cell).toNot(beNil());
    expect(cell).to(beAKindOf(sutClass));
}

- (void)testFactoryWithNib
{
    UINib *sutNib = [UINib nibWithNibName:@"BCLazySampleTableCell" bundle:[NSBundle bundleForClass:[BCLazySampleTableCell class]]];
    id<BCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithNib(sutNib, kReuseIdentifier);
    [sut registerWithTableView:self.tableView];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [sut dequeueTableViewCell:self.tableView forIndexPath:indexPath];
    expect(cell).toNot(beNil());
    expect(cell).to(beAKindOf([BCLazySampleTableCell class]));
}

- (void)testFactoryWithStyle
{
    id<BCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleSubtitle, kReuseIdentifier);
    [sut registerWithTableView:self.tableView];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [sut dequeueTableViewCell:self.tableView forIndexPath:indexPath];
    expect(cell).toNot(beNil());
    expect(cell).to(beAnInstanceOf([UITableViewCell class]));
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"should not be called");
    return nil;
}


@end
