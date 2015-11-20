//
//  Test_SGIImageSearchQueryBuilder.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SGIImageSearchQueryBuilder.h"

@interface Test_SGIImageSearchQueryBuilder : XCTestCase

@property (nonatomic, readonly) SGIImageSearchQueryBuilder *sut;

@end

@implementation Test_SGIImageSearchQueryBuilder

- (void)setUp
{
    [super setUp];
    _sut = [SGIImageSearchQueryBuilder queryBuilderWithSearch:@"robbie williams"];
}

- (void)testURL
{
    XCTAssertNotNil(self.sut.URL);
    XCTAssertEqualObjects(self.sut.URL.scheme, @"https");
    XCTAssertEqualObjects(self.sut.URL.host, @"ajax.googleapis.com");
    XCTAssertEqualObjects(self.sut.URL.path, @"/ajax/services/search/images");
    XCTAssertTrue([self.sut.URL.query containsString:@"robbie%20williams"]);
    XCTAssertTrue([self.sut.URL.query containsString:@"start=0"]);
    XCTAssertTrue([self.sut.URL.query containsString:@"v=1.0"]);
}

@end
