//
//  SGINetworkManager.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGINetworkManager.h"

@implementation SGINetworkManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (NSURLSessionConfiguration *)defaultConfiguration
{
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    return defaultConfiguration;
}

@end
