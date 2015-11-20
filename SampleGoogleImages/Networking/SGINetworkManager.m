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

@synthesize session = _session;
- (NSURLSession *)session
{
    @synchronized(self)
    {
        if (!_session)
        {
            _session = [NSURLSession sessionWithConfiguration:self.defaultConfiguration];
        }
        return _session;
    }
}

@end
