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

#import "BCLazyTableViewDataSource.h"
#import "BCLazyDataSourceSection.h"
#import "BCLazyTableViewCellFactory.h"
#import "BCLazyDataSourceEnumerator.h"
#import "NSArray+BCLazyDataSourceEnumerable.h"

#import "BCSampleNewsCell.h"

@import AFNetworking;
@import NSEnumeratorLinq;


@interface SGIFirstViewController() <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, SGIResultsTableControllerDelegate>

@property (nonatomic, readonly) NSMutableArray<SGISearchItem *> *savedSearches;
@property (nonatomic, readwrite) NSArray<SGISearchItem *> *sortedSearches;
@property (nonatomic, readonly) NSSortDescriptor *sortDescriptor;

@property (nonatomic) UISearchController *searchController;

// our secondary search results table view
@property (nonatomic) SGIResultsTableController *resultsTableController;


@property (nonatomic, readonly) BCLazyTableViewDataSource *dataSource;

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

    self.title = NSLocalizedString(@"BCLazyTableViewDataSource", nil);

    _dataSource = [[BCLazyTableViewDataSource alloc] init];
    self.tableView.dataSource = self.dataSource.bridgeDataSource;
    self.tableView.delegate = self.dataSource.bridgeDataSource;

    NSArray *section1data = @[@{@"title":@"FBI searches lake in San Bernardino terrorism probe; questions over what neighbors saw",
                                @"subtitle":@"An FBI dive team on Thursday searches for electronic devices or other evidence possibly left in Seccombe Lake, about two miles north of the Inland Regional Center in San Bernardino.",
                                @"source":@"Los Angeles Times - ‎1 hour ago‎",
                                @"thumbnail":@"http://www.trbimg.com/img-566af767/turbine/la-2446945-me-1211-sb-folo-2-002-ls-jpg-20151210/750/750x422"},
                              @{@"title":@"Former Oklahoma police officer found guilty of multiple rapes",
                                @"subtitle":@"A former Oklahoma City police officer has been convicted of sexually assaulting women he preyed upon in a low-income neighborhood he patrolled.",
                                @"source":@"USA TODAY - ‎4 hours ago‎",
                                @"thumbnail":@"http://images.csmonitor.com/csm/2015/12/953039_1_1211-tesla_standard.jpg?alias=standard_600x400"},
                              @{@"title":@"Ben Carson joins Donald Trump in threatening to leave GOP",
                                @"subtitle":@"Washington (CNN) Ben Carson on Friday took a page from Donald Trump's playbook by threatening to depart the Republican Party. Ahead of Tuesday's GOP presidential debate, the retired neurosurgeon slammed the party after reports emerged.",
                                @"source":@"‎CNN - ‎1 hour ago",
                                @"thumbnail":@"http://specials-images.forbesimg.com/imageserve/451257034/x.jpg"},
                              @{@"title":@"Dow, DuPont set $130 billion megamerger, could spark more deals",
                                @"subtitle":@"Chemical titans DuPont and Dow Chemical Co agreed to combine in an all-stock merger valued at $130 billion, a move that could trigger more consolidation, please activist investors and generate tax savings while drawing scrutiny from regulators.",
                                @"source":@"‎Reuters - ‎47 minutes ago‎",
                                @"thumbnail":@"http://www.gannett-cdn.com/-mm-/b9109ef5edecdaeff44e26a7bea6ab951eb60ddc/c=0-384-2445-2222&r=x404&c=534x401/local/-/media/2015/12/08/USATODAY/USATODAY/635851878471081028-Capitol-photo.jpg"},
                              @{@"title":@"Scientists See Catastrophe in Latest Draft of Climate Deal",
                                @"subtitle":@"LE BOURGET, France - Scientists who are closely monitoring the climate negotiations said on Friday that the emerging agreement, and the national pledges incorporated into it, are still far too weak to ensure that humanity will avoid dangerous levels.",
                                @"source":@"‎New York Times - ‎2 hours ago",
                                @"thumbnail":@"http://photos2.appleinsidercdn.com/gallery/15243-11396-jobs_02-l.jpg"},
                              ];
    NSArray *section2data = @[@"Show more articles...",
                              @"Subscribe to not miss important updates!"];
    NSArray *bannerData = @[@"Banner 1"];


    UINib *cell1nib = [UINib nibWithNibName:@"BCSampleNewsCell" bundle:nil];
    id<BCLazyTableViewCellFactory> cellFactory1 = lazyTableViewCellFactoryWithNib(cell1nib, @"BCSampleNewsCell");
    cellFactory1.configureBlock = ^(UITableViewCell * _Nonnull cell, NSDictionary * _Nonnull model, UITableView * _Nonnull tableView) {
        BCSampleNewsCell *sampleNewsCell = (BCSampleNewsCell *)cell;
        sampleNewsCell.titleLabel.text = model[@"title"];
        sampleNewsCell.sourceLabel.text = model[@"source"];
        sampleNewsCell.contentLabel.text = model[@"subtitle"];
        [sampleNewsCell.thumbnail setImageWithURL:[NSURL URLWithString:model[@"thumbnail"]]];
    };
    id<BCLazyDataSourceSection> section1 = lazyDataSourceSectionWithEnumerable(section1data, cellFactory1);

    id<BCLazyTableViewCellFactory> cellFactory2 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"SimpleCell2");
    cellFactory2.configureBlock = ^(UITableViewCell * _Nonnull cell, NSString * _Nonnull model, UITableView * _Nonnull tableView) {
        cell.textLabel.text = model;
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    };
    id<BCLazyDataSourceSection> section2 = lazyDataSourceSectionWithEnumerable(section2data, cellFactory2);

    id<BCLazyTableViewCellFactory> bannerCellFactory = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"BannerCell");
    bannerCellFactory.configureBlock = ^(UITableViewCell * _Nonnull cell, NSString * _Nonnull model, UITableView * _Nonnull tableView) {
        cell.backgroundColor = [UIColor blueColor];
        cell.textLabel.text = model;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    };
    id<BCLazyDataSourceSection> bannerSection = lazyDataSourceSectionWithEnumerable(bannerData, bannerCellFactory);

    NSEnumerator * (^firstSectionEnumerator)() = ^ { return [section1.enumerator asNSEnumerator]; };
    NSEnumerator * (^secondSectionEnumerator)() = ^ { return [section2.enumerator asNSEnumerator]; };
    NSEnumerator * (^bannerSectionEnumerator)() = ^ { return [bannerSection.enumerator asNSEnumerator]; };

