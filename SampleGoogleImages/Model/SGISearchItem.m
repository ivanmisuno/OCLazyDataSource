//
//  SGISearchItem.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGISearchItem.h"
#import "NSDictionary+SGITypedDictionary.h"

@implementation SGISearchItem

+ (instancetype _Nonnull)searchItemWithSearch:(NSString * _Nonnull)search
{
    return [[self alloc] initWithSearch:search];
}
- (instancetype _Nonnull)initWithSearch:(NSString * _Nonnull)search
{
    self = [super init];
    if (self)
    {
        _search = search;
    }
    return self;
}

#pragma mark - SGIJSONConvertibleProtocol conformance

// For an indie project, better use JSONModel or similar 3-rd party object/property mapping framework,
// for an enterprise app, develop one internally,
// for this example just write some boilerplate code
- (NSDictionary * _Nonnull)toJson
{
    return @{ @keypath(self, search) : self.search };
}

+ (id _Nullable)fromJson:(NSDictionary * _Nonnull)json
{
    if (![json isKindOfClass:[NSDictionary class]]) return nil;
    NSString *search = [json sgi_stringForKey:@keypath([SGISearchItem new], search)];
    if (!search) return nil;
    return [self searchItemWithSearch:search];
}

@end
