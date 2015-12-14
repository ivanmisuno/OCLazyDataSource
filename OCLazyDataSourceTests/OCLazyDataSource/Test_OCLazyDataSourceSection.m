//
//  Test_OCLazyDataSourceSection.m
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

@interface Test_OCLazyDataSourceSection : XCTestCase
@property (nonatomic, readonly) NSArray *sourceData;
@property (nonatomic, readonly) id<OCLazyDataSourceSection> section;
@end

@implementation Test_OCLazyDataSourceSection

- (void)setUp {
    [super setUp];
    _sourceData = @[@1, @2, @3, @4, @5];
    //, @"section1 header", @"section1 footer"
    _section = lazyDataSourceSectionWithEnumerable(self.sourceData, lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"ReuseIdentifier"));
}

- (void)testSectionEnumeration
{
    expect(@([[self.section.enumerator asNSEnumerator] count])).to(equal(@(self.sourceData.count)));

    NSEnumerator *sourceEnumerator = self.sourceData.objectEnumerator;
    [[self.section.enumerator asNSEnumerator] all:^BOOL (NSObject<OCLazyDataSourceItem> *lazyDataSourceItem) {
        expect(@([lazyDataSourceItem conformsToProtocol:@protocol(OCLazyDataSourceItem)])).to(beTrue());
        expect(lazyDataSourceItem.sourceItem).to(equal([sourceEnumerator nextObject]));
        expect(lazyDataSourceItem.section).to(equal(self.section));
        return YES;
    }];
}

//- (void)testSectionSimpleComposing
//{
//    NSArray *sourceData2 = @[@11, @12, @13];
//    id<OCLazyDataSourceSection> section2 = lazyDataSourceSectionWithEnumerable(sourceData2, @"section2 header", @"section2 footer");
//
//    NSArray *sections = @[ self.section, section2 ];
//    
//}

- (void)testSectionInserting
{
    NSArray *insertData = @[@11, @12, @13];
    //@"section2 header", @"section2 footer"
    id<OCLazyDataSourceSection> insertSection = lazyDataSourceSectionWithEnumerable(insertData, lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"ReuseIdentifier"));
    NSEnumerator *(^insertSectionEnumerator)() = ^{ return [insertSection.enumerator asNSEnumerator]; };

    NSEnumerator *(^sourceSectionEnumerator)() = ^{ return [self.section.enumerator asNSEnumerator]; };
    NSEnumerator *(^newSectionSequence)() = ^{ return [[[sourceSectionEnumerator() take:2]
                                                        concat:insertSectionEnumerator()]
                                                       concat:[sourceSectionEnumerator() skip:2]]; };
    expect(@([newSectionSequence() count])).to(equal(@([sourceSectionEnumerator() count]+[insertSectionEnumerator() count])));
    
}



@end
