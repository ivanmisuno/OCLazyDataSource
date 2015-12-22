//
//  OCLazyDataSourceItem.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCLazyDataSourceSection;

@protocol OCLazyDataSourceItem <NSObject>
@property (nonatomic, readonly) id _Nonnull sourceItem;
@property (nonatomic, readonly, weak) id<OCLazyDataSourceSection> _Nullable section;
@end

id<OCLazyDataSourceItem> _Nonnull lazyDataSourceItem(id _Nonnull sourceItem,
                                                     id<OCLazyDataSourceSection> _Nullable section);
