//
//  BCLazyDataSourceItem.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "BCLazyDataSourceItem.h"

@interface BCLazyDataSourceItemImpl : NSObject <BCLazyDataSourceItem>
@end

@implementation BCLazyDataSourceItemImpl
@synthesize sourceItem = _sourceItem;
@synthesize section = _section;

- (instancetype _Nullable)initWithSourceItem:(id _Nonnull)sourceItem
                                     section:(id<BCLazyDataSourceSection> _Nullable)section
{
    self = [super init];
    if (self)
    {
        _sourceItem = sourceItem;
        _section = section;
    }
    return self;
}
@end

id<BCLazyDataSourceItem> _Nonnull lazyDataSourceItem(id _Nonnull sourceItem,
                                                     id<BCLazyDataSourceSection> _Nullable section)
{
    return [[BCLazyDataSourceItemImpl alloc] initWithSourceItem:sourceItem
                                                        section:section];
}
