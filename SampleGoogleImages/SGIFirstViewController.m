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
#import "SGIResultsTableControllerDelegate.h"
#import "SGIImageResultsViewController.h"

@interface SGIFirstViewController() <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, SGIResultsTableControllerDelegate>

@property (nonatomic, readonly) NSMutableArray<SGISearchItem *> *savedSearches;
@property (nonatomic, readwrite) NSArray<SGISearchItem *> *sortedSearches;
@property (nonatomic, readonly) NSSortDescriptor *sortDescriptor;

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

@synthesize sortDescriptor = _sortDescriptor;
- (NSSortDescriptor *)sortDescriptor
{
    if (!_sortDescriptor)
    {
        _sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@keypath(SGISearchItem.new, timestamp) ascending:NO];
    }
    return _sortDescriptor;
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
    self.resultsTableController.searchDelegate = self;

    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;

    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = YES; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others

    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed

    // TODO: make it lazy
    [self projectSavedSearches];
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

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (searchController != self.searchController) return;

    NSString *searchString = [self searchString];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"search contains[cd] %@", searchString]; // [c]ase- and [d]iacritic- insensitiveness
    NSArray<SGISearchItem *> *searchResults = [self.sortedSearches filteredArrayUsingPredicate:predicate];

    // hand over the filtered results to our search results table
    [self.resultsTableController setFilteredSearches:searchResults forSearchString:searchString];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortedSearches.count;
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

    if (indexPath.row < self.sortedSearches.count)
    {
        SGISearchItem *item = self.sortedSearches[indexPath.row];
        cell.textLabel.text = item.search;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row < self.sortedSearches.count)
    {
        SGISearchItem *searchItem = self.sortedSearches[indexPath.row];
        [self doSearch:searchItem.search];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.row < self.sortedSearches.count)
        {
            SGISearchItem *item = self.sortedSearches[indexPath.row];
            [self removeSearchItem:item];
        }
    }
}

#pragma mark - SGIResultsTableControllerDelegate

- (void)resultsTableController:(SGIResultsTableController *)resultsTableController
               didSelectSearch:(SGISearchItem *)searchItem
{
    self.searchController.active = NO;

    [self doSearch:searchItem.search];
}

#pragma mark - UI Operations

- (void)doSearch:(NSString *)searchString
{
    SGISearchItem *search = [self searchItemWithString:searchString];

    SGIImageResultsViewController *searchResultsController = [[SGIImageResultsViewController alloc] initWithNibName:nil bundle:nil];
    [searchResultsController showResultsForQuery:search];
    [self.navigationController pushViewController:searchResultsController animated:YES];
}

- (SGISearchItem *)searchItemWithString:(NSString *)searchString
{
    SGISearchItem *searchItem = [self findSearchItem:searchString];
    if (searchItem)
    {
        [self updateSearchItem:searchItem];
    }
    else
    {
        searchItem = [self addNewSearchWithString:searchString];
    }
    return searchItem;
}

#pragma mark - Data source operations

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

- (void)projectSavedSearches
{
    // sorted view of saved searches
    self.sortedSearches = [self.savedSearches sortedArrayUsingDescriptors:@[self.sortDescriptor]];
}

- (SGISearchItem *)findSearchItem:(NSString *)searchString
{
    __block SGISearchItem *foundItem = nil;
    [self.savedSearches enumerateObjectsUsingBlock:^(SGISearchItem * _Nonnull searchItem, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([searchItem.search caseInsensitiveCompare:searchString] == 0)
        {
            foundItem = searchItem;
            *stop = YES;
        }
    }];
    return foundItem;
}
- (void)updateSearchItem:(SGISearchItem *)searchItem
{
    NSInteger oldViewIndex = [self.sortedSearches indexOfObject:searchItem];

    [searchItem updateTimestamp];
    [self saveSearches];
    [self projectSavedSearches];

    NSInteger newViewIndex = [self.sortedSearches indexOfObject:searchItem];

    if (oldViewIndex != NSNotFound && newViewIndex != NSNotFound)
    {
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldViewIndex inSection:0];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newViewIndex inSection:0];
        [self.tableView moveRowAtIndexPath:oldIndexPath toIndexPath:newIndexPath];
    }
    else
    {
        [self.tableView reloadData];
    }
}

- (SGISearchItem *)addNewSearchWithString:(NSString *)searchString
{
    SGISearchItem *newSearch = [SGISearchItem createSearchItemWithSearch:searchString];
    [self.savedSearches addObject:newSearch];
    [self saveSearches];

    [self projectSavedSearches];

    NSInteger indexOfAddedItemInView = [self.sortedSearches indexOfObject:newSearch];
    if (indexOfAddedItemInView != NSNotFound)
    {
        NSIndexPath *insertedItemIndexPath = [NSIndexPath indexPathForRow:indexOfAddedItemInView inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[insertedItemIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [self.tableView reloadData];
    }

    return newSearch;
}

- (void)removeSearchItem:(SGISearchItem *)searchItem
{
    NSInteger objectIndex = [self.savedSearches indexOfObject:searchItem];
    if (objectIndex != NSNotFound)
    {
        [self.savedSearches removeObjectAtIndex:objectIndex];
        [self saveSearches];

        NSInteger oldTableIndex = [self.sortedSearches indexOfObject:searchItem];

        [self projectSavedSearches];

        if (oldTableIndex != NSNotFound)
        {
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldTableIndex inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[oldIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            [self.tableView reloadData];
        }
    }
}

@end
