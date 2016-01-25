//
//  OCLazyTableViewCellContext.m
//  OCLazyDataSource
//
//  Created by Ivan Misuno on 25/01/16.
//  Copyright © 2016 Ivan Misuno. All rights reserved.
//

#import "OCLazyTableViewCellContext.h"

typedef UITableViewCell * _Nonnull (^ _Nonnull CellBlock)();
typedef NSIndexPath     * _Nonnull (^ _Nonnull IndexPathBlock)();
typedef void                       (^ _Nonnull DeselectCellBlock)(BOOL animated);

@interface OCLazyTableViewCellContextImpl : NSObject <OCLazyTableViewCellContext>

@property (nonatomic, readonly) CellBlock _Nonnull cellBlock;
@property (nonatomic, readonly) IndexPathBlock _Nonnull indexPathBlock;
@property (nonatomic, readonly) DeselectCellBlock _Nonnull deselectCellBlock;

@end

@implementation OCLazyTableViewCellContextImpl

// cell and source index path properties
- (UITableViewCell * _Nonnull)cell { return self.cellBlock(); }
- (NSIndexPath * _Nonnull)sourceIndexPath { return self.indexPathBlock(); }

// cell operations
- (void)deselectCellAnimated:(BOOL)animated { self.deselectCellBlock(animated); }

- (instancetype _Nonnull)initWithCellBlock:(CellBlock _Nonnull)cellBlock
                            indexPathBlock:(IndexPathBlock _Nonnull)indexPathBlock
                         deselectCellBlock:(DeselectCellBlock _Nonnull)deselectCellBlock
{
    self = [super init];
    if (self) {
        _cellBlock = cellBlock;
        _indexPathBlock = indexPathBlock;
        _deselectCellBlock = deselectCellBlock;
    }
    return self;
}

@end

id<OCLazyTableViewCellContext> _Nonnull lazyTableViewCellContext(
                                                                 UITableViewCell * _Nonnull (^ _Nonnull cellBlock)(),
                                                                 NSIndexPath     * _Nonnull (^ _Nonnull indexPathBlock)(),
                                                                 void                       (^ _Nonnull deselectCellBlock)(BOOL animated)
                                                                 )
{
    return [[OCLazyTableViewCellContextImpl alloc] initWithCellBlock:cellBlock
                                                      indexPathBlock:indexPathBlock
                                                   deselectCellBlock:deselectCellBlock];
}
