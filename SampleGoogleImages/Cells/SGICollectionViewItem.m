//
//  SGICollectionViewItem.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGICollectionViewItem.h"

@implementation SGICollectionViewItem

+ (instancetype _Nonnull)itemWithDequeueBlock:(SGICollectionViewItemDequeueBlock _Nonnull)dequeueBlock
                               didSelectBlock:(SGICollectionViewItemDidSelectBlock _Nullable)didSelectBlock
                             willDisplayBlock:(SGICollectionViewItemWillDispayBlock _Nullable)willDisplayBlock
{
    return [[self alloc] initWithDequeueBlock:dequeueBlock
                               didSelectBlock:didSelectBlock
                             willDisplayBlock:willDisplayBlock];
}

- (instancetype _Nonnull)initWithDequeueBlock:(SGICollectionViewItemDequeueBlock _Nonnull)dequeueBlock
                               didSelectBlock:(SGICollectionViewItemDidSelectBlock _Nullable)didSelectBlock
                             willDisplayBlock:(SGICollectionViewItemWillDispayBlock _Nullable)willDisplayBlock
{
    self = [super init];
    if (self)
    {
        _dequeueBlock = dequeueBlock;
        _didSelectBlock = didSelectBlock;
        _willDisplayBlock = willDisplayBlock;
    }
    return self;
}

@end
