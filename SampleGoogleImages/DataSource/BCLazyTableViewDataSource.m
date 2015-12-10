//
//  BCLazyTableViewDataSource.m
//
//  Created by Ivan Misuno on 08/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "BCLazyTableViewDataSource.h"
#import "BCLazyTableViewDataSourceBridge.h"

@interface BCViewModelImpl : NSObject <BCViewModel>
@end
@implementation BCViewModelImpl
@synthesize model = _model;
@synthesize reusableIdentifier = _reusableIdentifier;
@synthesize reusableViewClassName = _reusableViewClassName;
- (instancetype _Nullable)initWithModel:(id _Nonnull)model
{
    self = [super init];
    if (self)
    {
        _model = model;
    }
    return self;
}
@end

id<BCViewModel> _Nonnull viewModel(id _Nonnull model)
{
    return [[BCViewModelImpl alloc] initWithModel:model];
}


//////////////////////////

typedef id<BCViewModel> _Nonnull (^ BCLazyItemViewModelFunc)(id _Nonnull originalItem);

@interface BCLazyItemViewModelImpl : NSObject<BCLazyItemViewModel>
@property (nonatomic, readonly) BCLazyItemViewModelFunc _Nonnull func;
@property (nonatomic, readonly) id _Nonnull originalItem;
@end
@implementation BCLazyItemViewModelImpl
- (instancetype _Nullable)initWithFunc:(BCLazyItemViewModelFunc _Nonnull)func originalItem:(id _Nonnull)originalItem
{
    self = [super init];
    if (self)
    {
        _func = func;
        _originalItem = originalItem;
    }
    return self;
}
- (id<BCViewModel> _Nonnull)viewModel
{
    return self.func(self.originalItem);
}
@end

///////////////////////////////////////////////////////////////////

@implementation BCLazyTableViewDataSource

- (instancetype _Nullable)init
{
    self = [super init];
    if (self)
    {
        _bridgeDataSource = [BCLazyTableViewDataSourceBridge new];
    }
    return self;
}

@end

