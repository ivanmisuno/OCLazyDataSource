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
@protocol BCLazyTableViewCellFactory;
@protocol BCLazyTableViewHeaderFooterViewFactory;

@protocol BCLazyDataSourceSection <BCLazyDataSourceEnumerable/*<BCLazyDataSourceItem>*/>

@property (nonatomic, readonly) id<BCLazyTableViewCellFactory> _Nonnull cellFactory;

// optional header/footer
@property (nonatomic) id _Nullable headerViewItem;
@property (nonatomic) id _Nullable footerViewItem;
@property (nonatomic) id<BCLazyTableViewHeaderFooterViewFactory> _Nullable headerFooterFactory;

// optional event handlers

@end

id<BCLazyDataSourceSection> _Nonnull lazyDataSourceSectionWithEnumerable(id<BCLazyDataSourceEnumerable> _Nonnull sourceItems,
                                                                         id<BCLazyTableViewCellFactory> _Nonnull cellFactory);
