//
//  SGISavedSearchesManager.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGISearchItem;

@interface SGISavedSearchesManager : NSObject

+ (NSString *)defaultSavedSearchesFilePath;

@property (nonatomic) NSString *savedSearchesFilePath;

- (NSArray<SGISearchItem *> *)loadSearches;
- (void)saveSearches:(NSArray<SGISearchItem *> *)searches;

@end
