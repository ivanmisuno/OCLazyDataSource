//
//  SGISavedSearchesManager.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGISavedSearchesManager.h"
#import "NSFileManager+SGICommonDirectories.h"
#import "NSDictionary+SGITypedDictionary.h"
#import "SGISearchItem.h"

@implementation SGISavedSearchesManager

+ (NSString *)defaultSavedSearchesFilePath
{
    return [[NSFileManager sgi_documentsDir] stringByAppendingPathComponent:@"searches.json"];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.savedSearchesFilePath = [[self class] defaultSavedSearchesFilePath];
    }
    return self;
}

- (NSArray<SGISearchItem *> *)loadSearches
{
    NSData *jsonData = [NSData dataWithContentsOfFile:self.savedSearchesFilePath];
    if (!jsonData) return @[];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    NSArray *jsonArray = [json sgi_arrayForKey:@"searches"];
    return [SGISearchItem fromJsonArray:jsonArray];
}

- (void)saveSearches:(NSArray<SGISearchItem *> *)searches
{
    NSArray *jsonArray = [SGISearchItem toJsonArray:searches];
    NSDictionary *json = @{@"searches":jsonArray};
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    [jsonData writeToFile:self.savedSearchesFilePath atomically:YES];
}

@end
