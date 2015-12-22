//
//  OCLazyDataSourceBridgeTableView.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCLazyDataSourceBridge;

id<OCLazyDataSourceBridge, UITableViewDataSource, UITableViewDelegate> _Nonnull lazyDataSourceBridgeForTableView(UITableView * _Nonnull tableView);

