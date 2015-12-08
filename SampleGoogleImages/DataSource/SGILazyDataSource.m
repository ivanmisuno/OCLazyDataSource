//
//  SGILazyDataSource.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 08/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGILazyDataSource.h"

@interface SGIViewModelImpl : NSObject <SGIViewModel>
@end
@implementation SGIViewModelImpl
@synthesize model = _model;
@synthesize reusableIdentifier = _reusableIdentifier;
@synthesize reusableViewClassName = _reusableViewClassName;
- (instancetype _Nonnull)initWithModel:(id _Nonnull)model
{
    self = [super init];
    if (self)
    {
        _model = model;
    }
    return self;
}
@end

id<SGIViewModel> _Nonnull viewModel(id _Nonnull model)
{
    return [[SGIViewModelImpl alloc] initWithModel:model];
}


//////////////////////////

typedef id<SGIViewModel> _Nonnull (^ SGILazyItemViewModelFunc)(id _Nonnull originalItem);

@interface SGILazyItemViewModelImpl : NSObject<SGILazyItemViewModel>
@property (nonatomic, readonly) SGILazyItemViewModelFunc _Nonnull func;
@property (nonatomic, readonly) id _Nonnull originalItem;
@end
@implementation SGILazyItemViewModelImpl
- (instancetype _Nonnull)initWithFunc:(SGILazyItemViewModelFunc _Nonnull)func originalItem:(id _Nonnull)originalItem
{
    self = [super init];
    if (self)
    {
        _func = func;
        _originalItem = originalItem;
    }
    return self;
}
- (id<SGIViewModel> _Nonnull)viewModel
{
    return self.func(self.originalItem);
}
@end

///////////////////////////////////////////////////////////////////
// Collection view section with header, footer and sequence of items (view models)

@interface SGILazyDataSourceItemsCollectionImpl : NSObject<SGILazyDataSourceItemsCollection>
@property (nonatomic, readonly) SGILazyDataSourceItemCollectionGenerator _Nonnull generator;
@end
@implementation SGILazyDataSourceItemsCollectionImpl
- (instancetype _Nonnull)initWithGenerator:(SGILazyDataSourceItemCollectionGenerator _Nonnull)generator
{
    self = [super init];
    if (self)
    {
        _generator = generator;
    }
    return self;
}
- (NSEnumerator<id<SGILazyItemViewModel>> * _Nonnull)enumerator
{
    return self.generator();
}

@end

id<SGILazyDataSourceItemsCollection> _Nonnull lazyDataSourceItemsCollection(id _Nonnull collection)
{
    NSCParameterAssert([collection respondsToSelector:@selector(enumerator)]);
    return [[SGILazyDataSourceItemsCollectionImpl alloc] initWithGenerator:^NSEnumerator * _Nonnull{
        return [collection respondsToSelector:@selector(enumerator)] ? [collection enumerator] : [@[] objectEnumerator]/*empty collection*/;
    }];
}
