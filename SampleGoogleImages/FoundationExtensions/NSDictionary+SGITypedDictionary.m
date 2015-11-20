//
//  NSDictionary+SGITypedDictionary.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "NSDictionary+SGITypedDictionary.h"

@implementation NSDictionary (SGITypedDictionary)

- (NSInteger)sgi_integerForKey:(NSString * _Nonnull)key
{
    NSNumber *number = [self sgi_numberForKey:key];
    if (number) return [number integerValue];
    NSString *str = [self sgi_stringForKey:key];
    if (str) return [str integerValue];
    return 0;
}
- (double)sgi_doubleForKey:(NSString * _Nonnull)key
{
    NSNumber *number = [self sgi_numberForKey:key];
    if (number) return [number doubleValue];
    NSString *str = [self sgi_stringForKey:key];
    if (str) return [str doubleValue];
    return 0;
}

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
- (NSDictionary * _Nullable)sgi_dictionaryForKey:(NSString * _Nonnull)key
{
    NSDictionary *result = self[key];
    return [result isKindOfClass:[NSDictionary class]] ? result : nil;
}

@end
