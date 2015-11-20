//
//  SGINetworkManager.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGINetworkManager : NSObject

// override or set prior to calling -session
@property (nonatomic, readonly) NSURLSessionConfiguration *defaultConfiguration;

@property (nonatomic, readonly) NSURLSession *session;

@end
