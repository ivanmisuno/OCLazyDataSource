//
//  OCLazyDataSourceItem.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "OCLazyDataSourceItem.h"

@interface OCLazyDataSourceItemImpl : NSObject <OCLazyDataSourceItem>
@end

@implementation OCLazyDataSourceItemImpl
@synthesize sourceItem = _sourceItem;
@synthesize section = _section;

- (instancetype _Nullable)initWithSourceItem:(id _Nonnull)sourceItem
                                     section:(id<OCLazyDataSourceSection> _Nullable)section
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

id<OCLazyDataSourceItem> _Nonnull lazyDataSourceItem(id _Nonnull sourceItem,
                                                     id<OCLazyDataSourceSection> _Nullable section)
{
    return [[OCLazyDataSourceItemImpl alloc] initWithSourceItem:sourceItem
                                                        section:section];
}
