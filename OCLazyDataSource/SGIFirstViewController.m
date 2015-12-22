//
//  SGIFirstViewController.m
//
//  Created by Ivan Misuno on 18/11/15.
//  Copyright © 2015 Ivan Misuno. All rights reserved.
//

#import "SGIFirstViewController.h"
#import "OCLazyDataSource.h"
#import "OCSampleNewsCell.h"

@import AFNetworking;
@import NSEnumeratorLinq;


@interface SGIFirstViewController()
@property (nonatomic, readonly) id<OCLazyDataSource> dataSource;
@end

@implementation SGIFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"OCLazyDataSource", nil);

    id<OCLazyDataSourceBridge> tableBridge = lazyDataSourceBridgeForTableView(self.tableView);
    _dataSource = lazyDataSourceWithBridge(tableBridge);

    NSArray *section1data = @[@{@"title":@"FBI searches lake in San Bernardino terrorism probe; questions over what neighbors saw",
                                @"subtitle":@"An FBI dive team on Thursday searches for electronic devices or other evidence possibly left in Seccombe Lake, about two miles north of the Inland Regional Center in San Bernardino.",
                                @"source":@"Los Angeles Times - ‎1 hour ago‎",
                                @"thumbnail":@"http://www.trbimg.com/img-566af767/turbine/la-2446945-me-1211-sb-folo-2-002-ls-jpg-20151210/750/750x422"},
                              @{@"title":@"Former Oklahoma police officer found guilty of multiple rapes",
                                @"subtitle":@"A former Oklahoma City police officer has been convicted of sexually assaulting women he preyed upon in a low-income neighborhood he patrolled.",
                                @"source":@"USA TODAY - ‎4 hours ago‎",
                                @"thumbnail":@"http://images.csmonitor.com/csm/2015/12/953039_1_1211-tesla_standard.jpg?alias=standard_600x400"},
                              @{@"title":@"Ben Carson joins Donald Trump in threatening to leave GOP",
                                @"subtitle":@"Washington (CNN) Ben Carson on Friday took a page from Donald Trump's playbook by threatening to depart the Republican Party. Ahead of Tuesday's GOP presidential debate, the retired neurosurgeon slammed the party after reports emerged.",
                                @"source":@"‎CNN - ‎1 hour ago",
                                @"thumbnail":@"http://specials-images.forbesimg.com/imageserve/451257034/x.jpg"},
                              @{@"title":@"Dow, DuPont set $130 billion megamerger, could spark more deals",
                                @"subtitle":@"Chemical titans DuPont and Dow Chemical Co agreed to combine in an all-stock merger valued at $130 billion, a move that could trigger more consolidation, please activist investors and generate tax savings while drawing scrutiny from regulators.",
                                @"source":@"‎Reuters - ‎47 minutes ago‎",
                                @"thumbnail":@"http://www.gannett-cdn.com/-mm-/b9109ef5edecdaeff44e26a7bea6ab951eb60ddc/c=0-384-2445-2222&r=x404&c=534x401/local/-/media/2015/12/08/USATODAY/USATODAY/635851878471081028-Capitol-photo.jpg"},
                              @{@"title":@"Scientists See Catastrophe in Latest Draft of Climate Deal",
                                @"subtitle":@"LE BOURGET, France - Scientists who are closely monitoring the climate negotiations said on Friday that the emerging agreement, and the national pledges incorporated into it, are still far too weak to ensure that humanity will avoid dangerous levels.",
                                @"source":@"‎New York Times - ‎2 hours ago",
                                @"thumbnail":@"http://photos2.appleinsidercdn.com/gallery/15243-11396-jobs_02-l.jpg"},
                              ];
    NSArray *section2data = @[@"Show more articles...",
                              @"Subscribe to not miss important updates!"];
    NSArray *bannerData = @[@"Banner 1"];


    UINib *cell1nib = [UINib nibWithNibName:@"OCSampleNewsCell" bundle:nil];
    id<OCLazyTableViewCellFactory> cellFactory1 = lazyTableViewCellFactoryWithNib(cell1nib, @"OCSampleNewsCell");
    cellFactory1.configureBlock = ^(UITableViewCell * _Nonnull cell, NSDictionary * _Nonnull model, UITableView * _Nonnull tableView) {
        OCSampleNewsCell *sampleNewsCell = (OCSampleNewsCell *)cell;
        sampleNewsCell.titleLabel.text = model[@"title"];
        sampleNewsCell.sourceLabel.text = model[@"source"];
        sampleNewsCell.contentLabel.text = model[@"subtitle"];
        [sampleNewsCell.thumbnail setImageWithURL:[NSURL URLWithString:model[@"thumbnail"]]];
    };
    id<OCLazyDataSourceSection> section1 = lazyDataSourceSectionWithEnumerable(section1data, cellFactory1);

    id<OCLazyTableViewCellFactory> cellFactory2 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"SimpleCell2");
    cellFactory2.configureBlock = ^(UITableViewCell * _Nonnull cell, NSString * _Nonnull model, UITableView * _Nonnull tableView) {
        cell.textLabel.text = model;
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    };
    id<OCLazyDataSourceSection> section2 = lazyDataSourceSectionWithEnumerable(section2data, cellFactory2);

    id<OCLazyTableViewCellFactory> bannerCellFactory = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"BannerCell");
    bannerCellFactory.configureBlock = ^(UITableViewCell * _Nonnull cell, NSString * _Nonnull model, UITableView * _Nonnull tableView) {
        cell.backgroundColor = [UIColor blueColor];
        cell.textLabel.text = model;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    };
    id<OCLazyDataSourceSection> bannerSection = lazyDataSourceSectionWithEnumerable(bannerData, bannerCellFactory);

    NSEnumerator * (^firstSectionEnumerator)() = ^ { return [section1.enumerator asNSEnumerator]; };
    NSEnumerator * (^secondSectionEnumerator)() = ^ { return [section2.enumerator asNSEnumerator]; };
    NSEnumerator * (^bannerSectionEnumerator)() = ^ { return [bannerSection.enumerator asNSEnumerator]; };

//    id<OCLazyDataSourceEnumerator> (^finalSectionEnumerator)() = ^ {
//        NSEnumerator *enumerator =
//        [[[[firstSectionEnumerator() take:2]
//          concat:bannerSectionEnumerator()]
//         concat:[firstSectionEnumerator() skip:2]]
//         concat:secondSectionEnumerator()];
//         return lazyDataSourceEnumeratorWithNSEnumerator(enumerator);
//    };

    id<OCLazyDataSourceEnumerator> (^finalSectionEnumerator)() = ^ {
        NSEnumerator *enumerator =
        [[[[[[firstSectionEnumerator() take:2] // take 2 first elements from our initial data source
           concat:bannerSectionEnumerator()] // append a banner
          concat:[[firstSectionEnumerator() skip:2] take:2]] // take another 2
          concat:[[secondSectionEnumerator() skip:1] take:1]] // append second item from the second data source
          concat:[firstSectionEnumerator() skip:4]] // append the rest of our initial stream
         concat:[secondSectionEnumerator() take:1]]; // and, finally, append first item of the second stream
        return lazyDataSourceEnumeratorWithNSEnumerator(enumerator);
    };

    [self.dataSource setSource:lazyDataSourceEnumerableWithGeneratorBlock(finalSectionEnumerator)];
}

@end
