//
//  OCLazyTableViewCellFactorySpec.m
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "OCLazyTableViewCellFactory.h"
#import "OCLazySampleTableCell.h"
@import Nimble;
@import Quick;

static NSString *const kReuseIdentifier = @"ReuseIdentifier";

@interface OCLazyTableViewCellFactoryMockDataSource : NSObject<UITableViewDataSource>
@end
@implementation OCLazyTableViewCellFactoryMockDataSource
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

QuickSpecBegin(OCLazyTableViewCellFactorySpec)

describe(@"OCLazyTableViewCellFactory", ^{
    __block UITableView *tableView;
    __block OCLazyTableViewCellFactoryMockDataSource *mockDataSource;
    beforeEach(^{
        mockDataSource = [OCLazyTableViewCellFactoryMockDataSource new];
        tableView = [UITableView new];
        tableView.dataSource = mockDataSource;
    });

    it(@"TableViewCellFactoryWithClass -> produces cells of specified class", ^{
        Class sutClass = [OCLazySampleTableCell class];
        id<OCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithClass(sutClass, kReuseIdentifier);
        [sut registerWithTableView:tableView];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [sut dequeueTableViewCell:tableView forIndexPath:indexPath withModelObject:@0];
        expect(cell).toNot(beNil());
        expect(cell).to(beAKindOf(sutClass));
    });

    it(@"TableViewCellFactoryWithNib -> produces cells loaded from specified nib", ^{
        UINib *sutNib = [UINib nibWithNibName:@"OCLazySampleTableCell" bundle:[NSBundle bundleForClass:[OCLazySampleTableCell class]]];
        id<OCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithNib(sutNib, kReuseIdentifier);
        [sut registerWithTableView:tableView];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [sut dequeueTableViewCell:tableView forIndexPath:indexPath withModelObject:@0];
        expect(cell).toNot(beNil());
        expect(cell).to(beAKindOf([OCLazySampleTableCell class]));
    });

    it(@"TableViewCellFactoryWithStyle -> produces just UITableViewCells", ^{
        id<OCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleSubtitle, kReuseIdentifier);
        [sut registerWithTableView:tableView];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [sut dequeueTableViewCell:tableView forIndexPath:indexPath withModelObject:@0];
        expect(cell).toNot(beNil());
        expect(cell).to(beAnInstanceOf([UITableViewCell class]));
    });

    it(@"TableViewCellFactoryWithRegisterAndDequeueBlocks -> blocks get called", ^{
        __block BOOL registerBlockCalled = NO;
        __block BOOL dequeueBlockCalled = NO;
        id<OCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithRegisterAndDequeueBlocks(/*registerBlock*/^(UITableView * _Nonnull tableView_) {
            registerBlockCalled = YES;
        }, /*dequeueBlock*/^UITableViewCell * _Nonnull(id  _Nonnull model, UITableView * _Nonnull tableView_, NSIndexPath * _Nonnull indexPath) {
            dequeueBlockCalled = YES;
            return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        });

        [sut registerWithTableView:tableView];
        expect(@(registerBlockCalled)).to(beTrue());

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        __unused UITableViewCell *cell = [sut dequeueTableViewCell:tableView forIndexPath:indexPath withModelObject:@0];
        expect(@(dequeueBlockCalled)).to(beTrue());
    });

    it(@"TableViewCellFactoryWithRegisterAndDequeueBlocks -> dequeueBlock returning nil causes assertion", ^{
        id<OCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithRegisterAndDequeueBlocks(/*registerBlock*/^(UITableView * _Nonnull tableView_) {
        }, /*dequeueBlock*/^UITableViewCell * _Nonnull(id  _Nonnull model, UITableView * _Nonnull tableView_, NSIndexPath * _Nonnull indexPath) {
            return nil;
        });

        expectAction(^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            __unused UITableViewCell *cell = [sut dequeueTableViewCell:tableView forIndexPath:indexPath withModelObject:@0];
        }).to(raiseException());
    });

});

QuickSpecEnd
