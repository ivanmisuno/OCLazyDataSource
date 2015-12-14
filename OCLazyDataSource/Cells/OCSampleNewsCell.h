//
//  OCSampleNewsCell.h
//
//  Created by Ivan Misuno on 11/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCSampleNewsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *thumbnail;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *sourceLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;

@end
