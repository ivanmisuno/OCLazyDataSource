//
//  OCLazySectionBridge.m
//
//  Created by Ivan Misuno on 11/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "OCLazySectionBridge.h"

@interface OCLazySectionBridgeImpl : NSObject<OCLazySectionBridge>
@property (nonatomic, readonly) NSMutableArray<id<OCLazyDataSourceItem>> * _Nonnull mutableItems;
@end
@implementation OCLazySectionBridgeImpl

@synthesize section = _section;
- (NSArray<id<OCLazyDataSourceItem>> * _Nonnull)items
{
    return [_mutableItems copy];
}

- (instancetype _Nullable)initWithSection:(id<OCLazyDataSourceSection> _Nonnull)section
{
    self = [super init];
    if (self)
    {
        _section = section;
        _mutableItems = [NSMutableArray new];
    }
    return self;
}

- (void)appendItem:(id<OCLazyDataSourceItem> _Nonnull)item
{
    [self.mutableItems addObject:item];
}

@end

id<OCLazySectionBridge> _Nonnull lazySectionBridgeWithSection(id<OCLazyDataSourceSection> _Nonnull section)
{
    return [[OCLazySectionBridgeImpl alloc] initWithSection:section];
}
