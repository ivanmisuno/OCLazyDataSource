//
//  BCLazyDataSourceEnumerable.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "BCLazyDataSourceEnumerable.h"

@interface BCLazyDataSourceEnumerableWithBlock : NSObject<BCLazyDataSourceEnumerable>
@property (nonatomic, readonly) BCLazyDataSourceEnumeratorGeneratorBlock enumeratorGeneratorBlock;
@end
@implementation BCLazyDataSourceEnumerableWithBlock
- (instancetype _Nullable)initWithEnumeratorGeneratorBlock:(BCLazyDataSourceEnumeratorGeneratorBlock _Nonnull)enumeratorGeneratorBlock
{
    self = [super init];
    if (self)
    {
        _enumeratorGeneratorBlock = enumeratorGeneratorBlock;
    }
    return self;
}
- (id<BCLazyDataSourceEnumerator> _Nonnull)enumerator
{
    return self.enumeratorGeneratorBlock();
}
@end

id<BCLazyDataSourceEnumerable> _Nonnull lazyDataSourceEnumerableWithGeneratorBlock(BCLazyDataSourceEnumeratorGeneratorBlock _Nonnull enumeratorGeneratorBlock)
{
    return [[BCLazyDataSourceEnumerableWithBlock alloc] initWithEnumeratorGeneratorBlock:enumeratorGeneratorBlock];
}
