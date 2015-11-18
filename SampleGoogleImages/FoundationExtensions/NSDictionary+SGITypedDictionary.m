//
//  NSDictionary+SGITypedDictionary.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "NSDictionary+SGITypedDictionary.h"

@implementation NSDictionary (SGITypedDictionary)

- (NSString * _Nullable)sgi_stringForKey:(NSString * _Nonnull)key
{
    NSString *result = self[key];
    return [result isKindOfClass:[NSString class]] ? result : nil;
}

@end
