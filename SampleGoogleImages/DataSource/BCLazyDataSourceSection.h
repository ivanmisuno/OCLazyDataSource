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

@protocol BCViewModel;
@protocol BCLazyDataSourceItemsCollection;

@protocol BCLazyDataSourceSection <BCLazyDataSourceEnumerable/*<BCLazyDataSourceItem>*/>
@property (nonatomic, readonly) id<BCViewModel> _Nullable headerViewModel;
@property (nonatomic, readonly) id<BCViewModel> _Nullable footerViewModel;
@end

id<BCLazyDataSourceSection> _Nonnull lazyDataSourceSection(id<BCLazyDataSourceEnumerable> _Nonnull sourceCollection);
