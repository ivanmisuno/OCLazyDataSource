//
//  SGIImageSearchManager.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGINetworkManager.h"

@interface SGIImageSearchManager : SGINetworkManager

// overrides SGINetworkManager's property
@property (nonatomic) NSURLSessionConfiguration *defaultConfiguration;

@end
