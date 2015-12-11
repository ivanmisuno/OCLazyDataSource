//
//  BCLazySectionBridge.h
//
//  Created by Ivan Misuno on 11/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCLazyDataSourceSection;
@protocol BCLazyDataSourceItem;

@protocol BCLazySectionBridge
@property (nonatomic, readonly) id<BCLazyDataSourceSection> _Nonnull section;
@property (nonatomic, readonly, copy) NSArray<id<BCLazyDataSourceItem>> * _Nonnull items;
- (void)appendItem:(id<BCLazyDataSourceItem> _Nonnull)item;
@end

id<BCLazySectionBridge> _Nonnull lazySectionBridgeWithSection(id<BCLazyDataSourceSection> _Nonnull section);
