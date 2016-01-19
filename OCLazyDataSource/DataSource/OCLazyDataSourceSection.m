//
//  OCLazyDataSourceSection.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "OCLazyDataSourceSection.h"
#import "OCLazyDataSourceEnumerator.h"
#import "OCLazyDataSourceItem.h"

@interface OCLazyDataSourceSectionImpl : NSObject<OCLazyDataSourceSection>

@property (nonatomic, readonly) id<OCLazyDataSourceEnumerable> _Nonnull sourceItemsCollection;

@end

@implementation OCLazyDataSourceSectionImpl

@synthesize cellFactory = _cellFactory;
@synthesize headerViewFactory = _headerViewFactory;
@synthesize footerViewFactory = _footerViewFactory;

- (instancetype _Nullable)initWithSourceItemsCollection:(id<OCLazyDataSourceEnumerable> _Nonnull)sourceItemsCollection
                                            cellFactory:(id<OCLazyTableViewCellFactory> _Nonnull)cellFactory
{
    self = [super init];
    if (self)
    {
        _sourceItemsCollection = sourceItemsCollection;
        _cellFactory = cellFactory;
    }
    return self;
}
- (id<OCLazyDataSourceEnumerator/*<OCLazyDataSourceItem>*/> _Nonnull)enumerator
{
    id<OCLazyDataSourceEnumerator> sourceItemsCollectionEnumerator = [self.sourceItemsCollection enumerator];
    return lazyDataSourceEnumeratorWithBlock(^id _Nullable{
        id sourceItem = [sourceItemsCollectionEnumerator nextObject];
        if (!sourceItem) return nil; // EOS
        return lazyDataSourceItem(sourceItem,
                                  self/*collection*/);
    });
}
@end

id<OCLazyDataSourceSection> _Nonnull lazyDataSourceSectionWithEnumerable(id<OCLazyDataSourceEnumerable> _Nonnull sourceItems,
                                                                         id<OCLazyTableViewCellFactory> _Nonnull cellFactory)
{
    return [[OCLazyDataSourceSectionImpl alloc] initWithSourceItemsCollection:sourceItems
                                                                  cellFactory:cellFactory];
}
