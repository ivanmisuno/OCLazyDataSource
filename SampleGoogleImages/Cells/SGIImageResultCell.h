//
//  SGIImageResultCell.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGIImageSearchResultItem;

@interface SGIImageResultCell : UICollectionViewCell

- (void)displayImage:(SGIImageSearchResultItem *)image;

@end
