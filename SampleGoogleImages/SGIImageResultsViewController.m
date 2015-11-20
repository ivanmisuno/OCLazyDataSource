//
//  SGIImageResultsViewController.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIImageResultsViewController.h"
#import "SGISearchItem.h"
#import "SGIImageResultCell.h"
#import "SGILoadMoreCell.h"

static NSString *const kImageResultCellIdentifier = @"ImageResultCell";
static NSString *const kLoadMoreCellIdentifier = @"LoadMoreCell";

enum SectionType
{
    SectionTypeImageResults = 0,
    SectionTypeLoadMore,

    SectionType__count
};

@interface SGIImageResultsViewController() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) SGISearchItem *search;

@property (nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic) UICollectionView *collectionView;

@end

@implementation SGIImageResultsViewController

- (void)showResultsForQuery:(SGISearchItem *)search
{
    self.search = search;
    self.title = self.search.search;
    if (self.isViewLoaded)
    {
        [self.collectionView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionViewLayout = [UICollectionViewFlowLayout new];
    self.collectionViewLayout.minimumLineSpacing = 20;
    self.collectionViewLayout.minimumInteritemSpacing = 20;
    self.collectionViewLayout.itemSize = CGSizeMake(60,60);

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
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return SectionType__count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section)
    {
        case SectionTypeImageResults:
            return 0;
        case SectionTypeLoadMore:
            return 1;
    }

    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case SectionTypeImageResults:
        {
            SGIImageResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageResultCellIdentifier forIndexPath:indexPath];

            return cell;
        }
        case SectionTypeLoadMore:
        {
            SGILoadMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLoadMoreCellIdentifier forIndexPath:indexPath];

            return cell;
        }
    }

    // shoiuld not get here
    return nil;
}


@end
