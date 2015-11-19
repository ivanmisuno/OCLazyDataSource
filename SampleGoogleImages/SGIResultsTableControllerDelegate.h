//
//  SGIResultsTableControllerDelegate.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGIResultsTableController, SGISearchItem;

@protocol SGIResultsTableControllerDelegate <NSObject>

- (void)resultsTableController:(SGIResultsTableController *)resultsTableController
               didSelectSearch:(SGISearchItem *)searchItem;

@end
