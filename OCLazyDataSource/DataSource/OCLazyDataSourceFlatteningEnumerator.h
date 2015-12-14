//
//  OCLazyDataSourceFlatteningEnumerator.h
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCLazyDataSourceEnumerator;

id<OCLazyDataSourceEnumerator> _Nonnull lazyDataSourceFlatteningEnumeratorWithBlock(id _Nullable (^ _Nonnull nextObject)());
id<OCLazyDataSourceEnumerator> _Nonnull lazyDataSourceFlatteningEnumeratorWithEnumerator(id<OCLazyDataSourceEnumerator> _Nonnull sourceEnumerator);
id<OCLazyDataSourceEnumerator> _Nonnull lazyDataSourceFlatteningEnumeratorWithNSEnumerator(NSEnumerator * _Nonnull sourceEnumerator);
