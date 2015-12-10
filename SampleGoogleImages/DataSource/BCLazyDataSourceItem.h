//
//  BCLazyDataSourceItem.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCViewModel;
@protocol BCLazyDataSourceSection;

@protocol BCLazyDataSourceItem
@property (nonatomic, readonly) id _Nonnull sourceItem;
@property (nonatomic, readonly, weak) id<BCLazyDataSourceSection> _Nullable section;
@end

id<BCLazyDataSourceItem> _Nonnull lazyDataSourceItem(id _Nonnull sourceItem,
                                                     id<BCLazyDataSourceSection> _Nullable section);
