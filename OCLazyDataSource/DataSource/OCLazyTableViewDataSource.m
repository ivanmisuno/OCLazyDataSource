//
//  OCLazyTableViewDataSource.m
//
//  Created by Ivan Misuno on 08/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "OCLazyTableViewDataSource.h"
#import "OCLazyTableViewDataSourceBridge.h"
#import "OCLazySectionBridge.h"

#import "OCLazyDataSourceItem.h"
#import "OCLazyDataSourceSection.h"
#import "OCLazyDataSourceEnumerable.h"
#import "OCLazyDataSourceEnumerator.h"
#import "OCLazyDataSourceFlatteningEnumerator.h"
#import "OCLazyTableViewCellFactory.h"

@interface OCLazyTableViewDataSource()
@property (nonatomic, readonly) OCLazyTableViewDataSourceBridge * _Nonnull bridgeDataSourceObject;
@end
@implementation OCLazyTableViewDataSource

- (id<UITableViewDataSource, UITableViewDelegate> _Nonnull)bridgeDataSource
{
    return self.bridgeDataSourceObject;
}

- (instancetype _Nullable)init
{
    self = [super init];
    if (self)
    {
        _bridgeDataSourceObject = [OCLazyTableViewDataSourceBridge new];
    }
    return self;
}

- (BOOL)needNewSectionForItem:(id<OCLazyDataSourceItem> _Nonnull)currentItem inCollection:(NSMutableArray<id<OCLazySectionBridge>> * _Nonnull)combinedDataSource
{
    id<OCLazySectionBridge> lastSection = [combinedDataSource lastObject];
    return !lastSection || lastSection.section != currentItem.section;
}

- (id<OCLazySectionBridge> _Nonnull)currentOrNewSectionForItem:(id<OCLazyDataSourceItem> _Nonnull)currentItem inCollection:(NSMutableArray<id<OCLazySectionBridge>> * _Nonnull)combinedDataSource
{
    if ([self needNewSectionForItem:currentItem inCollection:combinedDataSource])
    {
        id<OCLazySectionBridge>newSection = lazySectionBridgeWithSection(currentItem.section);
        [combinedDataSource addObject:newSection];
    }

    id<OCLazySectionBridge> currentSection = [combinedDataSource lastObject];
    return currentSection;
}

- (void)pushDataItem:(id<OCLazyDataSourceItem> _Nonnull)currentItem toCollectionOfSections:(NSMutableArray<id<OCLazySectionBridge>> * _Nonnull)combinedDataSource
{
    id<OCLazySectionBridge> currentSection = [self currentOrNewSectionForItem:currentItem inCollection:combinedDataSource];
    [currentSection appendItem:currentItem];
}

- (void)setSource:(id<OCLazyDataSourceEnumerable/*<OCLazyDataSourceItem>*/> _Nonnull)sourceDataItems
     forTableView:(UITableView * _Nonnull)tableView
{
    id<OCLazyDataSourceEnumerator> enumerator = lazyDataSourceFlatteningEnumeratorWithEnumerator(sourceDataItems.enumerator);

    NSMutableArray<id<OCLazySectionBridge>> *combinedDataSource = [NSMutableArray new];
    for (id<OCLazyDataSourceItem> currentItem in [enumerator asNSEnumerator])
    {
        [self pushDataItem:currentItem toCollectionOfSections:combinedDataSource];
    }

    [self registerCellFactoriesFromCombineddata:combinedDataSource withTableView:tableView];

    self.bridgeDataSourceObject.combinedDataSource = [combinedDataSource copy];
}

- (void)registerCellFactoriesFromCombineddata:(NSArray<id<OCLazySectionBridge>> * _Nonnull)combinedDataSource
                                withTableView:(UITableView * _Nonnull)tableView
{
    for (id<OCLazySectionBridge> sectionBridge in combinedDataSource)
    {
        if (sectionBridge.section.cellFactory)
        {
            [sectionBridge.section.cellFactory registerWithTableView:tableView];
        }
    }
}

@end

