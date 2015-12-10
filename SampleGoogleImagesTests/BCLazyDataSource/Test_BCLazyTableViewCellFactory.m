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

static NSString *const kReuseIdentifier = @"ReuseIdentifier";

@interface Test_BCLazyTableViewCellFactory : XCTestCase
@property (nonatomic, readonly) id mockTableView;
@end

@implementation Test_BCLazyTableViewCellFactory

- (void)setUp {
    [super setUp];

    _mockTableView = OCMStrictClassMock([UITableView class]);
}

- (void)testFactoryWithClassName
{
    Class sutClass = [BCLazySampleTableCell class];
    id<BCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithClass(sutClass, kReuseIdentifier);

    [[self.mockTableView expect] registerClass:sutClass forCellReuseIdentifier:kReuseIdentifier];
    [sut registerWithTableView:self.mockTableView];
    OCMVerifyAll(self.mockTableView);
}

- (void)testFactoryWithNib
{
    UINib *sutNib = [UINib nibWithNibName:@"BCLazySampleTableCell" bundle:[NSBundle bundleForClass:[BCLazySampleTableCell class]]];
    id<BCLazyTableViewCellFactory> sut = lazyTableViewCellFactoryWithNib(sutNib, kReuseIdentifier);

    [[self.mockTableView expect] registerNib:sutNib forCellReuseIdentifier:kReuseIdentifier];
    [sut registerWithTableView:self.mockTableView];
    OCMVerifyAll(self.mockTableView);
}

@end
