//
//  OCLazyTableViewDataSourceBridge.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCLazySectionBridge;

@interface OCLazyTableViewDataSourceBridge : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSArray<id<OCLazySectionBridge>> * _Nonnull combinedDataSource;
@end
