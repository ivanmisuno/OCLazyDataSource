//
//  OCLazyDataSourceEnumerator.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "OCLazyDataSourceEnumerator.h"

//////////////////////////////////////////////////////////////////////

typedef id _Nullable (^ OCLazyDataSourceNextObjectBlock)();

@interface OCLazyDataSourceEnumeratorBlock : NSEnumerator <OCLazyDataSourceEnumerator>
@property (nonatomic, readonly) OCLazyDataSourceNextObjectBlock _Nonnull nextObjectBlock;
@end
@implementation OCLazyDataSourceEnumeratorBlock
- (instancetype _Nullable)initWithNextObjectBlock:(OCLazyDataSourceNextObjectBlock _Nonnull)nextObjectBlock
{
    self = [super init];
    if (self)
    {
        _nextObjectBlock = nextObjectBlock;
    }
    return self;
}

- (NSEnumerator * _Nonnull)asNSEnumerator
{
    return self;
}
- (id _Nullable)nextObject
{
    return self.nextObjectBlock();
}
@end

id<OCLazyDataSourceEnumerator> _Nonnull lazyDataSourceEnumeratorWithBlock(OCLazyDataSourceNextObjectBlock _Nonnull nextObjectBlock)
{
    return [[OCLazyDataSourceEnumeratorBlock alloc] initWithNextObjectBlock:nextObjectBlock];
}

id<OCLazyDataSourceEnumerator> _Nonnull lazyDataSourceEnumeratorWithNSEnumerator(NSEnumerator * _Nonnull sourceEnumerator)
{
    return lazyDataSourceEnumeratorWithBlock(^id _Nullable(){
        return [sourceEnumerator nextObject];
    });
}
