### RCRefreshControl

Simple Refresh Control.

### Usage

##### Use Like A UIRefreshControl:

```
RCRefreshControl *refreshControl = [[RCRefreshControl alloc] init];
[self.tableView addSubview:refreshControl];
```

##### RCRefreshControlDelegate:
```
- (CGFloat)heightOfRefreshControl:(RCRefreshControl *)refreshControl;

- (void)refreshControlDidBeginPulling:(RCRefreshControl *)refreshControl;
- (void)refreshControlDidEndPulling:(RCRefreshControl *)refreshControl;

- (void)refreshControlDidBeginRefreshing:(RCRefreshControl *)refreshControl;
- (void)refreshControlDidEndRefreshing:(RCRefreshControl *)refreshControl;

- (void)refreshControl:(RCRefreshControl *)refreshControl pullingProgress:(CGFloat)progress;
```
