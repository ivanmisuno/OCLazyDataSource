//
//  SGIImageSearchResults.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIImageSearchResults.h"
#import "SGIImageSearchResultItem.h"
#import "NSDictionary+SGITypedDictionary.h"

@implementation SGIImageSearchResults

+ (SGIImageSearchResults *)fromJson:(NSDictionary *)json
{
    NSDictionary *responseData = [json sgi_dictionaryForKey:@"responseData"];
    NSArray *results = [responseData sgi_arrayForKey:@"results"];

    NSMutableArray<SGIImageSearchResultItem *> *resultImages = [NSMutableArray new];
    for (NSDictionary *result in results)
    {
        SGIImageSearchResultItem *item = [SGIImageSearchResultItem new];
        item.thumbnailURL = [result sgi_stringForKey:@"tbUrl"];
        item.thSize = CGSizeMake([result sgi_integerForKey:@"tbWidth"], [result sgi_integerForKey:@"tbHeight"]);
        item.imageURL = [result sgi_stringForKey:@"url"];
        item.imageSize = CGSizeMake([result sgi_integerForKey:@"width"], [result sgi_integerForKey:@"height"]);
        [resultImages addObject:item];
    }

    SGIImageSearchResults *result = [SGIImageSearchResults new];
    result.images = [resultImages copy];

    NSDictionary *cursor = [responseData sgi_dictionaryForKey:@"cursor"];
    result.totalEstimatedResults = [cursor sgi_integerForKey:@"estimatedResultCount"];

    return result;
}

- (void)appendImages:(NSArray<SGIImageSearchResultItem *> *)images
{
    NSMutableArray<SGIImageSearchResultItem *> *copiedImages = [NSMutableArray arrayWithArray:self.images ?: @[]];
    [copiedImages addObjectsFromArray:images];
    self.images = copiedImages;
}
- (void)aggregate:(SGIImageSearchResults *)newPage
{
    [self appendImages:newPage.images];
}

@end