//    id<BCLazyDataSourceEnumerator> (^finalSectionEnumerator)() = ^ {
//        NSEnumerator *enumerator =
//        [[[[firstSectionEnumerator() take:2]
//          concat:bannerSectionEnumerator()]
//         concat:[firstSectionEnumerator() skip:2]]
//         concat:secondSectionEnumerator()];
//         return lazyDataSourceEnumeratorWithNSEnumerator(enumerator);
//    };

    id<BCLazyDataSourceEnumerator> (^finalSectionEnumerator)() = ^ {
        NSEnumerator *enumerator =
        [[[[[[firstSectionEnumerator() take:2] // take 2 first elements from our initial data source
           concat:bannerSectionEnumerator()] // append a banner
          concat:[[firstSectionEnumerator() skip:2] take:2]] // take another 2
          concat:[[secondSectionEnumerator() skip:1] take:1]] // append second item from the second data source
          concat:[firstSectionEnumerator() skip:4]] // append the rest of our initial stream
         concat:[secondSectionEnumerator() take:1]]; // and, finally, append first item of the second stream
        return lazyDataSourceEnumeratorWithNSEnumerator(enumerator);
    };

    [self.dataSource setSource:lazyDataSourceEnumerableWithGeneratorBlock(finalSectionEnumerator) forTableView:self.tableView];





//    _resultsTableController = [[SGIResultsTableController alloc] init];
//    self.resultsTableController.searchDelegate = self;
//
//    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
//    self.searchController.searchResultsUpdater = self;
//    self.tableView.tableHeaderView = self.searchController.searchBar;
//
//    self.searchController.delegate = self;
//    self.searchController.dimsBackgroundDuringPresentation = YES; // default is YES
//    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
//
//    // Search is now just presenting a view controller. As such, normal view controller
//    // presentation semantics apply. Namely that presentation will walk up the view controller
//    // hierarchy until it finds the root view controller or one that defines a presentation context.
//    //
//    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
//
//    // TODO: make it lazy
//    [self projectSavedSearches];
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
    [self doSearch:searchItem.search];

    self.searchController.active = NO;
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
