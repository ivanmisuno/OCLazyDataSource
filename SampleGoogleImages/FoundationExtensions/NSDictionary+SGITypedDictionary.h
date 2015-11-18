//
//  NSDictionary+SGITypedDictionary.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SGITypedDictionary)

- (NSString * _Nullable)sgi_stringForKey:(NSString * _Nonnull)key;

@end
