//
//  BCLazyTableViewDataSourceBridge.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCLazySectionBridge;

@interface BCLazyTableViewDataSourceBridge : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSArray<id<BCLazySectionBridge>> * _Nonnull combinedDataSource;
@end
