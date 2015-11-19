//
//  SGIObjectStore.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 19/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIObjectStore.h"
#import "SGIJsonStorageManager.h"
#import "NSFileManager+SGICommonDirectories.h"
#import "SGISearchItem.h"

@implementation SGIObjectStore

+ (NSString * _Nonnull)defaultSavedSearchesFilePath
{
    return [[NSFileManager sgi_documentsDir] stringByAppendingPathComponent:@"searches.json"];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.savedSearchesFilePath = [[self class] defaultSavedSearchesFilePath];
    }
    return self;
}

- (NSArray<SGISearchItem *> * _Nonnull)loadSearches
{
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    __block NSArray<SGISearchItem *> *loadedSearches = nil;
    [SGIJsonStorageManager loadArrayOfClass:[SGISearchItem class]
                               fromJsonFile:self.savedSearchesFilePath
                                 completion:^(NSArray<NSObject *> * _Nonnull result, NSError * _Nullable error) {
                                     loadedSearches = (NSArray<id> *)result;
                                     dispatch_semaphore_signal(sem);
                                 }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    return loadedSearches;
}

- (void)saveSearches:(NSArray<SGISearchItem *> * _Nonnull)searches
{
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [SGIJsonStorageManager saveArray:searches
                             ofClass:[SGISearchItem class]
                          toJsonFile:self.savedSearchesFilePath
                          completion:^(NSError * _Nullable error) {
                              dispatch_semaphore_signal(sem);
                          }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

@end
