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
#import "SGIObjectStore.h"

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
        _savedSearches = [[[self class] loadSearches] mutableCopy];
    }
    return _savedSearches;
}

+ (SGIObjectStore *)saveManager
{
    return [SGIObjectStore new];
}
+ (NSArray<SGISearchItem *> *)loadSearches
{
    SGIObjectStore *saveManager = [self saveManager];
    return [saveManager loadSearches];
}
- (void)saveSearches
{
    SGIObjectStore *saveManager = [[self class] saveManager];
    [saveManager saveSearches:self.savedSearches];
}

- (NSString *)searchString
{
    NSString *searchText = self.searchController.searchBar.text;
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return strippedString;
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

- (void)doSearch:(NSString *)searchString
{
    SGISearchItem *search = [SGISearchItem createSearchItemWithSearch:searchString];
    [self.savedSearches insertObject:search atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self saveSearches];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar != self.searchController.searchBar) return;
    [searchBar resignFirstResponder];

    NSString *searchString = [self searchString];
    [self doSearch:searchString];

    // this resets search bar
    self.searchController.active = NO;
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
    if (searchController != self.searchController) return;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"search like %@", [self searchString]];
    NSArray<SGISearchItem *> *searchResults = [self.savedSearches filteredArrayUsingPredicate:predicate];

    // hand over the filtered results to our search results table
    self.resultsTableController.filteredSearches = searchResults;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.savedSearches.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const kReuseIdentifier = @"SavedSearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kReuseIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    if (indexPath.row < self.savedSearches.count)
    {
        SGISearchItem *item = self.savedSearches[indexPath.row];
        cell.textLabel.text = item.search;
    }

    return cell;
}

@end
