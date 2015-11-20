//
//  SGIImageSearchManager.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIImageSearchManager.h"

@implementation SGIImageSearchManager

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
    NSURLSessionConfiguration *defaultConfiguration = super.defaultConfiguration;
    defaultConfiguration.HTTPAdditionalHeaders = @{@"Referer" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SGIGoogleSearchAPIReferer"] ?: @"http://samplegoogleimages.com"};
    return defaultConfiguration;
}

@end
