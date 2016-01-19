//
//  OCLazyTableViewHeaderFooterViewFactory.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "OCLazyTableViewHeaderFooterViewFactory.h"

@interface OCLazyTableViewHeaderFooterViewFactoryImpl : NSObject <OCLazyTableViewHeaderFooterViewFactory>
@property (nonatomic, readonly) OCLazyTableViewHeaderFooterRegisterBlock _Nullable registerBlock;
@property (nonatomic, readonly) OCLazyTableViewHeaderFooterDequeueBlock _Nonnull dequeueBlock;
@end

@implementation OCLazyTableViewHeaderFooterViewFactoryImpl
@synthesize configureBlock = _configureBlock;
@synthesize estimatedHeightBlock = _estimatedHeightBlock;
@synthesize heightBlock = _heightBlock;
- (instancetype _Nullable)initWithRegisterBlock:(OCLazyTableViewHeaderFooterRegisterBlock _Nullable)registerBlock
                                   dequeueBlock:(OCLazyTableViewHeaderFooterDequeueBlock _Nonnull)dequeueBlock
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
    if (self.registerBlock)
    {
        self.registerBlock(tableView);
    }
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
id<OCLazyTableViewHeaderFooterViewFactory> _Nonnull lazyTableViewHeaderFooterViewFactoryWithRegisterAndDequeueBlocks(OCLazyTableViewHeaderFooterRegisterBlock _Nullable registerBlock, OCLazyTableViewHeaderFooterDequeueBlock _Nonnull dequeueBlock)
{
    return [[OCLazyTableViewHeaderFooterViewFactoryImpl alloc] initWithRegisterBlock:registerBlock dequeueBlock:dequeueBlock];
}
