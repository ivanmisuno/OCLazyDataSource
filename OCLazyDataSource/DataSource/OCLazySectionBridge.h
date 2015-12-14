//
//  OCLazySectionBridge.h
//
//  Created by Ivan Misuno on 11/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCLazyDataSourceSection;
@protocol OCLazyDataSourceItem;

@protocol OCLazySectionBridge
@property (nonatomic, readonly) id<OCLazyDataSourceSection> _Nonnull section;
@property (nonatomic, readonly, copy) NSArray<id<OCLazyDataSourceItem>> * _Nonnull items;
- (void)appendItem:(id<OCLazyDataSourceItem> _Nonnull)item;
@end

id<OCLazySectionBridge> _Nonnull lazySectionBridgeWithSection(id<OCLazyDataSourceSection> _Nonnull section);
