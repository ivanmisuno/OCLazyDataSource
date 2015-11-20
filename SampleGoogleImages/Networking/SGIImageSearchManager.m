//
//  SGIImageSearchManager.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIImageSearchManager.h"
#import "SGIImageSearchQueryBuilder.h"
#import "SGIImageSearchResults.h"
#import "NSDictionary+SGITypedDictionary.h"

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

- (NSURLSessionDataTask *)searchWithSearch:(NSString *)search
                                startIndex:(NSInteger)startIndex
                                  callback:(void(^)(SGIImageSearchResults *results, NSError *error))callback
{
    SGIImageSearchQueryBuilder *queryBuilder = [SGIImageSearchQueryBuilder queryBuilderWithSearch:search startIndex:startIndex];

    NSURLSessionDataTask *task = [self.session dataTaskWithURL:queryBuilder.URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        void (^doCallback)(SGIImageSearchResults *results, NSError *error) = ^(SGIImageSearchResults *results2, NSError *error2)
        {
            if (callback)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(results2, error2);
                });
            }
        };

        if (!data || error)
        {
            NSMutableDictionary *errorInfo = [@{NSLocalizedDescriptionKey:NSLocalizedString(@"Error receiving data", nil)} mutableCopy];
            if (error) [errorInfo addEntriesFromDictionary:@{NSUnderlyingErrorKey:error}];
            NSError *reportError = [NSError errorWithDomain:@"SGIImageSearchManager" code:-1/*define error codes*/ userInfo:errorInfo];
            doCallback(nil, reportError);
            return;
        }

        // read JSON on background queue
        NSError *jsonError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!json || jsonError)
        {
            NSMutableDictionary *errorInfo = [@{NSLocalizedDescriptionKey:NSLocalizedString(@"Error reading json", nil)} mutableCopy];
            if (jsonError) [errorInfo addEntriesFromDictionary:@{NSUnderlyingErrorKey:jsonError}];
            NSError *reportError = [NSError errorWithDomain:@"SGIImageSearchManager" code:1/*define error codes*/ userInfo:errorInfo];
            doCallback(nil, reportError);
            return;
        }

        // TODO: parse JSON (app-specific) error
        NSNumber *jsonResponseStatus = [json sgi_numberForKey:@"responseStatus"];
        if ([jsonResponseStatus integerValue] != 200)
        {
            NSMutableDictionary *errorInfo = [@{NSLocalizedDescriptionKey:NSLocalizedString(@"Google API error", nil)} mutableCopy];
            NSString *responseDetails = json[@"responseDetails"];
            if (responseDetails) [errorInfo addEntriesFromDictionary:@{NSLocalizedFailureReasonErrorKey:responseDetails}];
            NSError *reportError = [NSError errorWithDomain:@"SGIImageSearchManager" code:2/*define error codes*/ userInfo:errorInfo];
            doCallback(nil, reportError);
            return;
        }

        SGIImageSearchResults *results = [SGIImageSearchResults fromJson:json];
        doCallback(results, nil);
    }];

    [task resume];

    return task;
}

@end
