//
//  OCLazyDataSourceBridgeTableView.m
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "OCLazyDataSourceBridgeTableView.h"
#import "OCLazyDataSourceBridge.h"
#import "OCLazySectionBridge.h"
#import "OCLazyDataSourceSection.h"
#import "OCLazyDataSourceItem.h"
#import "OCLazyTableViewCellFactory.h"
#import "OCLazyTableViewHeaderFooterViewFactory.h"
#import "OCLazyTableViewCellContext.h"

@interface OCLazyDataSourceBridgeTableView : NSObject <OCLazyDataSourceBridge, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, readonly) UITableView *tableView;
@end

@implementation OCLazyDataSourceBridgeTableView

@synthesize scrollViewDelegate = _scrollViewDelegate;

- (instancetype _Nullable)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self)
    {
        _tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)registerCellFactoriesFromCombinedDataSource
{
    for (id<OCLazySectionBridge> sectionBridge in self.combinedDataSource)
    {
        if (sectionBridge.section.cellFactory)
        {
            [sectionBridge.section.cellFactory registerWithTableView:self.tableView];
        }
        if (sectionBridge.section.headerViewFactory)
        {
            [sectionBridge.section.headerViewFactory registerWithTableView:self.tableView];
        }
        if (sectionBridge.section.footerViewFactory)
        {
            [sectionBridge.section.footerViewFactory registerWithTableView:self.tableView];
        }
    }
}

- (id<OCLazyDataSourceSection> _Nullable)sectionWithIndex:(NSInteger)sectionIndex
{
    if (sectionIndex < self.combinedDataSource.count)
    {
        return self.combinedDataSource[sectionIndex].section;
    }
    return nil;
}

- (id<OCLazyDataSourceItem> _Nullable)itemForIndexPath:(NSIndexPath * _Nonnull)indexPath
{
    if (indexPath.section < self.combinedDataSource.count)
    {
        id<OCLazySectionBridge> section = self.combinedDataSource[indexPath.section];
        if (indexPath.row < section.items.count)
        {
            id<OCLazyDataSourceItem> item = section.items[indexPath.row];
            return item;
        }
    }

    return nil;
}

#pragma mark - OCLazyDataSourceBridge protocol
@synthesize combinedDataSource = _combinedDataSource;
- (void)setCombinedDataSource:(NSArray<id<OCLazySectionBridge>> *)combinedDataSource
{
    _combinedDataSource = combinedDataSource;
    [self registerCellFactoriesFromCombinedDataSource];

    // disable scrollView handlers during table reloading
    id<UIScrollViewDelegate> scrollViewDelegate = self.scrollViewDelegate; self.scrollViewDelegate = nil;

    [self.tableView reloadData];

    self.scrollViewDelegate = scrollViewDelegate;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.scrollViewDelegate scrollViewDidZoom:scrollView];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.scrollViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.scrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.scrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.scrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.scrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.scrollViewDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.scrollViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.scrollViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.scrollViewDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return NO;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.scrollViewDelegate scrollViewDidScrollToTop:scrollView];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.combinedDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < self.combinedDataSource.count)
    {
        return self.combinedDataSource[section].items.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<OCLazyDataSourceItem> item = [self itemForIndexPath:indexPath];
    if (item)
    {
        id<OCLazyTableViewCellFactory> cellFactory = item.section.cellFactory;
        UITableViewCell *cell = [cellFactory dequeueTableViewCell:tableView forIndexPath:indexPath withModelObject:item.sourceItem];
        if (cellFactory.configureBlock)
            cellFactory.configureBlock(item.sourceItem, tableView, cell);
        return cell;
    }

    NSAssert(NO, @"Should not get here: indexPath[%zd-%zd]", indexPath.section, indexPath.row);
    return nil;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

// Editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
    return NO;
}

// Moving/reordering
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
    return NO;
}

//// Index
//- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//}
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//}

// Data manipulation - insert and delete support
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
}

// Data manipulation - reorder / moving support
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // TODO: To be implemented
}

#pragma mark - UITableViewDelegate

// Display customization
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<OCLazyDataSourceItem> item = [self itemForIndexPath:indexPath];
    if (item)
    {
        id<OCLazyTableViewCellFactory> cellFactory = item.section.cellFactory;
        if (cellFactory.willDisplayBlock)
        {
            cellFactory.willDisplayBlock(item.sourceItem,
                                         tableView,
                                         lazyTableViewCellContext(/*cellBlock*/^{
                                                                      return [tableView cellForRowAtIndexPath:indexPath];
                                                                  }, /*indexPathBlock*/^NSIndexPath * _Nonnull{
                                                                      return indexPath;
                                                                  }, /*deselectBlock*/^(BOOL animated) {
                                                                      [tableView deselectRowAtIndexPath:indexPath animated:animated];
                                                                  })
                                         );
        }
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // TODO: To be implemented
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    // TODO: To be implemented
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    // TODO: To be implemented
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // TODO: To be implemented
}
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    // TODO: To be implemented
}

