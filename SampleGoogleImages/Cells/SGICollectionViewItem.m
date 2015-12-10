//
//  SGICollectionViewItem.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGICollectionViewItem.h"

@implementation SGICollectionViewItem

+ (instancetype _Nullable)itemWithDataObject:(NSObject * _Nullable)dataObject
                                dequeueBlock:(SGICollectionViewItemDequeueBlock _Nonnull)dequeueBlock
                              didSelectBlock:(SGICollectionViewItemDidSelectBlock _Nullable)didSelectBlock
                            willDisplayBlock:(SGICollectionViewItemWillDispayBlock _Nullable)willDisplayBlock
{
    return [[self alloc] initWithDataObject:dataObject
                               dequeueBlock:dequeueBlock
                               didSelectBlock:didSelectBlock
                             willDisplayBlock:willDisplayBlock];
}

- (instancetype _Nullable)initWithDataObject:(NSObject * _Nullable)dataObject
                               dequeueBlock:(SGICollectionViewItemDequeueBlock _Nonnull)dequeueBlock
                               didSelectBlock:(SGICollectionViewItemDidSelectBlock _Nullable)didSelectBlock
                             willDisplayBlock:(SGICollectionViewItemWillDispayBlock _Nullable)willDisplayBlock
{
    self = [super init];
    if (self)
    {
        _dataObject = dataObject;
        _dequeueBlock = dequeueBlock;
        _didSelectBlock = didSelectBlock;
        _willDisplayBlock = willDisplayBlock;
    }
    return self;
}

@end
