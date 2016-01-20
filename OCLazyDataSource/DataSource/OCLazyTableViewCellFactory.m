//
//  OCLazyTableViewCellFactory.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "OCLazyTableViewCellFactory.h"

@interface OCLazyTableViewCellFactoryImpl : NSObject <OCLazyTableViewCellFactory>
@property (nonatomic, readonly) OCLazyTableViewCellRegisterBlock _Nullable registerBlock;
@property (nonatomic, readonly) OCLazyTableViewCellDequeueBlock _Nonnull dequeueBlock;
@end

@implementation OCLazyTableViewCellFactoryImpl

@synthesize configureBlock;
@synthesize estimatedHeightBlock;
@synthesize heightBlock;
@synthesize willDisplayBlock;
@synthesize didSelectBlock;

- (instancetype _Nullable)initWithRegisterBlock:(OCLazyTableViewCellRegisterBlock _Nullable)registerBlock
                                   dequeueBlock:(OCLazyTableViewCellDequeueBlock _Nonnull)dequeueBlock
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
        self.registerBlock(tableView);
}
- (UITableViewCell * _Nonnull)dequeueTableViewCell:(UITableView * _Nonnull)tableView forIndexPath:(NSIndexPath * _Nonnull)indexPath withModelObject:(id _Nonnull)model
{
    return self.dequeueBlock(model, tableView, indexPath);
}
@end

id<OCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithNib(UINib * _Nonnull nibForCell, NSString * _Nonnull reuseIdentifier)
{
    return [[OCLazyTableViewCellFactoryImpl alloc] initWithRegisterBlock:^(UITableView * _Nonnull tableView) {
        [tableView registerNib:nibForCell forCellReuseIdentifier:reuseIdentifier];
    } dequeueBlock:^UITableViewCell * _Nonnull(id _Nonnull model, UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
        return [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }];
}
id<OCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithClass(Class _Nonnull classForCell, NSString * _Nonnull reuseIdentifier)
{
    return [[OCLazyTableViewCellFactoryImpl alloc] initWithRegisterBlock:^(UITableView * _Nonnull tableView) {
        [tableView registerClass:classForCell forCellReuseIdentifier:reuseIdentifier];
    } dequeueBlock:^UITableViewCell * _Nonnull(id _Nonnull model, UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
        return [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }];
}
id<OCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithStyle(UITableViewCellStyle cellStyle, NSString * _Nonnull reuseIdentifier)
{
    return [[OCLazyTableViewCellFactoryImpl alloc] initWithRegisterBlock:nil dequeueBlock:^UITableViewCell * _Nonnull(id _Nonnull model, UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
        }
        return cell;
    }];
}
id<OCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithRegisterAndDequeueBlocks(OCLazyTableViewCellRegisterBlock _Nullable registerBlock, OCLazyTableViewCellDequeueBlock _Nonnull dequeueBlock)
{
    return [[OCLazyTableViewCellFactoryImpl alloc] initWithRegisterBlock:registerBlock dequeueBlock:dequeueBlock];
}
