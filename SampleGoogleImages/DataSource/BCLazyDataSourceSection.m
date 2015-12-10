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
@property (nonatomic, readonly) id<BCLazyDataSourceEnumerable> _Nonnull sourceCollection;
@end
@implementation BCLazyDataSourceSectionImpl
@synthesize headerViewModel = _headerViewModel;
@synthesize footerViewModel = _footerViewModel;
- (instancetype _Nullable)initWithSourceCollection:(id<BCLazyDataSourceEnumerable> _Nonnull)sourceCollection
{
    self = [super init];
    if (self)
    {
        _sourceCollection = sourceCollection;
    }
    return self;
}
- (id<BCLazyDataSourceEnumerator/*<BCLazyDataSourceItem>*/> _Nonnull)enumerator
{
    id<BCLazyDataSourceEnumerator> sourceCollectionEnumerator = [self.sourceCollection enumerator];
    return lazyDataSourceEnumeratorWithBlock(^id _Nullable{
        id sourceItem = [sourceCollectionEnumerator nextObject];
        if (!sourceItem) return nil; // EOS
        return lazyDataSourceItem(sourceItem,
                                  self/*collection*/);
    });
}
@end

id<BCLazyDataSourceSection> _Nonnull lazyDataSourceSection(id<BCLazyDataSourceEnumerable> _Nonnull sourceCollection)
{
    return [[BCLazyDataSourceSectionImpl alloc] initWithSourceCollection:sourceCollection];
}
