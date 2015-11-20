//
//  SGIImageResultCell.m
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 20-11-2015.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIImageResultCell.h"
#import "SGIImageSearchResultItem.h"
#import "AppDelegate.h"
#import "SGIImageSearchManager.h"

@interface SGIImageResultCell()
@property (nonatomic) SGIImageSearchResultItem *imageResult;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) NSURLSessionTask *request;
@end

@implementation SGIImageResultCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];

        NSDictionary *views = @{@"imageView":self.imageView};
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (void)displayImage:(SGIImageSearchResultItem *)imageResult
{
    self.imageResult = imageResult;

    @weakify(self);
    self.request = [[AppDelegate sharedDelegate].searchManager getImageWithURL:[NSURL URLWithString:self.imageResult.thumbnailURL] callback:^(UIImage *image, NSError *error) {
        // we're on mainthrtead again
        @strongify(self);
        if (image)
        {
            self.imageView.image = image;
        }
        self.request = nil;
    }];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageResult = nil;
    self.imageView.image = nil;
    [self.request cancel];
    self.request = nil;
}

@end
