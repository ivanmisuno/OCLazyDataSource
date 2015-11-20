//
//  Test_SGINetworkManager.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SGINetworkManager.h"

@interface Test_SGINetworkManager : XCTestCase

@property (nonatomic) SGINetworkManager *sut;

@end

@implementation Test_SGINetworkManager

- (void)setUp
{
    [super setUp];
    _sut = [SGINetworkManager new];
}

- (void)testDefaultConfigurationExists
{
    XCTAssertNotNil(self.sut.defaultConfiguration);
}

@end
