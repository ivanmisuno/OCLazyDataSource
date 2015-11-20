//
//  SGIImageSearchQueryBuilder.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIImageSearchQueryBuilder.h"

@interface SGIImageSearchQueryBuilder()
@property (nonatomic, readonly) NSURLComponents *urlComponents;
@end

@implementation SGIImageSearchQueryBuilder

+ (instancetype)queryBuilderWithSearch:(NSString *)search
{
    return [[self alloc] initWithSearch:search];
}
- (instancetype)initWithSearch:(NSString *)search
{
    self = [super init];
    if (self)
    {
        _urlComponents = [NSURLComponents componentsWithString:@"https://ajax.googleapis.com/ajax/services/search/images"];
        _urlComponents.queryItems = @[
                                      [NSURLQueryItem queryItemWithName:@"q" value:search],

                                      // number of results to return per page (1-8)
                                      [NSURLQueryItem queryItemWithName:@"rsz" value:@"8"],

                                      // this parameter is not strictly required.
                                      // obtaining client IP is not a 1-liner, and reporting it must involve explicit user consent on discloosing his private information.
                                      //[NSURLQueryItem queryItemWithName:@"userip" value:@"127.0.0.1"],

                                      ];
    }
    return self;
}

- (NSURL *)URL
{
    return self.urlComponents.URL;
}

@end
