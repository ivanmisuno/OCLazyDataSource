//
//  SGIJSONConvertibleProtocol.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SGIJSONConvertibleProtocol

@property (nonatomic, readonly) NSDictionary * _Nonnull toJson;

+ (id _Nullable)fromJson:(NSDictionary * _Nonnull)json;

@end
