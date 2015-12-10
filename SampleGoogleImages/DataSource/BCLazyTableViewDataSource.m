//
//  BCLazyTableViewDataSource.m
//
//  Created by Ivan Misuno on 08/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "BCLazyTableViewDataSource.h"
#import "BCLazyTableViewDataSourceBridge.h"

#import "BCLazyDataSourceItem.h"
#import "BCLazyDataSourceSection.h"
#import "BCLazyDataSourceEnumerator.h"
#import "BCLazyDataSourceEnumerable.h"

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



@implementation BCLazyTableViewDataSource

- (instancetype _Nullable)init
{
    self = [super init];
    if (self)
    {
        _bridgeDataSource = [BCLazyTableViewDataSourceBridge new];
    }
    return self;
}

- (id<BCLazyDataSourceSection> _Nullable)firstSection:(id<BCLazyDataSourceEnumerable/*<BCLazyDataSourceItem>*/> _Nonnull)dataItems
{
    id<BCLazyDataSourceEnumerator> enumerator = dataItems.enumerator;
    id<BCLazyDataSourceItem> firstItem = [enumerator nextObject];
    return firstItem.section; // or nil if empty data source/no section
}

- (void)setDataItems:(id<BCLazyDataSourceEnumerable/*<BCLazyDataSourceItem>*/> _Nonnull)dataItems
{
//    id<BCLazyDataSourceSection> currentSection = [self firstSection:dataItems];
//
//    BOOL (^isNewSection)(id<BCLazyDataSourceItem> item) = ^BOOL(id<BCLazyDataSourceItem> item) {
//        id<BCLazyDataSourceSection> section = item.section;
//        if (
//    };
//
//    for (id<BCLazyDataSourceItem> item in [dataItems.enumerator asNSEnumerator])
//    {
//
//    }
}

@end

