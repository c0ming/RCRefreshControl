### RCRefreshControl

Simple Refresh Control Framework.

### Usage

* Use Just Like A UIRefreshControl

```
RCRefreshControl *refreshControl = [[RCRefreshControl alloc] init];
[self.tableView addSubview:refreshControl];
```

* RCRefreshControlDelegate

```
- (CGFloat)heightOfRefreshControl:(RCRefreshControl *)refreshControl;

- (void)refreshControlDidBeginPulling:(RCRefreshControl *)refreshControl;
- (void)refreshControlDidEndPulling:(RCRefreshControl *)refreshControl;

- (void)refreshControlDidBeginRefreshing:(RCRefreshControl *)refreshControl;
- (void)refreshControlDidEndRefreshing:(RCRefreshControl *)refreshControl;

- (void)refreshControl:(RCRefreshControl *)refreshControl pullingProgress:(CGFloat)progress;
```
### Installation
Just add RCRefreshControl.h/m files to your Project,

or use [CocoaPods](https://cocoapods.org).
```
pod 'RCRefreshControl', '0.0.1'
```

### License
[The MIT License (MIT)](./LICENSE)
