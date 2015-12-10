//
//  BCLazyDataSourceFlatteningEnumerator.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "BCLazyDataSourceFlatteningEnumerator.h"
#import "BCLazyDataSourceEnumerable.h"
#import "BCLazyDataSourceEnumerator.h"

@interface BCLazyDataSourceFlatteningEnumeratorImpl : NSEnumerator<BCLazyDataSourceEnumerator>
@property (nonatomic, readonly) id<BCLazyDataSourceEnumerator> _Nonnull sourceEnumerator;
@property (nonatomic) id<BCLazyDataSourceEnumerator> _Nonnull currentEnumerator;
@end
@implementation BCLazyDataSourceFlatteningEnumeratorImpl
- (instancetype _Nullable)initWithEnumerator:(id<BCLazyDataSourceEnumerator> _Nonnull)sourceEnumerator
{
    self = [super init];
    if (self)
    {
        _sourceEnumerator = sourceEnumerator;
        _currentEnumerator = lazyDataSourceEnumeratorWithBlock(^id _Nullable { return nil; }); // an empty iterator
    }
    return self;
}

- (NSEnumerator * _Nonnull)asNSEnumerator
{
    return self;
}
- (id _Nullable)nextObject
{
    id item;
    while((item = [self.currentEnumerator nextObject]) == nil) {
        id nextItem = [self.sourceEnumerator nextObject];
        if ([nextItem conformsToProtocol:@protocol(BCLazyDataSourceEnumerable)]
            //|| [nextItem respondsToSelector:@selector(enumerator)]
            ) {
            self.currentEnumerator = lazyDataSourceFlatteningEnumeratorWithEnumerator([nextItem enumerator]);
            continue;
        }
        return nextItem;
    }
    return item;
}
@end

id<BCLazyDataSourceEnumerator> _Nonnull lazyDataSourceFlatteningEnumeratorWithBlock(id _Nullable (^ _Nonnull nextObject)())
{
    return lazyDataSourceFlatteningEnumeratorWithEnumerator(lazyDataSourceEnumeratorWithBlock(nextObject));
}
id<BCLazyDataSourceEnumerator> _Nonnull lazyDataSourceFlatteningEnumeratorWithEnumerator(id<BCLazyDataSourceEnumerator> _Nonnull sourceEnumerator)
{
    return [[BCLazyDataSourceFlatteningEnumeratorImpl alloc] initWithEnumerator:sourceEnumerator];
}
id<BCLazyDataSourceEnumerator> _Nonnull lazyDataSourceFlatteningEnumeratorWithNSEnumerator(NSEnumerator * _Nonnull sourceEnumerator)
{
    return lazyDataSourceFlatteningEnumeratorWithEnumerator(lazyDataSourceEnumeratorWithNSEnumerator(sourceEnumerator));
}
