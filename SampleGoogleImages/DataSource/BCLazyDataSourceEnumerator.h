//
//  BCLazyDataSourceEnumerator.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCLazyDataSourceEnumerator
- (NSEnumerator * _Nonnull)asNSEnumerator;
- (id _Nullable)nextObject;
@end

id<BCLazyDataSourceEnumerator> _Nonnull lazyDataSourceEnumeratorWithEnumerator(NSEnumerator * _Nonnull sourceEnumerator);
id<BCLazyDataSourceEnumerator> _Nonnull lazyDataSourceEnumeratorWithBlock(id _Nullable (^ _Nonnull nextObject)());
