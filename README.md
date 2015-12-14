# OCLazyDataSource

## Purpose

To create an easy-to-use replacement for writing boilerplate code implementing UITableViewDataSource/Delegate protocols.

## Idea

Represent table data source as a sequence of pairs (model, cellFactory).

Sequences are lazy by nature (cells are not evaluated each time sequence is iterated over), and are easily composable. Currently the project adds dependency on [NSEnumeratorLinq](https://github.com/k06a/NSEnumeratorLinq), but that could easily be removed by implementing necessary sequence operations.

## Example

Create sample data:
```objc
// Objective-C
NSArray *section1data = @[@{@"title":@"FBI searches lake in San Bernardino terrorism probe",
                            @"subtitle":@"An FBI dive team on Thursday searches...",
                            @"source":@"Los Angeles Times - ‎1 hour ago‎",
                            @"thumbnail":@"http://www.trbimg.com/img-566af767/turbine/la-2446945-me-1211-sb-folo-2-002-ls-jpg-20151210/750/750x422"},
                            //...
                            ];
NSArray *section2data = @[@"Show more articles...",
                          @"Subscribe to not miss important updates!"];
```

### Basic setup, default fixed-height cells:
```objc
// Objective-C
// define data source property on a view controller class
@property (nonatomic, readonly) OCLazyTableViewDataSource *dataSource;

// ...
// - (void)viewDidLoad
_dataSource = [[OCLazyTableViewDataSource alloc] init];
self.tableView.dataSource = self.dataSource.bridgeDataSource;
self.tableView.delegate = self.dataSource.bridgeDataSource;
// ...

id<OCLazyTableViewCellFactory> cellFactory1 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleSubtitle, @"SimpleCell1");
cellFactory1.configureBlock = ^(UITableViewCell * _Nonnull cell, NSDictionary * _Nonnull model, UITableView * _Nonnull tableView) {
	cell.textLabel.text = model[@"title"];
	cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:1];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
	cell.detailTextLabel.text = model[@"subtitle"];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
};
id<OCLazyDataSourceSection> section1 = lazyDataSourceSectionWithEnumerable(section1data, cellFactory1);

id<OCLazyTableViewCellFactory> cellFactory2 = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"SimpleCell2");
cellFactory2.configureBlock = ^(UITableViewCell * _Nonnull cell, NSString * _Nonnull model, UITableView * _Nonnull tableView) {
	cell.textLabel.text = model;
	cell.textLabel.textColor = [UIColor blueColor];
	cell.textLabel.font = [UIFont systemFontOfSize:12];
};
id<OCLazyDataSourceSection> section2 = lazyDataSourceSectionWithEnumerable(section2data, cellFactory2);

// an array (or any enumerable collection) of sections
NSArray *sections = @[section1, section2];
[self.dataSource setSource:sections];
```
[Preview](https://drive.google.com/file/d/0B7S7eiBvB1zXd2I1ZV9taDF0SDg/preview)

### Self-sizing cells

It’s easy to start using autolayout-based self-sizing cells from NIBs:
```objc
// Objective-C
UINib *cell1nib = [UINib nibWithNibName:@"OCSampleNewsCell" bundle:nil];
id<OCLazyTableViewCellFactory> cellFactory1 = lazyTableViewCellFactoryWithNib(cell1nib, @"OCSampleNewsCell");
cellFactory1.configureBlock = ^(UITableViewCell * _Nonnull cell, NSDictionary * _Nonnull model, UITableView * _Nonnull tableView) {
	OCSampleNewsCell *sampleNewsCell = (OCSampleNewsCell *)cell;
	// cell configuration is a bit boilerplate, but is easily abstracted away with SSVs, for example
	sampleNewsCell.titleLabel.text = model[@"title"];
	sampleNewsCell.sourceLabel.text = model[@"source"];
	sampleNewsCell.contentLabel.text = model[@"subtitle"];
	[sampleNewsCell.thumbnail setImageWithURL:[NSURL URLWithString:model[@"thumbnail"]]];
};
```
[Preview](https://drive.google.com/file/d/0B7S7eiBvB1zXTnhDSWcyZmFHVUU/preview)

### Now let's compose something more fancy

Let’s say we want to add a banner just in the middle of our main section.
Create model, cell factory and table section source as usual:
```objc
// Objective-C
NSArray *bannerData = @[@"Banner 1"];
id<OCLazyTableViewCellFactory> bannerCellFactory = lazyTableViewCellFactoryWithStyle(UITableViewCellStyleDefault, @"BannerCell");
bannerCellFactory.configureBlock = ^(UITableViewCell * _Nonnull cell, NSString * _Nonnull model, UITableView * _Nonnull tableView) {
	cell.backgroundColor = [UIColor blueColor];
	cell.textLabel.text = model;
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
};
id<OCLazyDataSourceSection> bannerSection = lazyDataSourceSectionWithEnumerable(bannerData, bannerCellFactory);
```

...then, compose the dataset:

```objc
// Objective-C
NSEnumerator * (^firstSectionEnumerator)() = ^ { return [section1.enumerator asNSEnumerator]; };
NSEnumerator * (^secondSectionEnumerator)() = ^ { return [section2.enumerator asNSEnumerator]; };
NSEnumerator * (^bannerSectionEnumerator)() = ^ { return [bannerSection.enumerator asNSEnumerator]; };

id<OCLazyDataSourceEnumerator> (^finalSectionEnumerator)() = ^ {
    NSEnumerator *enumerator =
    [[[[firstSectionEnumerator() take:2] // ...by taking first 2 elements from the first section,
       concat:bannerSectionEnumerator()] // appending the banner,
       concat:[firstSectionEnumerator() skip:2]] // appending the rest of our initial 1st section,
       concat:secondSectionEnumerator()]; // and finishing with our second section.
       return lazyDataSourceEnumeratorWithNSEnumerator(enumerator);
};

// we’ve got enough to display our table:
[self.dataSource setSource:lazyDataSourceEnumerableWithGeneratorBlock(finalSectionEnumerator) forTableView:self.tableView];
```
[Preview](https://drive.google.com/file/d/0B7S7eiBvB1zXaW9xc0Zjc3B3aTg/preview)

NO INDEX PATH TRANSFORMATIONS, NO SUBCLASSING, NO BOILERPLATE UITableViewDelegate code.  
JUST COMPOSITION.

### More composition

Finally, let’s show the last cell from the second section (“Subscribe to…” cell) between 4th and 5th elements of our initial data stream:

```objc
// Objective-C
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

[self.dataSource setSource:lazyDataSourceEnumerableWithGeneratorBlock(finalSectionEnumerator) forTableView:self.tableView];
```
[Preview](https://drive.google.com/file/d/0B7S7eiBvB1zXZUs2VjZyeVNpY0U/preview)


## Disclaimer

This is the first draft release and is subject to breaking changes.

## TODO

* Implement variable-height support on iOS7 (by implementing custom cell height measurement callbacks, OR by just assuming cell's view is set up correctly using autolayout constraints, and measuring it internally)
* Add user-interaction callbacks
* Add support for cells editing/reordering
* Add support for UICollectionViewDataSource/Delegate

## Copyright and contributing

You are free to use it.
Please feel free to propose any changes and/or ideas.