// Variable height support
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<OCLazyDataSourceItem> item = [self itemForIndexPath:indexPath];
    if (item)
    {
        id<OCLazyTableViewCellFactory> cellFactory = item.section.cellFactory;
        if (cellFactory.heightBlock)
            return cellFactory.heightBlock(item.sourceItem, tableView);
    }

    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    id<OCLazyDataSourceSection> section = [self sectionWithIndex:sectionIndex];
    if (section && section.headerViewFactory)
    {
        if (section.headerViewFactory.heightBlock)
        {
            return section.headerViewFactory.heightBlock(tableView);
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex
{
    id<OCLazyDataSourceSection> section = [self sectionWithIndex:sectionIndex];
    if (section && section.footerViewFactory)
    {
        if (section.footerViewFactory.heightBlock)
        {
            return section.footerViewFactory.heightBlock(tableView);
        }
    }
    return 0;
}

// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<OCLazyDataSourceItem> item = [self itemForIndexPath:indexPath];
    if (item)
    {
        id<OCLazyTableViewCellFactory> cellFactory = item.section.cellFactory;
        if (cellFactory.estimatedHeightBlock)
        {
            return cellFactory.estimatedHeightBlock(item.sourceItem, tableView);
        }
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)sectionIndex
{
    id<OCLazyDataSourceSection> section = [self sectionWithIndex:sectionIndex];
    if (section && section.headerViewFactory)
    {
        if (section.headerViewFactory.estimatedHeightBlock)
        {
            return section.headerViewFactory.estimatedHeightBlock(tableView);
        }
        if (section.headerViewFactory.heightBlock)
        {
            // return non-zero value so that tableView will later call heightForHeaderInSection:
            return 20;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)sectionIndex
{
    id<OCLazyDataSourceSection> section = [self sectionWithIndex:sectionIndex];
    if (section && section.footerViewFactory)
    {
        if (section.footerViewFactory.estimatedHeightBlock)
        {
            return section.footerViewFactory.estimatedHeightBlock(tableView);
        }
        if (section.footerViewFactory.heightBlock)
        {
            // return non-zero value so that tableView will later call heightForHeaderInSection:
            return 20;
        }
    }
    return 0;
}

// Section header & footer information. Views are preferred over title should you decide to provide both
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    id<OCLazyDataSourceSection> section = [self sectionWithIndex:sectionIndex];
    if (section && section.headerViewFactory)
    {
        UITableViewHeaderFooterView *v = [section.headerViewFactory dequeueTableViewHeaderFooterView:tableView];
        if (section.headerViewFactory.configureBlock)
        {
            section.headerViewFactory.configureBlock(tableView, v);
        }
        return v;
    }
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIndex
{
    id<OCLazyDataSourceSection> section = [self sectionWithIndex:sectionIndex];
    if (section && section.footerViewFactory)
    {
        UITableViewHeaderFooterView *v = [section.footerViewFactory dequeueTableViewHeaderFooterView:tableView];
        if (section.footerViewFactory.configureBlock)
        {
            section.footerViewFactory.configureBlock(tableView, v);
        }
        return v;
    }
    return nil;
}

// Accessories (disclosures).
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
}

// Selection
//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // TODO: To be implemented
//    return NO;
//}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
}

//// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
//- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}
//- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<OCLazyDataSourceItem> item = [self itemForIndexPath:indexPath];
    if (item)
    {
        id<OCLazyTableViewCellFactory> cellFactory = item.section.cellFactory;
        if (cellFactory.didSelectBlock)
        {
            cellFactory.didSelectBlock(item.sourceItem,
                                       tableView,
                                       lazyTableViewCellContext(/*cellBlock*/^{
                                                return [tableView cellForRowAtIndexPath:indexPath];
                                            }, /*indexPathBlock*/^NSIndexPath * _Nonnull{
                                                return indexPath;
                                            }, /*deselectBlock*/^(BOOL animated) {
                                                [tableView deselectRowAtIndexPath:indexPath animated:animated];
                                            })
                                       );
        }
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
}

// Editing
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
    return UITableViewCellEditingStyleNone;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
    return nil;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
    return nil;
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
    return NO;
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
}

// Moving/reordering
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    // TODO: To be implemented
    return nil;
}

// Indentation
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: To be implemented
    return 0;
}

//// Copy/Paste.  All three methods must be implemented by the delegate.
//- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}
//- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
//{
//}
//- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
//{
//}

@end

id<OCLazyDataSourceBridge, UITableViewDataSource, UITableViewDelegate> _Nonnull lazyDataSourceBridgeForTableView(UITableView * _Nonnull tableView)
{
    return [[OCLazyDataSourceBridgeTableView alloc] initWithTableView:tableView];
}
