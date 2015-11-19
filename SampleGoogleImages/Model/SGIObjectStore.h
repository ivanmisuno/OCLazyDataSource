//
//  SGIObjectStore.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 19/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGISearchItem;

@interface SGIObjectStore : NSObject

+ (NSString * _Nonnull)defaultSavedSearchesFilePath;

@property (nonatomic) NSString * _Nonnull savedSearchesFilePath;

- (NSArray<SGISearchItem *> * _Nonnull)loadSearches;
- (void)saveSearches:(NSArray<SGISearchItem *> * _Nonnull)searches;

@end
