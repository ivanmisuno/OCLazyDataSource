//
//  BCLazyTableViewCellFactory.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void    (^BCLazyTableViewCellConfigureBlock)      (UITableViewCell * _Nonnull cell, id _Nonnull model, UITableView * _Nonnull tableView);
typedef CGFloat (^BCLazyTableViewCellEstimatedHeightBlock)(id _Nonnull model, UITableView * _Nonnull tableView);
typedef CGFloat (^BCLazyTableViewCellHeightBlock)         (id _Nonnull model, UITableView * _Nonnull tableView);

@protocol BCLazyTableViewCellFactory
- (void)registerWithTableView:(UITableView * _Nonnull)tableView;
- (UITableViewCell * _Nonnull)dequeueTableViewCell:(UITableView * _Nonnull)tableView forIndexPath:(NSIndexPath * _Nonnull)indexPath;

@property (nonatomic, strong) BCLazyTableViewCellConfigureBlock       _Nullable configureBlock;
@property (nonatomic, strong) BCLazyTableViewCellEstimatedHeightBlock _Nullable estimatedHeightBlock;
@property (nonatomic, strong) BCLazyTableViewCellHeightBlock          _Nullable heightBlock;

@end


id<BCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithNib(UINib * _Nonnull nibForCell, NSString * _Nonnull reuseIdentifier);
id<BCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithClass(Class _Nonnull classForCell, NSString * _Nonnull reuseIdentifier);
id<BCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithStyle(UITableViewCellStyle cellStyle, NSString * _Nonnull reuseIdentifier);
