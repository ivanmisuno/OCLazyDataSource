//
//  SGIResultsTableController.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIResultsTableController.h"
#import "SGISearchItem.h"
#import "SGIResultsTableControllerDelegate.h"

@interface SGIResultsTableController()
@property (nonatomic) NSArray<SGISearchItem *> *filteredSearches;
@property (nonatomic) NSString *searchString;
@end

@implementation SGIResultsTableController

- (void)setFilteredSearches:(NSArray<SGISearchItem *> *)filteredSearches
            forSearchString:(NSString *)searchString
{
    _filteredSearches = filteredSearches;
    _searchString = searchString;
    [self.tableView reloadData];
}

- (NSAttributedString *)prepareAttributedStringForTitle:(NSString *)title
                                                 search:(NSString *)search
{
    NSDictionary *defaultAttributes = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                        NSForegroundColorAttributeName:[UIColor grayColor]};
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:title attributes:defaultAttributes];

    NSDictionary *highlightAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};

    NSError *error = nil;
    NSRegularExpression *rg = [NSRegularExpression regularExpressionWithPattern:search options:NSRegularExpressionCaseInsensitive error:&error];
    [rg enumerateMatchesInString:title options:0 range:NSMakeRange(0, title.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [resultString setAttributes:highlightAttributes range:result.range];
    }];

    return resultString;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredSearches.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const kReuseIdentifier = @"SavedSearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kReuseIdentifier];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    if (indexPath.row < self.filteredSearches.count)
    {
        SGISearchItem *item = self.filteredSearches[indexPath.row];
        cell.textLabel.attributedText = [self prepareAttributedStringForTitle:item.search search:self.searchString];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row < self.filteredSearches.count)
    {
        SGISearchItem *selectedSearch = self.filteredSearches[indexPath.row];
        [self.searchDelegate resultsTableController:self didSelectSearch:selectedSearch];
    }
}

@end
