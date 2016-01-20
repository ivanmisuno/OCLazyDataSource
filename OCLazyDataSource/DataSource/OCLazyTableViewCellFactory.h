//
//  OCLazyTableViewCellFactory.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void                       (^OCLazyTableViewCellRegisterBlock)       (UITableView * _Nonnull tableView);
typedef UITableViewCell * _Nonnull (^OCLazyTableViewCellDequeueBlock)        (id _Nonnull model, UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath);
typedef void                       (^OCLazyTableViewCellConfigureBlock)      (id _Nonnull model, UITableView * _Nonnull tableView, UITableViewCell * _Nonnull cell);
typedef CGFloat                    (^OCLazyTableViewCellEstimatedHeightBlock)(id _Nonnull model, UITableView * _Nonnull tableView);
typedef CGFloat                    (^OCLazyTableViewCellHeightBlock)         (id _Nonnull model, UITableView * _Nonnull tableView);

typedef UITableViewCell * _Nonnull (^OCLazyTableViewCellBlock)               ();
typedef void                       (^OCLazyTableViewCellWillDisplayBlock)    (id _Nonnull model, UITableView * _Nonnull tableView, OCLazyTableViewCellBlock _Nonnull cellBlock);
typedef void                       (^OCLazyTableViewCellDidSelectBlock)      (id _Nonnull model, UITableView * _Nonnull tableView, OCLazyTableViewCellBlock _Nonnull cellBlock);

@protocol OCLazyTableViewCellFactory <NSObject>
- (void)registerWithTableView:(UITableView * _Nonnull)tableView;
- (UITableViewCell * _Nonnull)dequeueTableViewCell:(UITableView * _Nonnull)tableView forIndexPath:(NSIndexPath * _Nonnull)indexPath withModelObject:(id _Nonnull)model;

@property (nonatomic, strong) OCLazyTableViewCellConfigureBlock       _Nullable configureBlock;
@property (nonatomic, strong) OCLazyTableViewCellEstimatedHeightBlock _Nullable estimatedHeightBlock;
@property (nonatomic, strong) OCLazyTableViewCellHeightBlock          _Nullable heightBlock;

@property (nonatomic, strong) OCLazyTableViewCellWillDisplayBlock     _Nullable willDisplayBlock;
@property (nonatomic, strong) OCLazyTableViewCellDidSelectBlock       _Nullable didSelectBlock;

@end

id<OCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithNib(UINib * _Nonnull nibForCell, NSString * _Nonnull reuseIdentifier);
id<OCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithClass(Class _Nonnull classForCell, NSString * _Nonnull reuseIdentifier);
id<OCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithStyle(UITableViewCellStyle cellStyle, NSString * _Nonnull reuseIdentifier);
id<OCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithRegisterAndDequeueBlocks(OCLazyTableViewCellRegisterBlock _Nullable registerBlock, OCLazyTableViewCellDequeueBlock _Nonnull dequeueBlock);
