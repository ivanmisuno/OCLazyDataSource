//
//  BCLazyDataSourceFlatteningEnumerator.h
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCLazyDataSourceEnumerator;

id<BCLazyDataSourceEnumerator> _Nonnull lazyDataSourceFlatteningEnumeratorWithBlock(id _Nullable (^ _Nonnull nextObject)());
id<BCLazyDataSourceEnumerator> _Nonnull lazyDataSourceFlatteningEnumeratorWithEnumerator(id<BCLazyDataSourceEnumerator> _Nonnull sourceEnumerator);
id<BCLazyDataSourceEnumerator> _Nonnull lazyDataSourceFlatteningEnumeratorWithNSEnumerator(NSEnumerator * _Nonnull sourceEnumerator);
