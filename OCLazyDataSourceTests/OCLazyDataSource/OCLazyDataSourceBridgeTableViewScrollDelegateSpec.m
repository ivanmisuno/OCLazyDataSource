//
//  OCLazyDataSourceBridgeTableViewScrollDelegateSpec.m
//  OCLazyDataSource
//
//  Created by Ivan Misuno on 29/01/16.
//  Copyright © 2016 Ivan Misuno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "OCLazyDataSource.h"
@import Nimble;
@import Quick;

QuickSpecBegin(OCLazyDataSourceBridgeTableViewScrollDelegateSpec)

describe(@"OCLazyDataSourceBridgeTableView.scrollViewDelegate", ^{
    __block UITableView *tableView;
    __block id<OCLazyDataSourceBridge, UIScrollViewDelegate> sut;
    __block id scrollViewDelegateMock;
    beforeEach(^{
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        sut = lazyDataSourceBridgeForTableView(tableView);

        scrollViewDelegateMock = OCMStrictProtocolMock(@protocol(UIScrollViewDelegate));
        sut.scrollViewDelegate = scrollViewDelegateMock;
    });

    it(@"OCLazyDataSourceBridge conforms to UIScrollViewDelegate protococol", ^{
        expect(@([sut conformsToProtocol:@protocol(UIScrollViewDelegate)])).to(beTrue());
    });

    it(@"forwards scrollViewDidScroll:", ^{
        OCMExpect([scrollViewDelegateMock scrollViewDidScroll:tableView]);
        expect(@([sut respondsToSelector:@selector(scrollViewDidScroll:)])).to(beTrue());
        [sut scrollViewDidScroll:tableView];
        OCMVerifyAll(scrollViewDelegateMock);
    });

    it(@"forwards scrollViewDidZoom:", ^{
        OCMExpect([scrollViewDelegateMock scrollViewDidZoom:tableView]);
        [sut respondsToSelector:@selector(scrollViewDidZoom:)];
        [sut scrollViewDidZoom:tableView];
        OCMVerifyAll(scrollViewDelegateMock);
    });

    it(@"forwards scrollViewWillBeginDragging:", ^{
        OCMExpect([scrollViewDelegateMock scrollViewWillBeginDragging:tableView]);
        [sut respondsToSelector:@selector(scrollViewWillBeginDragging:)];
        [sut scrollViewWillBeginDragging:tableView];
        OCMVerifyAll(scrollViewDelegateMock);
    });

    it(@"forwards scrollViewWillEndDragging:withVelocity:targetContentOffset:", ^{
        CGPoint velocity = CGPointMake(1,0);
        CGPoint targetContentOffset = CGPointZero;
        OCMExpect([scrollViewDelegateMock scrollViewWillEndDragging:tableView withVelocity:velocity targetContentOffset:&targetContentOffset]);
        [sut respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)];
        [sut scrollViewWillEndDragging:tableView withVelocity:velocity targetContentOffset:&targetContentOffset];
        OCMVerifyAll(scrollViewDelegateMock);
    });

    it(@"forwards scrollViewDidEndDragging:willDecelerate:", ^{
        BOOL decelerate = YES;
        OCMExpect([scrollViewDelegateMock scrollViewDidEndDragging:tableView willDecelerate:decelerate]);
        [sut respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)];
        [sut scrollViewDidEndDragging:tableView willDecelerate:decelerate];
        OCMVerifyAll(scrollViewDelegateMock);
    });

    it(@"forwards scrollViewWillBeginDecelerating:", ^{
        OCMExpect([scrollViewDelegateMock scrollViewWillBeginDecelerating:tableView]);
        [sut respondsToSelector:@selector(scrollViewWillBeginDecelerating:)];
        [sut scrollViewWillBeginDecelerating:tableView];
        OCMVerifyAll(scrollViewDelegateMock);
    });

    it(@"forwards scrollViewDidEndDecelerating:", ^{
        OCMExpect([scrollViewDelegateMock scrollViewDidEndDecelerating:tableView]);
        [sut respondsToSelector:@selector(scrollViewDidEndDecelerating:)];
        [sut scrollViewDidEndDecelerating:tableView];
        OCMVerifyAll(scrollViewDelegateMock);
    });

    it(@"forwards scrollViewDidEndScrollingAnimation:", ^{
        OCMExpect([scrollViewDelegateMock scrollViewDidEndScrollingAnimation:tableView]);
        [sut respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)];
        [sut scrollViewDidEndScrollingAnimation:tableView];
        OCMVerifyAll(scrollViewDelegateMock);
    });

    it(@"forwards viewForZoomingInScrollView:", ^{
        UIView *resultView = [[UIView alloc] init];
        [OCMExpect([scrollViewDelegateMock viewForZoomingInScrollView:tableView]) andReturn:resultView];
        [sut respondsToSelector:@selector(viewForZoomingInScrollView:)];
        expect([sut viewForZoomingInScrollView:tableView]).to(equal(resultView));
        OCMVerifyAll(scrollViewDelegateMock);
    });

    it(@"forwards scrollViewWillBeginZooming:withView:", ^{
        UIView *view = [[UIView alloc] init];
        OCMExpect([scrollViewDelegateMock scrollViewWillBeginZooming:tableView withView:view]);
        [sut respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)];
        [sut scrollViewWillBeginZooming:tableView withView:view];
        OCMVerifyAll(scrollViewDelegateMock);
    });

    it(@"forwards scrollViewDidEndZooming:withView:atScale:", ^{
        UIView *view = [[UIView alloc] init];
        CGFloat scale = 1.0;
        OCMExpect([scrollViewDelegateMock scrollViewDidEndZooming:tableView withView:view atScale:scale]);
        [sut respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)];
        [sut scrollViewDidEndZooming:tableView withView:view atScale:scale];
        OCMVerifyAll(scrollViewDelegateMock);
    });

    it(@"forwards scrollViewShouldScrollToTop:", ^{
        [OCMExpect([scrollViewDelegateMock scrollViewShouldScrollToTop:tableView]) andReturnValue:@(YES)];
        [sut respondsToSelector:@selector(scrollViewShouldScrollToTop:)];
        expect(@([sut scrollViewShouldScrollToTop:tableView])).to(beTrue());
        OCMVerifyAll(scrollViewDelegateMock);
    });

    it(@"forwards scrollViewDidScroll:", ^{
        OCMExpect([scrollViewDelegateMock scrollViewDidScrollToTop:tableView]);
        [sut respondsToSelector:@selector(scrollViewDidScrollToTop:)];
        [sut scrollViewDidScrollToTop:tableView];
        OCMVerifyAll(scrollViewDelegateMock);
    });

});

QuickSpecEnd
