//
//  Test_SGIJsonStorageManager.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 19/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SGIJsonStorageManager.h"
#import "NSFileManager+SGICommonDirectories.h"

@interface ClassDoesNotSupportJsonArrayDecoding : NSObject
@end
@implementation ClassDoesNotSupportJsonArrayDecoding
@end

@interface ClassSupportsJsonArrayEncoding : NSObject
@end
@implementation ClassSupportsJsonArrayEncoding
+ (NSArray<NSDictionary *> * _Nonnull)toJsonArray:(NSArray<ClassSupportsJsonArrayEncoding *> * _Nonnull)itemArray
{
    return @[];
}
@end

@interface Test_SGIJsonStorageManager : XCTestCase

@property (nonatomic, readonly) NSString *filePathMissingFile;
@property (nonatomic, readonly) NSString *filePathNotAJsonFile;
@property (nonatomic, readonly) NSString *filePathJsonDictionary;
@property (nonatomic, readonly) NSString *filePathNormalJson;

@property (nonatomic, readonly) NSString *filePathTemp;

@end

@implementation Test_SGIJsonStorageManager

- (void)setUp
{
    [super setUp];

    _filePathMissingFile = @"/a/definitely/missing/file";
    _filePathNotAJsonFile = [[NSFileManager sgi_cachesDir] stringByAppendingPathComponent:@"not_a_json.txt"];
    _filePathJsonDictionary = [[NSFileManager sgi_cachesDir] stringByAppendingPathComponent:@"root_dictionary.json"];
    _filePathNormalJson = [[NSFileManager sgi_cachesDir] stringByAppendingPathComponent:@"normal.json"];
    _filePathTemp = [[NSFileManager sgi_cachesDir] stringByAppendingPathComponent:@"temp.json"];

    NSError *error = nil;

    XCTAssertTrue([@"~just a text" writeToFile:self.filePathNotAJsonFile atomically:YES encoding:NSUTF8StringEncoding error:&error]);
    XCTAssertNil(error);

    XCTAssertTrue([@"{\"root\":\"text\"}" writeToFile:self.filePathJsonDictionary atomically:YES encoding:NSUTF8StringEncoding error:&error]);
    XCTAssertNil(error);

    XCTAssertTrue([@"[]" writeToFile:self.filePathNormalJson atomically:YES encoding:NSUTF8StringEncoding error:&error]);
    XCTAssertNil(error);
}
- (void)tearDown
{
    [super tearDown];
    [[NSFileManager defaultManager] removeItemAtPath:self.filePathNotAJsonFile error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.filePathJsonDictionary error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.filePathNormalJson error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.filePathTemp error:nil];
}

// the normal operation of SGIJsonStorageManager is tested well in Test_SGIObjectStore
// test edge cases here

