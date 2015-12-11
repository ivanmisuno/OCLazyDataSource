//
//  BCLazySectionBridge.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 11/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "BCLazySectionBridge.h"

@interface BCLazySectionBridgeImpl : NSObject<BCLazySectionBridge>
@property (nonatomic, readonly) NSMutableArray<id<BCLazyDataSourceItem>> * _Nonnull mutableItems;
@end
@implementation BCLazySectionBridgeImpl

@synthesize section = _section;
- (NSArray<id<BCLazyDataSourceItem>> * _Nonnull)items
{
    return [_mutableItems copy];
}

- (instancetype _Nullable)initWithSection:(id<BCLazyDataSourceSection> _Nonnull)section
{
    self = [super init];
    if (self)
    {
        _section = section;
        _mutableItems = [NSMutableArray new];
    }
    return self;
}

- (void)appendItem:(id<BCLazyDataSourceItem> _Nonnull)item
{
    [self.mutableItems addObject:item];
}

@end

id<BCLazySectionBridge> _Nonnull lazySectionBridgeWithSection(id<BCLazyDataSourceSection> _Nonnull section)
{
    return [[BCLazySectionBridgeImpl alloc] initWithSection:section];
}
