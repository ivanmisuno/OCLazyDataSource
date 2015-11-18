//
//  SGISearchItem.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGIJSONConvertibleProtocol.h"

// TODO: better use
@interface SGISearchItem : NSObject <SGIJSONConvertibleProtocol>

@property (nonatomic, readonly) NSString * _Nonnull search;

+ (instancetype _Nonnull)searchItemWithSearch:(NSString * _Nonnull)search;

@end
