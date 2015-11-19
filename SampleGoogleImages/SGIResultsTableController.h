//
//  SGIResultsTableController.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGISearchItem;
@protocol SGIResultsTableControllerDelegate;

@interface SGIResultsTableController : UITableViewController

@property (nonatomic, weak) id<SGIResultsTableControllerDelegate> searchDelegate;

- (void)setFilteredSearches:(NSArray<SGISearchItem *> *)filteredSearches
            forSearchString:(NSString *)searchString;

@end
