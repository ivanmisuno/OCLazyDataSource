//
//  SGICollectionViewItem.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef UICollectionViewCell * _Nonnull (^SGICollectionViewItemDequeueBlock)(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath);
typedef void (^SGICollectionViewItemDidSelectBlock)(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath);
typedef void (^SGICollectionViewItemWillDispayBlock)(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath);

@interface SGICollectionViewItem : NSObject

+ (instancetype _Nonnull)itemWithDataObject:(NSObject * _Nullable)dataObject
                               dequeueBlock:(SGICollectionViewItemDequeueBlock _Nonnull)dequeueBlock
                             didSelectBlock:(SGICollectionViewItemDidSelectBlock _Nullable)didSelectBlock
                           willDisplayBlock:(SGICollectionViewItemWillDispayBlock _Nullable)willDisplayBlock;

@property (nonatomic, readonly) NSObject * _Nullable dataObject;
@property (nonatomic, readonly) SGICollectionViewItemDequeueBlock _Nonnull dequeueBlock;
@property (nonatomic, readonly) SGICollectionViewItemDidSelectBlock _Nullable didSelectBlock;
@property (nonatomic, readonly) SGICollectionViewItemWillDispayBlock _Nullable willDisplayBlock;

@end
