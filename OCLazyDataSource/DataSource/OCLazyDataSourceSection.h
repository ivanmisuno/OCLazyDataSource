//
//  OCLazyDataSourceSection.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCLazyDataSourceEnumerable.h"

///////////////////////////////////////////////////////////////////
// Collection view section with header, footer and sequence of items (view models)

@protocol OCLazyDataSourceItemsCollection;
@protocol OCLazyTableViewCellFactory;
@protocol OCLazyTableViewHeaderFooterViewFactory;

@protocol OCLazyDataSourceSection <OCLazyDataSourceEnumerable/*<OCLazyDataSourceItem>*/>

@property (nonatomic, readonly) id<OCLazyTableViewCellFactory> _Nonnull cellFactory;

// optional header/footer
@property (nonatomic) id _Nullable headerViewItem;
@property (nonatomic) id _Nullable footerViewItem;
@property (nonatomic) id<OCLazyTableViewHeaderFooterViewFactory> _Nullable headerFooterFactory;

// optional event handlers

@end

id<OCLazyDataSourceSection> _Nonnull lazyDataSourceSectionWithEnumerable(id<OCLazyDataSourceEnumerable> _Nonnull sourceItems,
                                                                         id<OCLazyTableViewCellFactory> _Nonnull cellFactory);
