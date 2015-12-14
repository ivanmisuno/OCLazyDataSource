//
//  OCLazyTableViewDataSource.h
//
//  Created by Ivan Misuno on 08/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////
// View models

//@protocol BCViewModel <NSObject>
//@property (nonatomic, readonly) id _Nonnull model;
//@end
//
//id<BCViewModel> _Nonnull viewModel(id _Nonnull model);

///////////////////////////////////////////////////////////////////
// Reusable configurable collection view items

//@interface BCConfigurableView
//- (void)configureWithViewModel:(id<BCViewModel> _Nonnull)viewModel;
//@end



///////////////////////////////////////////////////////////////////

@protocol OCLazyDataSourceEnumerable;

@interface OCLazyTableViewDataSource : NSObject

// use this as a delegate and dataSource for UITableView
@property (nonatomic, readonly) id<UITableViewDataSource, UITableViewDelegate> _Nonnull bridgeDataSource;

// flat list of OCLazyDataSourceItem with associated sections
- (void)setSource:(id<OCLazyDataSourceEnumerable/*<OCLazyDataSourceItem>*/> _Nonnull)sourceDataItems
     forTableView:(UITableView * _Nonnull)tableView;
@end

