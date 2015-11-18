//
//  SGIFirstViewController.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIFirstViewController.h"
#import "SGIResultsTableController.h"
#import "SGISearchItem.h"

@interface SGIFirstViewController() <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, readonly) NSMutableArray<SGISearchItem *> *savedSearches;

@property (nonatomic) UISearchController *searchController;

// our secondary search results table view
@property (nonatomic) SGIResultsTableController *resultsTableController;

@end

@implementation SGIFirstViewController

@synthesize savedSearches = _savedSearches;
- (NSMutableArray<SGISearchItem *> *)savedSearches
{
    if (!_savedSearches)
    {
        _savedSearches = [NSMutableArray new];
    }
    return _savedSearches;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Search Google Images", nil);

    _resultsTableController = [[SGIResultsTableController alloc] init];

    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;

//    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
//    self.resultsTableController.tableView.delegate = self;

    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others

    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {

}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"search like %@", strippedString];
    NSArray<SGISearchItem *> *searchResults = [self.savedSearches filteredArrayUsingPredicate:predicate];

    // hand over the filtered results to our search results table
    self.resultsTableController.filteredSearches = searchResults;
}

@end
