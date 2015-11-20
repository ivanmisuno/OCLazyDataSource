//
//  SGIImageResultsViewController.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIImageResultsViewController.h"
#import "SGISearchItem.h"

@interface SGIImageResultsViewController()

@property (nonatomic) SGISearchItem *search;

@property (nonatomic) UICollectionViewLayout *collectionViewLayout;
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
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewLayout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];

    NSDictionary *views = @{@"collectionView":self.collectionView};
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:views]];
}

@end
