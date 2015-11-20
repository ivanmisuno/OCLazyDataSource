//
//  NSDictionary+SGITypedDictionary.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SGITypedDictionary)

- (NSInteger)sgi_integerForKey:(NSString * _Nonnull)key;
- (double)sgi_doubleForKey:(NSString * _Nonnull)key;

- (NSNumber * _Nullable)sgi_numberForKey:(NSString * _Nonnull)key;
- (NSString * _Nullable)sgi_stringForKey:(NSString * _Nonnull)key;
- (NSArray * _Nullable)sgi_arrayForKey:(NSString * _Nonnull)key;
- (NSDictionary * _Nullable)sgi_dictionaryForKey:(NSString * _Nonnull)key;

@end
