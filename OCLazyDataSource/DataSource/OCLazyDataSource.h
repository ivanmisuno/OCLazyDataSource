//
//  OCLazyDataSource.h
//
//  Created by Ivan Misuno on 22/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

@protocol OCLazyDataSourceEnumerable;

@protocol OCLazyDataSource <NSObject>

// flat list of OCLazyDataSourceItem with associated sections
- (void)setSource:(id<OCLazyDataSourceEnumerable/*<OCLazyDataSourceItem>*/> _Nonnull)sourceDataItems;

@end

@protocol OCLazyDataSourceBridge;

id<OCLazyDataSource> _Nonnull lazyDataSourceWithBridge(id<OCLazyDataSourceBridge> _Nonnull bridge);

#import "OCLazyDataSourceBridge.h"
#import "OCLazyDataSourceBridgeTableView.h"
#import "OCLazyDataSourceSection.h"
#import "OCLazyDataSourceEnumerable.h"
#import "OCLazyDataSourceEnumerator.h"
#import "NSArray+OCLazyDataSourceEnumerable.h"

// UITableView-related
#import "OCLazyTableViewCellContext.h"
#import "OCLazyTableViewCellFactory.h"
#import "OCLazyTableViewHeaderFooterViewFactory.h"
