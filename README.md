# OCLazyDataSource

## Purpose

To create an easy-to-use replacement for writing boilerplate code implementing UITableViewDataSource/Delegate protocols.

## Idea

Represent table data source as a sequence of pairs (model, cellFactory).

Sequences are lazy by nature (cells are not evaluated each time sequence is iterated over), and easily composable. Currently the project adds dependency on [NSEnumeratorLinq](https://github.com/k06a/NSEnumeratorLinq), but that could easily be removed by implementing necessary sequence operations.

## Example



## Disclaimer

This is first draft release and is subject to breaking changes.

## TODO

* Implement variable-height support on iOS7 (by implementing custom cell height measurement callbacks, OR by just assuming cell's view is set up correctly using autolayout constraints, and measuring it internally)
* Add user-interaction callbacks
* Add support for cells editing/reordering
* Add support for UICollectionViewDataSource/Delegate

## Copyright and contributing

You are free to use it.
Please feel free to propose any 
