//
//  SGIResultsTableController.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIResultsTableController.h"
#import "SGISearchItem.h"

@implementation SGIResultsTableController

- (void)setFilteredSearches:(NSArray<SGISearchItem *> *)filteredSearches
{
    _filteredSearches = filteredSearches;
    [self.tableView reloadData];
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
        cell.textLabel.text = item.search;
    }

    return cell;
}

@end
