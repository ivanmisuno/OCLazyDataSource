//
//  SGIJsonStorageManager.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGISearchItem;
@protocol SGIJSONConvertibleProtocol;

@interface SGIJsonStorageManager : NSObject

// loads data asynchronously on the system background queue
// calls back on background queue
+ (void)loadArrayOfClass:(Class _Nonnull)cls
            fromJsonFile:(NSString * _Nonnull)filePath
              completion:(void(^ _Nonnull)(NSArray<NSObject<SGIJSONConvertibleProtocol> *> * _Nonnull result, NSError * _Nullable error))completion;

// saves data asynchronously on the system background queue
// calls back on background queue
+ (void)saveArray:(NSArray<NSObject<SGIJSONConvertibleProtocol> *> * _Nonnull)array
          ofClass:(Class _Nonnull)cls
       toJsonFile:(NSString * _Nonnull)filePath
       completion:(void(^ _Nonnull)(NSError * _Nullable error))completion;

@end
