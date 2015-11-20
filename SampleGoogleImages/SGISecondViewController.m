//
//  SGISecondViewController.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGISecondViewController.h"
#import "AppDelegate.h"

@interface SGISecondViewController ()

@property (nonatomic) IBOutlet UISwitch * safeContent;

@end

@implementation SGISecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Settings", nil);

    [self.safeContent addTarget:self action:@selector(safeContentChanged:) forControlEvents:UIControlEventValueChanged];
    self.safeContent.on = [AppDelegate sharedDelegate].safeSearchesOnly;
}

- (void)safeContentChanged:(id)sender
{
    [AppDelegate sharedDelegate].safeSearchesOnly = self.safeContent.on;
}

@end
