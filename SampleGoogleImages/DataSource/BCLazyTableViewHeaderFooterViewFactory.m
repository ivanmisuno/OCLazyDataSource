//
//  BCLazyTableViewHeaderFooterViewFactory.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "BCLazyTableViewHeaderFooterViewFactory.h"

@interface BCLazyTableViewHeaderFooterViewFactoryImpl : NSObject <BCLazyTableViewHeaderFooterViewFactory>
@property (nonatomic, readonly) UINib * _Nullable nibForTableViewHeaderFooterView;
@property (nonatomic, readonly) Class _Nullable classForTableViewHeaderFooterView;
@property (nonatomic, readonly) NSString * _Nonnull reuseIdentifier;
@end

@implementation BCLazyTableViewHeaderFooterViewFactoryImpl
- (instancetype _Nullable)initWithNib:(UINib * _Nonnull)nibForTableViewHeaderFooterView reuseIdentifier:(NSString * _Nonnull)reuseIdentifier
{
    self = [super init];
    if (self)
    {
        _nibForTableViewHeaderFooterView = nibForTableViewHeaderFooterView;
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}
- (instancetype _Nullable)initWithClass:(Class _Nonnull)classForTableViewHeaderFooterView reuseIdentifier:(NSString * _Nonnull)reuseIdentifier
{
    self = [super init];
    if (self)
    {
        _classForTableViewHeaderFooterView = classForTableViewHeaderFooterView;
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)registerWithTableView:(UITableView * _Nonnull)tableView
{
    if (self.nibForTableViewHeaderFooterView)
    {
        [tableView registerNib:self.nibForTableViewHeaderFooterView forHeaderFooterViewReuseIdentifier:self.reuseIdentifier];
    }
    else if (self.classForTableViewHeaderFooterView)
    {
        [tableView registerClass:self.classForTableViewHeaderFooterView forHeaderFooterViewReuseIdentifier:self.reuseIdentifier];
    }
    else
    {
        NSAssert(NO, @"Must have nib or cell class!");
    }
}
- (UITableViewHeaderFooterView * _Nonnull)dequeueTableViewHeaderFooterView:(UITableView *)tableView
{
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.reuseIdentifier];
}
@end

id<BCLazyTableViewHeaderFooterViewFactory> _Nonnull lazyTableViewHeaderFooterViewFactoryWithNib(UINib * _Nonnull nibForTableViewHeaderFooterView, NSString * _Nonnull reuseIdentifier)
{
    return [[BCLazyTableViewHeaderFooterViewFactoryImpl alloc] initWithNib:nibForTableViewHeaderFooterView reuseIdentifier:reuseIdentifier];
}
id<BCLazyTableViewHeaderFooterViewFactory> _Nonnull lazyTableViewHeaderFooterViewFactoryWithClass(Class _Nonnull classForTableViewHeaderFooterView, NSString * _Nonnull reuseIdentifier)
{
    return [[BCLazyTableViewHeaderFooterViewFactoryImpl alloc] initWithClass:classForTableViewHeaderFooterView reuseIdentifier:reuseIdentifier];
}
