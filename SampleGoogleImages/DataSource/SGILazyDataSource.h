//
//  SGILazyDataSource.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 08/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////
// View models

@protocol SGIViewModel <NSObject>
@property (nonatomic, readonly) id _Nonnull model;
@property (nonatomic, readonly) NSString * _Nonnull reusableIdentifier;
@property (nonatomic, readonly) NSString * _Nonnull reusableViewClassName;
@end

id<SGIViewModel> _Nonnull viewModel(id _Nonnull model);

@protocol SGILazyItemViewModel
@property (nonatomic, readonly) id<SGIViewModel> _Nonnull viewModel;
@end

///////////////////////////////////////////////////////////////////
// Collection view section with header, footer and sequence of items (view models)

typedef NSEnumerator * _Nonnull(^ SGILazyDataSourceItemCollectionGenerator)();

@protocol SGILazyDataSourceItemsCollection
- (NSEnumerator<id<SGILazyItemViewModel>> * _Nonnull)enumerator;
@end

id<SGILazyDataSourceItemsCollection> _Nonnull lazyDataSourceItemsCollection(id _Nonnull collection);

@interface SGILazyDataSourceSection : NSObject
@property (nonatomic, readonly) id<SGIViewModel> _Nullable headerViewModel;
@property (nonatomic, readonly) id<SGIViewModel> _Nullable footerViewModel;
@property (nonatomic, readonly) id<SGILazyDataSourceItemsCollection> _Nonnull items;
@end

///////////////////////////////////////////////////////////////////
// Reusable configurable collection view items

//@interface SGIConfigurableView
//- (void)configureWithViewModel:(id<SGIViewModel> _Nonnull)viewModel;
//@end
