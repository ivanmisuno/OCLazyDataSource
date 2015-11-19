//
//  NSDictionary+SGITypedDictionary.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "NSDictionary+SGITypedDictionary.h"

@implementation NSDictionary (SGITypedDictionary)

- (NSNumber * _Nullable)sgi_numberForKey:(NSString * _Nonnull)key
{
    NSNumber *result = self[key];
    return [result isKindOfClass:[NSNumber class]] ? result : nil;
}
- (NSString * _Nullable)sgi_stringForKey:(NSString * _Nonnull)key
{
    NSString *result = self[key];
    return [result isKindOfClass:[NSString class]] ? result : nil;
}
- (NSArray * _Nullable)sgi_arrayForKey:(NSString * _Nonnull)key
{
    NSArray *result = self[key];
    return [result isKindOfClass:[NSArray class]] ? result : nil;
}

@end
