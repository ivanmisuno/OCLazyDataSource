//
//  OCLazyDataSourceEnumerable.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCLazyDataSourceEnumerator;

@protocol OCLazyDataSourceEnumerable
- (id<OCLazyDataSourceEnumerator> _Nonnull)enumerator;
@end

typedef id<OCLazyDataSourceEnumerator> _Nonnull (^OCLazyDataSourceEnumeratorGeneratorBlock)();
id<OCLazyDataSourceEnumerable> _Nonnull lazyDataSourceEnumerableWithGeneratorBlock(OCLazyDataSourceEnumeratorGeneratorBlock _Nonnull enumeratorGeneratorBlock);
