//
//  AppDelegate.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGIImageSearchManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly) SGIImageSearchManager *searchManager;

+ (AppDelegate *)sharedDelegate;

@end

