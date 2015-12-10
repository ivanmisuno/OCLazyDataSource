//
//  BCLazyDataSourceSection.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCLazyDataSourceEnumerable.h"

///////////////////////////////////////////////////////////////////
// Collection view section with header, footer and sequence of items (view models)

@protocol BCLazyDataSourceItemsCollection;

@protocol BCLazyDataSourceSection <BCLazyDataSourceEnumerable/*<BCLazyDataSourceItem>*/>
@property (nonatomic, readonly) id _Nullable headerViewItem;
@property (nonatomic, readonly) id _Nullable footerViewItem;
@end

id<BCLazyDataSourceSection> _Nonnull lazyDataSourceSectionWithEnumerable(id<BCLazyDataSourceEnumerable> _Nonnull sourceItems,
                                                                         id _Nullable headerViewItem,
                                                                         id _Nullable footerViewItem);
