//
//  BCLazyTableViewCellFactory.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "BCLazyTableViewCellFactory.h"

@interface BCLazyTableViewCellFactoryImpl : NSObject <BCLazyTableViewCellFactory>
@property (nonatomic, readonly) UINib * _Nullable nibForCell;
@property (nonatomic, readonly) Class _Nullable classForCell;
@property (nonatomic, readonly) NSString * _Nonnull reuseIdentifier;
@end

@implementation BCLazyTableViewCellFactoryImpl
- (instancetype _Nullable)initWithNib:(UINib * _Nonnull)nibForCell reuseIdentifier:(NSString * _Nonnull)reuseIdentifier
{
    self = [super init];
    if (self)
    {
        _nibForCell = nibForCell;
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}
- (instancetype _Nullable)initWithClass:(Class _Nonnull)classForCell reuseIdentifier:(NSString * _Nonnull)reuseIdentifier
{
    self = [super init];
    if (self)
    {
        _classForCell = classForCell;
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)registerWithTableView:(UITableView * _Nonnull)tableView
{
    if (self.nibForCell)
    {
        [tableView registerNib:self.nibForCell forCellReuseIdentifier:self.reuseIdentifier];
    }
    else if (self.classForCell)
    {
        [tableView registerClass:self.classForCell forCellReuseIdentifier:self.reuseIdentifier];
    }
    else
    {
        NSAssert(NO, @"Must have nib or cell class!");
    }
}
- (UITableViewCell * _Nonnull)dequeueTableViewCell:(UITableView * _Nonnull)tableView forIndexPath:(NSIndexPath * _Nonnull)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
}
@end

id<BCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithNib(UINib * _Nonnull nibForCell, NSString * _Nonnull reuseIdentifier)
{
    return [[BCLazyTableViewCellFactoryImpl alloc] initWithNib:nibForCell reuseIdentifier:reuseIdentifier];
}
id<BCLazyTableViewCellFactory> _Nonnull lazyTableViewCellFactoryWithClass(Class _Nonnull classForCell, NSString * _Nonnull reuseIdentifier)
{
    return [[BCLazyTableViewCellFactoryImpl alloc] initWithClass:classForCell reuseIdentifier:reuseIdentifier];
}
