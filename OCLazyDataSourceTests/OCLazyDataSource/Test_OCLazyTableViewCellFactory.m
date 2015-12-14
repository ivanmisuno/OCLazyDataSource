//
//  Test_OCLazyTableViewCellFactory.m
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "OCLazyTableViewCellFactory.h"
#import "OCLazySampleTableCell.h"
@import Nimble;

static NSString *const kReuseIdentifier = @"ReuseIdentifier";

@interface Test_OCLazyTableViewCellFactory : XCTestCase <UITableViewDataSource>
@property (nonatomic, readonly) UITableView *tableView;
@end

@implementation Test_OCLazyTableViewCellFactory

- (void)setUp {
    [super setUp];

    _tableView = [UITableView new];
    _tableView.dataSource = self;
}

- (void)testFactoryWithClassName
{
    Class sutClass = [OCLazySampleTableCell class];
    id<OCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithClass(sutClass, kReuseIdentifier);
    [sut registerWithTableView:self.tableView];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [sut dequeueTableViewCell:self.tableView forIndexPath:indexPath];
    expect(cell).toNot(beNil());
    expect(cell).to(beAKindOf(sutClass));
}

- (void)testFactoryWithNib
{
    UINib *sutNib = [UINib nibWithNibName:@"OCLazySampleTableCell" bundle:[NSBundle bundleForClass:[OCLazySampleTableCell class]]];
    id<OCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithNib(sutNib, kReuseIdentifier);
    [sut registerWithTableView:self.tableView];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [sut dequeueTableViewCell:self.tableView forIndexPath:indexPath];
    expect(cell).toNot(beNil());
    expect(cell).to(beAKindOf([OCLazySampleTableCell class]));
}

- (void)testFactoryWithStyle
{
    id<OCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleSubtitle, kReuseIdentifier);
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
