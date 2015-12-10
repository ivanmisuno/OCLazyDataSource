//
//  BCLazyDataSourceEnumerable.h
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCLazyDataSourceEnumerator;

@protocol BCLazyDataSourceEnumerable
- (id<BCLazyDataSourceEnumerator> _Nonnull)enumerator;
@end
