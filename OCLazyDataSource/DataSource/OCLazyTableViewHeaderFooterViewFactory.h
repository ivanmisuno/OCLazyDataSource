//
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void                                   (^OCLazyTableViewHeaderFooterRegisterBlock)       (UITableView * _Nonnull tableView);
typedef UITableViewHeaderFooterView * _Nonnull (^OCLazyTableViewHeaderFooterDequeueBlock)        (UITableView * _Nonnull tableView);
typedef void                                   (^OCLazyTableViewHeaderFooterConfigureBlock)      (UITableView * _Nonnull tableView, UITableViewHeaderFooterView * _Nonnull headerFooterView);
typedef CGFloat                                (^OCLazyTableViewHeaderFooterEstimatedHeightBlock)(UITableView * _Nonnull tableView);
typedef CGFloat                                (^OCLazyTableViewHeaderFooterHeightBlock)         (UITableView * _Nonnull tableView);

@protocol OCLazyTableViewHeaderFooterViewFactory <NSObject>

- (void)registerWithTableView:(UITableView * _Nonnull)tableView;
- (UITableViewHeaderFooterView * _Nonnull)dequeueTableViewHeaderFooterView:(UITableView * _Nonnull)tableView;

@property (nonatomic, strong) OCLazyTableViewHeaderFooterConfigureBlock       _Nullable configureBlock;
@property (nonatomic, strong) OCLazyTableViewHeaderFooterEstimatedHeightBlock _Nullable estimatedHeightBlock;
@property (nonatomic, strong) OCLazyTableViewHeaderFooterHeightBlock          _Nullable heightBlock;

@end

id<OCLazyTableViewHeaderFooterViewFactory> _Nonnull lazyTableViewHeaderFooterViewFactoryWithNib(UINib * _Nonnull nibForTableViewHeaderFooterView, NSString * _Nonnull reuseIdentifier);
id<OCLazyTableViewHeaderFooterViewFactory> _Nonnull lazyTableViewHeaderFooterViewFactoryWithClass(Class _Nonnull classForTableViewHeaderFooterView, NSString * _Nonnull reuseIdentifier);
id<OCLazyTableViewHeaderFooterViewFactory> _Nonnull lazyTableViewHeaderFooterViewFactoryWithRegisterAndDequeueBlocks(OCLazyTableViewHeaderFooterRegisterBlock _Nullable registerBlock, OCLazyTableViewHeaderFooterDequeueBlock _Nonnull dequeueBlock);
