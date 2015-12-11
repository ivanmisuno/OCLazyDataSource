//
//  BCLazyTableViewDataSource.m
//
//  Created by Ivan Misuno on 08/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "BCLazyTableViewDataSource.h"
#import "BCLazyTableViewDataSourceBridge.h"
#import "BCLazySectionBridge.h"

#import "BCLazyDataSourceItem.h"
#import "BCLazyDataSourceSection.h"
#import "BCLazyDataSourceEnumerable.h"
#import "BCLazyDataSourceEnumerator.h"
#import "BCLazyDataSourceFlatteningEnumerator.h"
#import "BCLazyTableViewCellFactory.h"

//@interface BCViewModelImpl : NSObject <BCViewModel>
//@end
//@implementation BCViewModelImpl
//@synthesize model = _model;
//@synthesize reusableIdentifier = _reusableIdentifier;
//@synthesize reusableViewClassName = _reusableViewClassName;
//- (instancetype _Nullable)initWithModel:(id _Nonnull)model
//{
//    self = [super init];
//    if (self)
//    {
//        _model = model;
//    }
//    return self;
//}
//@end
//
//id<BCViewModel> _Nonnull viewModel(id _Nonnull model)
//{
//    return [[BCViewModelImpl alloc] initWithModel:model];
//}

///////////////////////////////////////////////////////////////////

@interface BCLazyTableViewDataSource()
@property (nonatomic, readonly) BCLazyTableViewDataSourceBridge * _Nonnull bridgeDataSourceObject;
@end
@implementation BCLazyTableViewDataSource

- (id<UITableViewDataSource, UITableViewDelegate> _Nonnull)bridgeDataSource
{
    return self.bridgeDataSourceObject;
}

- (instancetype _Nullable)init
{
    self = [super init];
    if (self)
    {
        _bridgeDataSourceObject = [BCLazyTableViewDataSourceBridge new];
    }
    return self;
}

- (BOOL)needNewSectionForItem:(id<BCLazyDataSourceItem> _Nonnull)currentItem inCollection:(NSMutableArray<id<BCLazySectionBridge>> * _Nonnull)combinedDataSource
{
    id<BCLazySectionBridge> lastSection = [combinedDataSource lastObject];
    return !lastSection || lastSection.section != currentItem.section;
}

- (id<BCLazySectionBridge> _Nonnull)currentOrNewSectionForItem:(id<BCLazyDataSourceItem> _Nonnull)currentItem inCollection:(NSMutableArray<id<BCLazySectionBridge>> * _Nonnull)combinedDataSource
{
    if ([self needNewSectionForItem:currentItem inCollection:combinedDataSource])
    {
        id<BCLazySectionBridge>newSection = lazySectionBridgeWithSection(currentItem.section);
        [combinedDataSource addObject:newSection];
    }

    id<BCLazySectionBridge> currentSection = [combinedDataSource lastObject];
    return currentSection;
}

- (void)pushDataItem:(id<BCLazyDataSourceItem> _Nonnull)currentItem toCollectionOfSections:(NSMutableArray<id<BCLazySectionBridge>> * _Nonnull)combinedDataSource
{
    id<BCLazySectionBridge> currentSection = [self currentOrNewSectionForItem:currentItem inCollection:combinedDataSource];
    [currentSection appendItem:currentItem];
}

- (void)setSource:(id<BCLazyDataSourceEnumerable/*<BCLazyDataSourceItem>*/> _Nonnull)sourceDataItems
     forTableView:(UITableView * _Nonnull)tableView
{
    id<BCLazyDataSourceEnumerator> enumerator = lazyDataSourceFlatteningEnumeratorWithEnumerator(sourceDataItems.enumerator);

    NSMutableArray<id<BCLazySectionBridge>> *combinedDataSource = [NSMutableArray new];
    for (id<BCLazyDataSourceItem> currentItem in [enumerator asNSEnumerator])
    {
        [self pushDataItem:currentItem toCollectionOfSections:combinedDataSource];
    }

    [self registerCellFactoriesFromCombineddata:combinedDataSource withTableView:tableView];

    self.bridgeDataSourceObject.combinedDataSource = [combinedDataSource copy];
}

- (void)registerCellFactoriesFromCombineddata:(NSArray<id<BCLazySectionBridge>> * _Nonnull)combinedDataSource
                                withTableView:(UITableView * _Nonnull)tableView
{
    for (id<BCLazySectionBridge> sectionBridge in combinedDataSource)
    {
        if (sectionBridge.section.cellFactory)
        {
            [sectionBridge.section.cellFactory registerWithTableView:tableView];
        }
    }
}

@end

