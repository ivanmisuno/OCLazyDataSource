//
//  NSArray+OCLazyDataSourceEnumerable.m
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "NSArray+OCLazyDataSourceEnumerable.h"
#import "OCLazyDataSourceEnumerator.h"

@implementation NSArray (OCLazyDataSourceEnumerable)
- (id<OCLazyDataSourceEnumerator> _Nonnull)enumerator
{
    return lazyDataSourceEnumeratorWithNSEnumerator(self.objectEnumerator);
}
@end
