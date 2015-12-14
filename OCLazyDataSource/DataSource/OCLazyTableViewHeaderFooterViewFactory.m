//
//  OCLazyTableViewHeaderFooterViewFactory.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "OCLazyTableViewHeaderFooterViewFactory.h"

typedef void(^RegisterBlockType)(UITableView * _Nonnull tableView);
typedef UITableViewHeaderFooterView * _Nonnull (^DequeueBlockType)(UITableView * _Nonnull tableView);

@interface OCLazyTableViewHeaderFooterViewFactoryImpl : NSObject <OCLazyTableViewHeaderFooterViewFactory>
@property (nonatomic, readonly) RegisterBlockType _Nonnull registerBlock;
@property (nonatomic, readonly) DequeueBlockType _Nonnull dequeueBlock;
@end

@implementation OCLazyTableViewHeaderFooterViewFactoryImpl
- (instancetype _Nullable)initWithRegisterBlock:(RegisterBlockType _Nonnull)registerBlock
                                   dequeueBlock:(DequeueBlockType _Nonnull)dequeueBlock
{
    self = [super init];
    if (self)
    {
        _registerBlock = registerBlock;
        _dequeueBlock = dequeueBlock;
    }
    return self;
}

- (void)registerWithTableView:(UITableView * _Nonnull)tableView
{
    self.registerBlock(tableView);
}
- (UITableViewHeaderFooterView * _Nonnull)dequeueTableViewHeaderFooterView:(UITableView *)tableView
{
    return self.dequeueBlock(tableView);
}
@end

id<OCLazyTableViewHeaderFooterViewFactory> _Nonnull lazyTableViewHeaderFooterViewFactoryWithNib(UINib * _Nonnull nibForTableViewHeaderFooterView, NSString * _Nonnull reuseIdentifier)
{
    return [[OCLazyTableViewHeaderFooterViewFactoryImpl alloc] initWithRegisterBlock:^(UITableView * _Nonnull tableView) {
        [tableView registerNib:nibForTableViewHeaderFooterView forHeaderFooterViewReuseIdentifier:reuseIdentifier];
    } dequeueBlock:^UITableViewHeaderFooterView * _Nonnull(UITableView * _Nonnull tableView) {
        return [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    }];
}
id<OCLazyTableViewHeaderFooterViewFactory> _Nonnull lazyTableViewHeaderFooterViewFactoryWithClass(Class _Nonnull classForTableViewHeaderFooterView, NSString * _Nonnull reuseIdentifier)
{
    return [[OCLazyTableViewHeaderFooterViewFactoryImpl alloc] initWithRegisterBlock:^(UITableView * _Nonnull tableView) {
        [tableView registerClass:classForTableViewHeaderFooterView forHeaderFooterViewReuseIdentifier:reuseIdentifier];
    } dequeueBlock:^UITableViewHeaderFooterView * _Nonnull(UITableView * _Nonnull tableView) {
        return [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    }];
}
