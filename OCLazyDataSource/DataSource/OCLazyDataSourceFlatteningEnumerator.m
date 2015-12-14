//
//  OCLazyDataSourceFlatteningEnumerator.m
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "OCLazyDataSourceFlatteningEnumerator.h"
#import "OCLazyDataSourceEnumerable.h"
#import "OCLazyDataSourceEnumerator.h"

@interface OCLazyDataSourceFlatteningEnumeratorImpl : NSEnumerator<OCLazyDataSourceEnumerator>
@property (nonatomic, readonly) id<OCLazyDataSourceEnumerator> _Nonnull sourceEnumerator;
@property (nonatomic) id<OCLazyDataSourceEnumerator> _Nonnull currentEnumerator;
@end
@implementation OCLazyDataSourceFlatteningEnumeratorImpl
- (instancetype _Nullable)initWithEnumerator:(id<OCLazyDataSourceEnumerator> _Nonnull)sourceEnumerator
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
        if ([nextItem conformsToProtocol:@protocol(OCLazyDataSourceEnumerable)]
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

id<OCLazyDataSourceEnumerator> _Nonnull lazyDataSourceFlatteningEnumeratorWithBlock(id _Nullable (^ _Nonnull nextObject)())
{
    return lazyDataSourceFlatteningEnumeratorWithEnumerator(lazyDataSourceEnumeratorWithBlock(nextObject));
}
id<OCLazyDataSourceEnumerator> _Nonnull lazyDataSourceFlatteningEnumeratorWithEnumerator(id<OCLazyDataSourceEnumerator> _Nonnull sourceEnumerator)
{
    return [[OCLazyDataSourceFlatteningEnumeratorImpl alloc] initWithEnumerator:sourceEnumerator];
}
id<OCLazyDataSourceEnumerator> _Nonnull lazyDataSourceFlatteningEnumeratorWithNSEnumerator(NSEnumerator * _Nonnull sourceEnumerator)
{
    return lazyDataSourceFlatteningEnumeratorWithEnumerator(lazyDataSourceEnumeratorWithNSEnumerator(sourceEnumerator));
}
