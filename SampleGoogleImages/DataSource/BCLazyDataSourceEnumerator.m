//
//  BCLazyDataSourceEnumerator.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "BCLazyDataSourceEnumerator.h"

//////////////////////////////////////////////////////////////////////

typedef id _Nullable (^ BCLazyDataSourceNextObjectBlock)();

@interface BCLazyDataSourceEnumeratorBlock : NSEnumerator <BCLazyDataSourceEnumerator>
@property (nonatomic, readonly) BCLazyDataSourceNextObjectBlock _Nonnull nextObjectBlock;
@end
@implementation BCLazyDataSourceEnumeratorBlock
- (instancetype _Nullable)initWithNextObjectBlock:(BCLazyDataSourceNextObjectBlock _Nonnull)nextObjectBlock
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

id<BCLazyDataSourceEnumerator> _Nonnull lazyDataSourceEnumeratorWithBlock(BCLazyDataSourceNextObjectBlock _Nonnull nextObjectBlock)
{
    return [[BCLazyDataSourceEnumeratorBlock alloc] initWithNextObjectBlock:nextObjectBlock];
}

id<BCLazyDataSourceEnumerator> _Nonnull lazyDataSourceEnumeratorWithNSEnumerator(NSEnumerator * _Nonnull sourceEnumerator)
{
    return lazyDataSourceEnumeratorWithBlock(^id _Nullable(){
        return [sourceEnumerator nextObject];
    });
}
