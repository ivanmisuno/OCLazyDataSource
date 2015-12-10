//
//  BCLazyDataSourceEnumerator.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "BCLazyDataSourceEnumerator.h"

@interface BCLazyDataSourceEnumeratorWrapper : NSEnumerator <BCLazyDataSourceEnumerator>
@property (nonatomic, readonly) NSEnumerator * _Nonnull sourceEnumerator;
@end
@implementation BCLazyDataSourceEnumeratorWrapper
- (instancetype _Nullable)initWithSourceEnumerator:(NSEnumerator * _Nonnull)sourceEnumerator
{
    self = [super init];
    if (self)
    {
        _sourceEnumerator = sourceEnumerator;
    }
    return self;
}

- (NSEnumerator * _Nonnull)asNSEnumerator
{
    return self;
}
- (id _Nullable)nextObject
{
    return [self.sourceEnumerator nextObject];
}
@end

id<BCLazyDataSourceEnumerator> _Nonnull lazyDataSourceEnumeratorWithEnumerator(NSEnumerator * _Nonnull sourceEnumerator)
{
    return [[BCLazyDataSourceEnumeratorWrapper alloc] initWithSourceEnumerator:sourceEnumerator];
}

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
