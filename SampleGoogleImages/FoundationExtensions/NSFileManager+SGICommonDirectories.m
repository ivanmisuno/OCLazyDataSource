//
//  NSFileManager+SGICommonDirectories.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "NSFileManager+SGICommonDirectories.h"
#import "NSFileManager+SGICommonDirectories.h"

@implementation NSFileManager (SGICommonDirectories)

+ (NSString *)sgi_documentsDir
{
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    return paths.firstObject;
}

+ (NSString *)sgi_cachesDir
{
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true);
    return paths.firstObject;
}

@end
