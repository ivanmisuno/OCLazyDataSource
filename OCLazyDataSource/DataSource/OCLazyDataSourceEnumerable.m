//
//  OCLazyDataSourceEnumerable.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "OCLazyDataSourceEnumerable.h"

@interface OCLazyDataSourceEnumerableWithBlock : NSObject<OCLazyDataSourceEnumerable>
@property (nonatomic, readonly) OCLazyDataSourceEnumeratorGeneratorBlock enumeratorGeneratorBlock;
@end
@implementation OCLazyDataSourceEnumerableWithBlock
- (instancetype _Nullable)initWithEnumeratorGeneratorBlock:(OCLazyDataSourceEnumeratorGeneratorBlock _Nonnull)enumeratorGeneratorBlock
{
    self = [super init];
    if (self)
    {
        _enumeratorGeneratorBlock = enumeratorGeneratorBlock;
    }
    return self;
}
- (id<OCLazyDataSourceEnumerator> _Nonnull)enumerator
{
    return self.enumeratorGeneratorBlock();
}
@end

id<OCLazyDataSourceEnumerable> _Nonnull lazyDataSourceEnumerableWithGeneratorBlock(OCLazyDataSourceEnumeratorGeneratorBlock _Nonnull enumeratorGeneratorBlock)
{
    return [[OCLazyDataSourceEnumerableWithBlock alloc] initWithEnumeratorGeneratorBlock:enumeratorGeneratorBlock];
}
