//
//  OCLazyDataSourceEnumerator.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCLazyDataSourceEnumerator <NSObject>
- (NSEnumerator * _Nonnull)asNSEnumerator;
- (id _Nullable)nextObject;
@end

id<OCLazyDataSourceEnumerator> _Nonnull lazyDataSourceEnumeratorWithBlock(id _Nullable (^ _Nonnull nextObject)());
id<OCLazyDataSourceEnumerator> _Nonnull lazyDataSourceEnumeratorWithNSEnumerator(NSEnumerator * _Nonnull sourceEnumerator);
