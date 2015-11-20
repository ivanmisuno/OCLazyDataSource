//
//  Test_SGIImageSearchManager.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SGIImageSearchManager.h"

@interface Test_SGIImageSearchManager : XCTestCase

@property (nonatomic, readonly) SGIImageSearchManager *sut;
@end

@implementation Test_SGIImageSearchManager

- (void)setUp
{
    [super setUp];
    _sut = [SGIImageSearchManager new];
}

- (void)testRefererHeaderExists
{
    NSDictionary *additionalHeaders = self.sut.defaultConfiguration.HTTPAdditionalHeaders;
    XCTAssertNotEqualObjects(additionalHeaders[@"Referer"], @"");
}

@end
