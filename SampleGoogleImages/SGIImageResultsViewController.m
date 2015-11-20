//
//  SGIImageResultsViewController.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIImageResultsViewController.h"
#import "SGISearchItem.h"

// cells
#import "SGICollectionViewItem.h"
#import "SGIImageResultCell.h"
#import "SGILoadMoreCell.h"

// results
#import "SGIImageSearchResults.h"
#import "SGIImageSearchResultItem.h"

// network
#import "AppDelegate.h"
#import "SGIImageSearchManager.h"
#import "SGIImageSearchQueryBuilder.h"

static NSString *const kImageResultCellIdentifier = @"ImageResultCell";
static NSString *const kLoadMoreCellIdentifier = @"LoadMoreCell";

@interface SGIImageResultsViewController() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) SGISearchItem *search;
@property (nonatomic) NSURLSessionTask *request;
@property (nonatomic) BOOL requestFailed;

@property (nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray<SGICollectionViewItem *> *dataSource;

@end

@implementation SGIImageResultsViewController

- (void)dealloc
{
    if (self.request)
    {
        [self.request cancel];
        self.request = nil;
    }
}

- (void)showResultsForQuery:(SGISearchItem *)search
{
    self.search = search;
    self.title = self.search.search;
    if (self.isViewLoaded)
    {
        [self reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionViewLayout = [UICollectionViewFlowLayout new];
    self.collectionViewLayout.minimumLineSpacing = 20;
    self.collectionViewLayout.minimumInteritemSpacing = 20;
    self.collectionViewLayout.itemSize = CGSizeMake(100,80);

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewLayout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[SGIImageResultCell class] forCellWithReuseIdentifier:kImageResultCellIdentifier];
    [self.collectionView registerClass:[SGILoadMoreCell class] forCellWithReuseIdentifier:kLoadMoreCellIdentifier];
    [self.view addSubview:self.collectionView];

    NSDictionary *views = @{@"collectionView":self.collectionView};
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:views]];

    [self reloadData];
}

- (void)reloadData
{
    @weakify(self);

    // populate image cells
    NSMutableArray<SGICollectionViewItem *> *dataSource = [NSMutableArray new];
    for (int i = 0; i < self.search.searchResults.images.count; i++)
    {
        SGIImageSearchResultItem *searchResultImage = self.search.searchResults.images[i];
        SGICollectionViewItem *item = [SGICollectionViewItem itemWithDequeueBlock:^UICollectionViewCell * _Nonnull(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath) {
            SGIImageResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageResultCellIdentifier forIndexPath:indexPath];
            [cell displayImage:searchResultImage];
            return cell;
        } didSelectBlock:nil willDisplayBlock:nil];
        [dataSource addObject:item];
    }

    if ([self shouldDisplayLoadMoreCell])
    {
        // add "load more" cell
        // by pre-populating dataSource array, we avoid doing error-prone mapping of indexPaths to different cell types.
        // better yet: lazy generative-style datasources, that allow to build configuration, but not materialize it into in-memory array of concrete items
        SGICollectionViewItem *item = [SGICollectionViewItem itemWithDequeueBlock:^UICollectionViewCell * _Nonnull(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath) {
            SGILoadMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLoadMoreCellIdentifier forIndexPath:indexPath];
            return cell;
        } didSelectBlock:nil willDisplayBlock:^(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            [self requestNextPageIfNeeded];
        }];
        [dataSource addObject:item];
    }

    self.dataSource = [dataSource copy];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

// TODO: incapsulate collectionView delegate implementation into generic dataSource implementation to hide this boilerplate code from here
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataSource.count)
    {
        SGICollectionViewItem *dataSourceItem = self.dataSource[indexPath.row];
        return dataSourceItem.dequeueBlock(collectionView, indexPath);
    }

    // shoiuld not get here
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataSource.count)
    {
        SGICollectionViewItem *dataSourceItem = self.dataSource[indexPath.row];
        if (dataSourceItem.willDisplayBlock)
        {
            dataSourceItem.willDisplayBlock(collectionView, indexPath);
        }
    }
}

#pragma mark -

- (BOOL)shouldDisplayLoadMoreCell
{
    return (!self.requestFailed
            && (!self.search.searchResults
            || self.search.searchResults.images.count < self.search.searchResults.totalEstimatedResults));
}

- (void)requestNextPageIfNeeded
{
    // start new request, unless it is already started
    if ([self shouldDisplayLoadMoreCell]
        && self.request == nil)
    {
        @weakify(self);
        self.request = [[AppDelegate sharedDelegate].searchManager searchWithSearch:self.search.search startIndex:self.search.searchResults.images.count callback:^(SGIImageSearchResults *results, NSError *error) {
            // called back on main thread
            @strongify(self);

            if (error)
            {
                // Google JSON API allows querying only for few pages (up to 64 results), but this is not stated in the documentation,
                // so that just mark request as failing to prevent further downloads and hide "Load More" cell.
                self.requestFailed = YES;
            }
            else if (results)
            {
                if (!self.search.searchResults)
                {
                    self.search.searchResults = results;
                }
                else
                {
                    [self.search.searchResults aggregate:results];
                }
            }

            self.request = nil;

            // TODO: insert new cells with animation, including showing/hiding "Load more" cell
            [self reloadData];
        }];
    }
}

@end
