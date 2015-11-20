//
//  SGIImageSearchResultItem.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGIImageSearchResultItem : NSObject

@property (nonatomic) NSString *thumbnailURL;
@property (nonatomic) CGSize thSize;

@property (nonatomic) NSString *imageURL;
@property (nonatomic) CGSize imageSize;

@end
