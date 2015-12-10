//
//  BCLazyTableViewHeaderFooterViewFactory.h
//  SampleGoogleImages
//
//  Created by Ivan Misuno on 09/12/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCLazyTableViewHeaderFooterViewFactory
- (void)registerWithTableView:(UITableView * _Nonnull)tableView;
- (UITableViewHeaderFooterView * _Nonnull)dequeueTableViewHeaderFooterView:(UITableView * _Nonnull)tableView;
@end

id<BCLazyTableViewHeaderFooterViewFactory> _Nonnull lazyTableViewHeaderFooterViewFactoryWithNib(UINib * _Nonnull nibForTableViewHeaderFooterView, NSString * _Nonnull reuseIdentifier);
id<BCLazyTableViewHeaderFooterViewFactory> _Nonnull lazyTableViewHeaderFooterViewFactoryWithClass(Class _Nonnull classForTableViewHeaderFooterView, NSString * _Nonnull reuseIdentifier);
