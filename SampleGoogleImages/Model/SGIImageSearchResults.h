//
//  SGIImageSearchResults.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGIImageSearchResultItem;

@interface SGIImageSearchResults : NSObject

@property (nonatomic) NSInteger totalEstimatedResults;
@property (nonatomic) NSArray<SGIImageSearchResultItem *> *images;

+ (SGIImageSearchResults *)fromJson:(NSDictionary *)json;

- (void)aggregate:(SGIImageSearchResults *)newPage;

@end
