//
//  SGIResultsTableController.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIResultsTableController.h"

@implementation SGIResultsTableController

- (void)setFilteredSearches:(NSArray<SGISearchItem *> *)filteredSearches
{
    _filteredSearches = filteredSearches;
    [self.tableView reloadData];
}

@end
