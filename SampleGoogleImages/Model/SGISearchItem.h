//
//  SGISearchItem.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGIJSONConvertibleProtocol.h"

@interface SGISearchItem : NSObject <SGIJSONConvertibleProtocol>

@property (nonatomic, readonly) long long searchId;
@property (nonatomic, readonly) NSString * _Nonnull search;

/// Creates new searchId (uses current timestamp)
+ (instancetype _Nonnull)createSearchItemWithSearch:(NSString * _Nonnull)search;

+ (NSArray<NSDictionary *> * _Nonnull)toJsonArray:(NSArray<SGISearchItem *> * _Nonnull)itemArray;
+ (NSArray<SGISearchItem *> * _Nonnull)fromJsonArray:(NSArray<NSDictionary *> * _Nonnull)jsonArray;

@end