- (void)testLoadDefinitelyMissingFile
{
    XCTestExpectation *expect = [self expectationWithDescription:@"test"];

    __block id resultResult = nil;
    __block NSError *resultError = nil;
    [SGIJsonStorageManager loadArrayOfClass:[ClassDoesNotSupportJsonArrayDecoding class]
                               fromJsonFile:self.filePathMissingFile
                                 completion:^(NSArray<NSObject<SGIJSONConvertibleProtocol> *> * _Nonnull result, NSError * _Nullable error) {
                                     resultResult = result;
                                     resultError = error;
                                     [expect fulfill];
                                 }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    XCTAssertNotNil(resultResult); // should still return an empty array
    XCTAssertTrue([resultResult isKindOfClass:[NSArray class]]);
    XCTAssertTrue([resultResult count] == 0);
    XCTAssertNotNil(resultError);
    XCTAssertEqual(resultError.code, -1);
}
- (void)testLoadNotAJsonFile
{
    XCTestExpectation *expect = [self expectationWithDescription:@"test"];

    __block id resultResult = nil;
    __block NSError *resultError = nil;
    [SGIJsonStorageManager loadArrayOfClass:[ClassDoesNotSupportJsonArrayDecoding class]
                               fromJsonFile:self.filePathNotAJsonFile
                                 completion:^(NSArray<NSObject<SGIJSONConvertibleProtocol> *> * _Nonnull result, NSError * _Nullable error) {
                                     resultResult = result;
                                     resultError = error;
                                     [expect fulfill];
                                 }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    XCTAssertNotNil(resultResult); // should still return an empty array
    XCTAssertTrue([resultResult isKindOfClass:[NSArray class]]);
    XCTAssertTrue([resultResult count] == 0);
    XCTAssertNotNil(resultError);
    XCTAssertEqual(resultError.code, -2);
    XCTAssertNotNil(resultError.userInfo[NSUnderlyingErrorKey]);
}
- (void)testLoadJsonRootNotAnArray
{
    XCTestExpectation *expect = [self expectationWithDescription:@"test"];

    __block id resultResult = nil;
    __block NSError *resultError = nil;
    [SGIJsonStorageManager loadArrayOfClass:[ClassDoesNotSupportJsonArrayDecoding class]
                               fromJsonFile:self.filePathJsonDictionary
                                 completion:^(NSArray<NSObject<SGIJSONConvertibleProtocol> *> * _Nonnull result, NSError * _Nullable error) {
                                     resultResult = result;
                                     resultError = error;
                                     [expect fulfill];
                                 }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    XCTAssertNotNil(resultResult); // should still return an empty array
    XCTAssertTrue([resultResult isKindOfClass:[NSArray class]]);
    XCTAssertTrue([resultResult count] == 0);
    XCTAssertNotNil(resultError);
    XCTAssertEqual(resultError.code, 1);
}
- (void)testLoadClassDoesNotSupportJsonDecoding
{
    XCTestExpectation *expect = [self expectationWithDescription:@"test"];

    __block id resultResult = nil;
    __block NSError *resultError = nil;
    [SGIJsonStorageManager loadArrayOfClass:[ClassDoesNotSupportJsonArrayDecoding class]
                               fromJsonFile:self.filePathNormalJson
                                 completion:^(NSArray<NSObject<SGIJSONConvertibleProtocol> *> * _Nonnull result, NSError * _Nullable error) {
                                     resultResult = result;
                                     resultError = error;
                                     [expect fulfill];
                                 }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    XCTAssertNotNil(resultResult); // should still return an empty array
    XCTAssertTrue([resultResult isKindOfClass:[NSArray class]]);
    XCTAssertTrue([resultResult count] == 0);
    XCTAssertNotNil(resultError);
    XCTAssertEqual(resultError.code, 2);
}

- (void)testWriteClassDoesNotSupportJsonEncoding
{
    XCTestExpectation *expect = [self expectationWithDescription:@"test"];

    __block NSError *resultError = nil;
    [SGIJsonStorageManager saveArray:@[]
                             ofClass:[ClassDoesNotSupportJsonArrayDecoding class]
                          toJsonFile:self.filePathTemp
                          completion:^(NSError * _Nullable error) {
                              resultError = error;
                              [expect fulfill];
                          }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    XCTAssertNotNil(resultError);
    XCTAssertEqual(resultError.code, 2);
}

- (void)testWriteClassCouldNotWriteFile
{
    XCTestExpectation *expect = [self expectationWithDescription:@"test"];

    __block NSError *resultError = nil;
    [SGIJsonStorageManager saveArray:@[]
                             ofClass:[ClassSupportsJsonArrayEncoding class]
                          toJsonFile:self.filePathMissingFile
                          completion:^(NSError * _Nullable error) {
                              resultError = error;
                              [expect fulfill];
                          }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    XCTAssertNotNil(resultError);
    XCTAssertEqual(resultError.code, -1);
}

- (void)testWriteOk
{
    XCTestExpectation *expect = [self expectationWithDescription:@"test"];

    __block NSError *resultError = nil;
    [SGIJsonStorageManager saveArray:@[]
                             ofClass:[ClassSupportsJsonArrayEncoding class]
                          toJsonFile:self.filePathTemp
                          completion:^(NSError * _Nullable error) {
                              resultError = error;
                              [expect fulfill];
                          }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    XCTAssertNil(resultError);
}

@end
