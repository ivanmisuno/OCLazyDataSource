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

+ (long long)newSearchId
{
    NSAssert([NSThread isMainThread], @"Multithreading not supported");
    static long long __prevSearchId;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __prevSearchId = [NSDate timeIntervalSinceReferenceDate] * 1000;
    });
    return __prevSearchId++;
}

+ (NSTimeInterval)currentTimestamp
{
    return [NSDate timeIntervalSinceReferenceDate];
}

+ (instancetype _Nullable)createSearchItemWithSearch:(NSString * _Nonnull)search
{
    long long newSearchId = [self newSearchId];
    return [[self alloc] initWithSearchId:newSearchId
                                   search:search];
}
- (instancetype _Nullable)initWithSearchId:(long long)searchId
                                   search:(NSString * _Nonnull)search
{
    return [self initWithSearchId:searchId
                           search:search
                        timestamp:[[self class] currentTimestamp]];
}
- (instancetype _Nullable)initWithSearchId:(long long)searchId
                                   search:(NSString * _Nonnull)search
                                timestamp:(NSTimeInterval)timestamp
{
    self = [super init];
    if (self)
    {
        _searchId = searchId;
        _search = search;
        _timestamp = timestamp;
    }
    return self;
}

- (void)updateTimestamp
{
    _timestamp = [[self class] currentTimestamp];
}

#pragma mark - Object equality

- (BOOL)isEqual:(id)object
{
    if (object == self) return YES;
    if (![object isKindOfClass:[SGISearchItem class]]) return NO;
    return [self isEqualToSearchItem:object];
}
- (NSUInteger)hash
{
    return (self.searchId & 0xFFFFFFFF)
        ^ self.search.hash
        ^ ((NSUInteger)self.timestamp);
}
- (BOOL)isEqualToSearchItem:(SGISearchItem *)other
{
    return self.hash == other.hash
        && self.searchId == other.searchId
        && [self.search isEqualToString:other.search]
        && self.timestamp == other.timestamp;
}

#pragma mark - SGIJSONConvertibleProtocol conformance

// For an indie project, better use JSONModel or similar 3-rd party object/property mapping framework,
// for an enterprise app, develop one internally,
// for this example just write some boilerplate code
- (NSDictionary * _Nonnull)toJson
{
    return @
    {
        @keypath(self, searchId) : @(self.searchId),
        @keypath(self, search) : self.search,
        @keypath(self, timestamp) : @(self.timestamp),
    };
}

+ (id _Nullable)fromJson:(NSDictionary * _Nonnull)json
{
    if (![json isKindOfClass:[NSDictionary class]]) return nil;
    NSNumber *searchId = [json sgi_numberForKey:@keypath([SGISearchItem new], searchId)];
    NSString *search = [json sgi_stringForKey:@keypath([SGISearchItem new], search)];
    NSNumber *timestamp = [json sgi_numberForKey:@keypath([SGISearchItem new], timestamp)];
    if (!searchId
        || !search
        || !timestamp)
    {
        return nil;
    }
    return [[self alloc] initWithSearchId:[searchId longLongValue]
                                   search:search
                                timestamp:[timestamp doubleValue]];
}

+ (NSArray<NSDictionary *> * _Nonnull)toJsonArray:(NSArray<SGISearchItem *> * _Nonnull)itemArray
{
    NSMutableArray<NSDictionary *> *result = [NSMutableArray new];
    [itemArray enumerateObjectsUsingBlock:^(SGISearchItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *json = obj.toJson;
        [result addObject:json];
    }];
    return [result copy];
}
+ (NSArray<SGISearchItem *> * _Nonnull)fromJsonArray:(NSArray<NSDictionary *> * _Nonnull)jsonArray
{
    NSMutableArray<SGISearchItem *> *result = [NSMutableArray new];
    [jsonArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SGISearchItem *item = [SGISearchItem fromJson:obj];
        if (item)
        {
            [result addObject:item];
        }
    }];
    return [result copy];
}

@end
