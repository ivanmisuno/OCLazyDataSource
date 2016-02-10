//
//  OCLazyDataSourceFlatteningEnumeratorSpec.m
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCLazyDataSourceEnumerator.h"
#import "OCLazyDataSourceFlatteningEnumerator.h"
@import NSEnumeratorLinq;
@import Nimble;
@import Quick;

QuickSpecBegin(OCLazyDataSourceFlatteningEnumeratorSpec)

describe(@"OCLazyDataSourceFlatteningEnumerator", ^{

    it(@"For flat source collection, just return it", ^{
        NSArray *testCollection = @[@1, @2, @3, @4, @5];
        id<OCLazyDataSourceEnumerator> (^enumerator)() = ^id<OCLazyDataSourceEnumerator> { return lazyDataSourceFlatteningEnumeratorWithNSEnumerator(testCollection.objectEnumerator); };

        expect(@([[enumerator() asNSEnumerator] count])).to(equal(@(testCollection.count)));
        expect([enumerator() asNSEnumerator].allObjects).to(equal(testCollection));
    });

    it(@"One-level deep nesting -> flatten", ^{
        NSArray *flatCollection = @[@1, @2, @3, @4, @5];

        NSArray *testCollection = @[@[@1, @2], @[@3, @4, @5]];
        id<OCLazyDataSourceEnumerator> (^enumerator)() = ^id<OCLazyDataSourceEnumerator> { return lazyDataSourceFlatteningEnumeratorWithNSEnumerator(testCollection.objectEnumerator); };

        expect(@([[enumerator() asNSEnumerator] count])).to(equal(@(flatCollection.count)));
        expect([enumerator() asNSEnumerator].allObjects).to(equal(flatCollection));
    });

    it(@"Arbitrary level deep collection -> flatten completely", ^{
        NSArray *flatCollection = @[@1, @2, @3, @4, @5];

        NSArray *testCollection = @[@[@[@[@[@[@1]], @2], @3], @4], @5];
        id<OCLazyDataSourceEnumerator> (^enumerator)() = ^id<OCLazyDataSourceEnumerator> { return lazyDataSourceFlatteningEnumeratorWithNSEnumerator(testCollection.objectEnumerator); };

        expect(@([[enumerator() asNSEnumerator] count])).to(equal(@(flatCollection.count)));
        expect([enumerator() asNSEnumerator].allObjects).to(equal(flatCollection));
    });

});

QuickSpecEnd
