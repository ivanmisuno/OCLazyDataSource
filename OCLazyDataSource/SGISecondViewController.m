//
//  SGISecondViewController.m
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
}

@end
