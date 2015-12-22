//
//  OCLazyTableViewCellFactory.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void    (^OCLazyTableViewCellConfigureBlock)      (UITableViewCell * _Nonnull cell, id _Nonnull model, UITableView * _Nonnull tableView);
typedef CGFloat (^OCLazyTableViewCellEstimatedHeightBlock)(id _Nonnull model, UITableView * _Nonnull tableView);
typedef CGFloat (^OCLazyTableViewCellHeightBlock)         (id _Nonnull model, UITableView * _Nonnull tableView);

@protocol OCLazyTableViewCellFactory <NSObject>
- (void)registerWithTableView:(UITableView * _Nonnull)tableView;
- (UITableViewCell * _Nonnull)dequeueTableViewCell:(UITableView * _Nonnull)tableView forIndexPath:(NSIndexPath * _Nonnull)indexPath;

@property (nonatomic, strong) OCLazyTableViewCellConfigureBlock       _Nullable configureBlock;
@property (nonatomic, strong) OCLazyTableViewCellEstimatedHeightBlock _Nullable estimatedHeightBlock;
@property (nonatomic, strong) OCLazyTableViewCellHeightBlock          _Nullable heightBlock;

@end


id<OCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithNib(UINib * _Nonnull nibForCell, NSString * _Nonnull reuseIdentifier);
id<OCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithClass(Class _Nonnull classForCell, NSString * _Nonnull reuseIdentifier);
id<OCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithStyle(UITableViewCellStyle cellStyle, NSString * _Nonnull reuseIdentifier);
