//
//  NSFileManager+SGICommonDirectories.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (SGICommonDirectories)

+ (NSString *)sgi_documentsDir;
+ (NSString *)sgi_cachesDir;

@end
