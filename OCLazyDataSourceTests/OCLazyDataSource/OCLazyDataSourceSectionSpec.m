//
//  OCLazyDataSourceSectionSpec.m
//
//  Created by Ivan Misuno on 10/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCLazyDataSourceSection.h"
#import "OCLazyDataSourceEnumerator.h"
#import "OCLazyDataSourceItem.h"
#import "OCLazyTableViewCellFactory.h"
#import "NSArray+OCLazyDataSourceEnumerable.h"
@import NSEnumeratorLinq;
@import Nimble;
@import Quick;

QuickSpecBegin(OCLazyDataSourceSectionSpec)

describe(@"OCLazyDataSourceSection", ^{
    __block NSArray *sourceData;
    __block id<OCLazyDataSourceSection> section;
    beforeEach(^{
        sourceData = @[@1, @2, @3, @4, @5];
        //, @"section1 header", @"section1 footer"
        section = lazyDataSourceSectionWithEnumerable(sourceData, lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"ReuseIdentifier"));
    });

    it(@"section can be enumerated", ^{
        expect(@([[section.enumerator asNSEnumerator] count])).to(equal(@(sourceData.count)));

        NSEnumerator *sourceEnumerator = sourceData.objectEnumerator;
        [[section.enumerator asNSEnumerator] all:^BOOL (NSObject<OCLazyDataSourceItem> *lazyDataSourceItem) {
            expect(@([lazyDataSourceItem conformsToProtocol:@protocol(OCLazyDataSourceItem)])).to(beTrue());
            expect(lazyDataSourceItem.sourceItem).to(equal([sourceEnumerator nextObject]));
            expect(lazyDataSourceItem.section).to(equal(section));
            return YES;
        }];
    });

    it(@"section can be composed", ^{
        NSArray *insertData = @[@11, @12, @13];
        //@"section2 header", @"section2 footer"
        id<OCLazyDataSourceSection> insertSection = lazyDataSourceSectionWithEnumerable(insertData, lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"ReuseIdentifier"));
        NSEnumerator *(^insertSectionEnumerator)() = ^{ return [insertSection.enumerator asNSEnumerator]; };

        NSEnumerator *(^sourceSectionEnumerator)() = ^{ return [section.enumerator asNSEnumerator]; };
        NSEnumerator *(^newSectionSequence)() = ^{ return [[[sourceSectionEnumerator() take:2]
                                                            concat:insertSectionEnumerator()]
                                                           concat:[sourceSectionEnumerator() skip:2]]; };
        expect(@([newSectionSequence() count])).to(equal(@([sourceSectionEnumerator() count]+[insertSectionEnumerator() count])));

        NSArray<id<OCLazyDataSourceItem>> *materializedSequence = newSectionSequence().toArray;
        int finalIndex = 0;
        for (int i = 0; i < 2; i++, finalIndex++)
        {
            expect(materializedSequence[finalIndex].sourceItem).to(equal(sourceData[i]));
            expect(materializedSequence[finalIndex].section).to(equal(section));
        }
        for (int i = 0; i < insertData.count; i++, finalIndex++)
        {
            expect(materializedSequence[finalIndex].sourceItem).to(equal(insertData[i]));
            expect(materializedSequence[finalIndex].section).to(equal(insertSection));
        }
        for (int i = 2; i < sourceData.count; i++, finalIndex++)
        {
            expect(materializedSequence[finalIndex].sourceItem).to(equal(sourceData[i]));
            expect(materializedSequence[finalIndex].section).to(equal(section));
        }
    });
});


QuickSpecEnd
