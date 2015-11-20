//
//  SGIImageResultsViewController.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGISearchItem;

@interface SGIImageResultsViewController : UIViewController

- (void)showResultsForQuery:(SGISearchItem *)search;

@end
