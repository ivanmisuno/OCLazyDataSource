//
//  SGIJsonStorageManager.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIJsonStorageManager.h"
#import "SGIJSONConvertibleProtocol.h"

@interface NSObject(SGIJsonSerializable)
+ (NSArray<NSDictionary *> * _Nonnull)toJsonArray:(NSArray<NSObject<SGIJSONConvertibleProtocol> *> * _Nonnull)itemArray;
+ (NSArray<NSObject<SGIJSONConvertibleProtocol> *> * _Nonnull)fromJsonArray:(NSArray<NSDictionary *> * _Nonnull)jsonArray;
@end

@interface SGIJsonStorageManager()
@end

@implementation SGIJsonStorageManager

+ (void)loadArrayOfClass:(Class _Nonnull)cls
            fromJsonFile:(NSString * _Nonnull)filePath
              completion:(void(^ _Nonnull)(NSArray<NSObject<SGIJSONConvertibleProtocol> *> * _Nonnull result, NSError * _Nullable error))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        void(^callback)(NSArray<NSObject<SGIJSONConvertibleProtocol> *> *result, NSError *error) = ^(NSArray<NSObject<SGIJSONConvertibleProtocol> *> *result, NSError *error)
        {
            if (completion)
            {
                completion(result, error);
            }
        };

        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        if (!jsonData)
        {
            callback(@[], [NSError errorWithDomain:@"SGIJsonStorageManager" code:-1/*define error codes!*/ userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"File not found", nil)}]);
            return;
        }

        NSError *error = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error)
        {
            callback(@[], [NSError errorWithDomain:@"SGIJsonStorageManager" code:-2/*define error codes!*/ userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"JSON formatting error", nil), NSUnderlyingErrorKey:error}]);
            return;
        }

        if (![jsonArray isKindOfClass:[NSArray class]])
        {
            callback(@[], [NSError errorWithDomain:@"SGIJsonStorageManager" code:1/*define error codes!*/ userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Unexpected JSON file structure", nil)}]);
            return;
        }

        if (![cls respondsToSelector:@selector(fromJsonArray:)])
        {
            callback(@[], [NSError errorWithDomain:@"SGIJsonStorageManager" code:2/*define error codes!*/ userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Class does not support deserialization from JSON", nil)}]);
            return;
        }

        NSArray<NSObject<SGIJSONConvertibleProtocol> *> *result = [cls fromJsonArray:jsonArray];
        callback(result, nil);
    });
}

+ (void)saveArray:(NSArray<NSObject<SGIJSONConvertibleProtocol> *> * _Nonnull)array
          ofClass:(Class _Nonnull)cls
       toJsonFile:(NSString * _Nonnull)filePath
       completion:(void(^ _Nonnull)(NSError * _Nullable error))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        void(^callback)(NSError *error) = ^(NSError *error)
        {
            if (completion)
            {
                completion(error);
            }
        };

        if (![cls respondsToSelector:@selector(toJsonArray:)])
        {
            callback([NSError errorWithDomain:@"SGIJsonStorageManager" code:2/*define error codes!*/ userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Class does not support serialization to JSON", nil)}]);
            return;
        }

        NSArray *jsonArray = [cls toJsonArray:(NSArray<id> *)array];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:0 error:&error];
        if (error)
        {
            callback([NSError errorWithDomain:@"SGIJsonStorageManager" code:-2/*define error codes!*/ userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"JSON formatting error", nil), NSUnderlyingErrorKey:error}]);
            return;
        }

        [jsonData writeToFile:filePath atomically:YES];
        callback(nil);
    });
}

@end
