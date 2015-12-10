//
//  BCLazyTableViewDataSource.h
//
//  Created by Ivan Misuno on 08/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////
// View models

@protocol BCViewModel <NSObject>
@property (nonatomic, readonly) id _Nonnull model;
@property (nonatomic, readonly) NSString * _Nonnull reusableIdentifier;
@property (nonatomic, readonly) NSString * _Nonnull reusableViewClassName;
@end

id<BCViewModel> _Nonnull viewModel(id _Nonnull model);

@protocol BCLazyItemViewModel
@property (nonatomic, readonly) id<BCViewModel> _Nonnull viewModel;
@end

///////////////////////////////////////////////////////////////////
// Reusable configurable collection view items

//@interface BCConfigurableView
//- (void)configureWithViewModel:(id<BCViewModel> _Nonnull)viewModel;
//@end



///////////////////////////////////////////////////////////////////

@interface BCLazyTableViewDataSource : NSObject
@property (nonatomic, readonly) id<UITableViewDataSource, UITableViewDelegate> _Nonnull bridgeDataSource;
@end

