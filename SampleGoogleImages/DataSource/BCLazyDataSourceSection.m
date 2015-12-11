//
//  BCLazyDataSourceSection.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "BCLazyDataSourceSection.h"
#import "BCLazyDataSourceEnumerator.h"
#import "BCLazyDataSourceItem.h"

@interface BCLazyDataSourceSectionImpl : NSObject<BCLazyDataSourceSection>

@property (nonatomic, readonly) id<BCLazyDataSourceEnumerable> _Nonnull sourceItemsCollection;

@end

@implementation BCLazyDataSourceSectionImpl

@synthesize headerViewItem = _headerViewItem;
@synthesize footerViewItem = _footerViewItem;
@synthesize cellFactory = _cellFactory;
@synthesize headerFooterFactory = _headerFooterFactory;

- (instancetype _Nullable)initWithSourceItemsCollection:(id<BCLazyDataSourceEnumerable> _Nonnull)sourceItemsCollection
                                            cellFactory:(id<BCLazyTableViewCellFactory> _Nonnull)cellFactory
{
    self = [super init];
    if (self)
    {
        _sourceItemsCollection = sourceItemsCollection;
        _cellFactory = cellFactory;
    }
    return self;
}
- (id<BCLazyDataSourceEnumerator/*<BCLazyDataSourceItem>*/> _Nonnull)enumerator
{
    id<BCLazyDataSourceEnumerator> sourceItemsCollectionEnumerator = [self.sourceItemsCollection enumerator];
    return lazyDataSourceEnumeratorWithBlock(^id _Nullable{
        id sourceItem = [sourceItemsCollectionEnumerator nextObject];
        if (!sourceItem) return nil; // EOS
        return lazyDataSourceItem(sourceItem,
                                  self/*collection*/);
    });
}
@end

id<BCLazyDataSourceSection> _Nonnull lazyDataSourceSectionWithEnumerable(id<BCLazyDataSourceEnumerable> _Nonnull sourceItems,
                                                                         id<BCLazyTableViewCellFactory> _Nonnull cellFactory)
{
    return [[BCLazyDataSourceSectionImpl alloc] initWithSourceItemsCollection:sourceItems
                                                                  cellFactory:cellFactory];
}
