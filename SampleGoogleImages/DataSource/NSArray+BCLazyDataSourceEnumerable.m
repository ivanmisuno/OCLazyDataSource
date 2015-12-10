//
//  NSArray+BCLazyDataSourceEnumerable.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "NSArray+BCLazyDataSourceEnumerable.h"
#import "BCLazyDataSourceEnumerator.h"

@implementation NSArray (BCLazyDataSourceEnumerable)
- (id<BCLazyDataSourceEnumerator> _Nonnull)enumerator
{
    return lazyDataSourceEnumeratorWithEnumerator(self.objectEnumerator);
}
@end
