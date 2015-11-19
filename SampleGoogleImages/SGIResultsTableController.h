//
//  SGIResultsTableController.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGISearchItem;

@interface SGIResultsTableController : UITableViewController

- (void)setFilteredSearches:(NSArray<SGISearchItem *> *)filteredSearches
            forSearchString:(NSString *)searchString;

@end
