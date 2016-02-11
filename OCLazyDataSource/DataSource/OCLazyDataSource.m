//
//  OCLazyDataSource.m
//  OCLazyDataSource
//
//  Created by Ivan Misuno on 22/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "OCLazyDataSource.h"

#import "OCLazyDataSourceBridge.h"
#import "OCLazySectionBridge.h"

#import "OCLazyDataSourceItem.h"
#import "OCLazyDataSourceSection.h"
#import "OCLazyDataSourceEnumerable.h"
#import "OCLazyDataSourceEnumerator.h"
#import "OCLazyDataSourceFlatteningEnumerator.h"
#import "OCLazyTableViewCellFactory.h"

@interface OCLazyDataSourceImpl : NSObject<OCLazyDataSource>
@property (nonatomic, readonly) id<OCLazyDataSourceBridge> _Nonnull bridgeObject;
@end
@implementation OCLazyDataSourceImpl

- (instancetype _Nullable)initWithBridgeObject:(id<OCLazyDataSourceBridge> _Nonnull)bridgeObject
{
    self = [super init];
    if (self)
    {
        _bridgeObject = bridgeObject;
    }
    return self;
}

- (BOOL)needsNewSectionForItem:(id<OCLazyDataSourceItem> _Nonnull)currentItem inCollection:(NSMutableArray<id<OCLazySectionBridge>> * _Nonnull)combinedDataSource
{
    id<OCLazySectionBridge> lastSection = [combinedDataSource lastObject];
    return !lastSection || lastSection.section != currentItem.section;
}

- (id<OCLazySectionBridge> _Nonnull)currentOrNewSectionForItem:(id<OCLazyDataSourceItem> _Nonnull)currentItem inCollection:(NSMutableArray<id<OCLazySectionBridge>> * _Nonnull)combinedDataSource
{
    if ([self needsNewSectionForItem:currentItem inCollection:combinedDataSource])
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

- (NSArray<id<OCLazySectionBridge>> *)flattenSourceData:(id<OCLazyDataSourceEnumerable/*<OCLazyDataSourceItem>*/> _Nonnull)sourceDataItems
{
    id<OCLazyDataSourceEnumerator> enumerator = lazyDataSourceFlatteningEnumeratorWithEnumerator(sourceDataItems.enumerator);

    NSMutableArray<id<OCLazySectionBridge>> *combinedDataSource = [NSMutableArray new];
    for (id<OCLazyDataSourceItem> currentItem in [enumerator asNSEnumerator])
    {
        if ([currentItem conformsToProtocol:@protocol(OCLazyDataSourceItem)])
        {
            [self pushDataItem:currentItem toCollectionOfSections:combinedDataSource];
        }
        else
        {
            NSAssert(NO, @"Elements of sourceDataItems must conform to OCLazyDataSourceItem protocol.");
        }
    }

    return [combinedDataSource copy];
}

- (void)setSource:(id<OCLazyDataSourceEnumerable/*<OCLazyDataSourceItem>*/> _Nonnull)sourceDataItems
{
    NSArray<id<OCLazySectionBridge>> *flattenedSourceData = [self flattenSourceData:sourceDataItems];
    self.bridgeObject.combinedDataSource = flattenedSourceData;
}

@end

id<OCLazyDataSource> _Nonnull lazyDataSourceWithBridge(id<OCLazyDataSourceBridge> _Nonnull bridge)
{
    return [[OCLazyDataSourceImpl alloc] initWithBridgeObject:bridge];
}
