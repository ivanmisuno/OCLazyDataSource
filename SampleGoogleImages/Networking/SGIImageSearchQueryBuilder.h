//
//  SGIImageSearchQueryBuilder.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGIImageSearchQueryBuilder : NSObject

+ (instancetype)queryBuilderWithSearch:(NSString *)search;
+ (instancetype)queryBuilderWithSearch:(NSString *)search startIndex:(NSInteger)startIndex;

@property (nonatomic, readonly, copy) NSURL *URL;

@end
