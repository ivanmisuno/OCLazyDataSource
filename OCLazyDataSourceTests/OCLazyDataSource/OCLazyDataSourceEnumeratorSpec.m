//
//  OCLazyDataSourceEnumeratorSpec.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCLazyDataSourceEnumerator.h"
@import NSEnumeratorLinq;
@import Nimble;
@import Quick;

QuickSpecBegin(OCLazyDataSourceEnumeratorSpec)

describe(@"OCLazyDataSourceEnumerator", ^{
    __block NSArray *testCollection;
    beforeEach(^{
        testCollection = @[@1, @2, @3, @4, @5];
    });

    context(@"EnumeratorWithNSEnumerator", ^{
        __block id<OCLazyDataSourceEnumerator> (^enumerator)();
        beforeEach(^{
            enumerator = ^id<OCLazyDataSourceEnumerator> { return lazyDataSourceEnumeratorWithNSEnumerator(testCollection.objectEnumerator); };
        });

        it(@"counts to source collection count with NSEnumerator", ^{
            expect(@([[enumerator() asNSEnumerator] count])).to(equal(@(testCollection.count)));
            expect([enumerator() asNSEnumerator].allObjects).to(equal(testCollection));
        });
    });

    context(@"EnumeratorWithBlock", ^{
        __block id<OCLazyDataSourceEnumerator> (^enumerator)();
        beforeEach(^{
            enumerator = ^id<OCLazyDataSourceEnumerator> {
                NSEnumerator *sourceEnumerator = testCollection.objectEnumerator;
                return lazyDataSourceEnumeratorWithBlock(^id _Nullable{
                    return [sourceEnumerator nextObject];
                });
            };
        });

        it(@"counts to source collection count with NSEnumerator", ^{
            expect(@([[enumerator() asNSEnumerator] count])).to(equal(@(testCollection.count)));
            expect([enumerator() asNSEnumerator].allObjects).to(equal(testCollection));
        });
    });

});

QuickSpecEnd
