//
//  BCLazyTableViewCellFactory.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCLazyTableViewCellFactory
- (void)registerWithTableView:(UITableView * _Nonnull)tableView;
- (UITableViewCell * _Nonnull)dequeueTableViewCell:(UITableView * _Nonnull)tableView forIndexPath:(NSIndexPath * _Nonnull)indexPath;
@end

id<BCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithNib(UINib * _Nonnull nibForCell, NSString * _Nonnull reuseIdentifier);
id<BCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithClass(Class _Nonnull classForCell, NSString * _Nonnull reuseIdentifier);
