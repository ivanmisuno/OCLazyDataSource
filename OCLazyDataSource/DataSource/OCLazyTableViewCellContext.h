//
//  OCLazyTableViewCellContext.h
//  OCLazyDataSource
//
//  Created by Ivan Misuno on 25/01/16.
//  Copyright © 2016 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCLazyTableViewCellContext <NSObject>

// cell and source index path properties
@property (nonatomic, readonly) UITableViewCell * _Nonnull cell;
@property (nonatomic, readonly) NSIndexPath * _Nonnull sourceIndexPath;

// cell operations
- (void)deselectCellAnimated:(BOOL)animated;

@end

id<OCLazyTableViewCellContext> _Nonnull lazyTableViewCellContext(
    UITableViewCell * _Nonnull (^ _Nonnull cellBlock)(),
    NSIndexPath     * _Nonnull (^ _Nonnull indexPathBlock)(),
    void                       (^ _Nonnull deselectCellBlock)(BOOL animated)
);
