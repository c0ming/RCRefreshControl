//
//  TableViewController.m
//  RCRefreshControlDemo
//
//  Created by c0ming on 10/28/15.
//  Copyright © 2015 c0ming. All rights reserved.
//

#import "TableViewController.h"

#import "RCRefreshControl.h"

static NSString *identifier = @"Cell";

@interface TableViewController () <RCRefreshControlDelegate>

@property (nonatomic, strong) RCRefreshControl *refreshControl2;

@end

@implementation TableViewController

#pragma mark - Actions

- (IBAction)stopAction:(UIBarButtonItem *)sender {
    [self.refreshControl2 endRefreshing];
}

#pragma mark - 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl2 = [[RCRefreshControl alloc] init];
    self.refreshControl2.delegate = self;
    self.refreshControl2.backgroundColor = [UIColor redColor];
    [self.tableView addSubview:self.refreshControl2];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - RCRefreshControlDelegate

- (void)refreshControlDidBeginPulling:(RCRefreshControl *)refreshControl {
    NSLog(@"%s", __func__);
}

- (void)refreshControlDidEndPulling:(RCRefreshControl *)refreshControl {
    NSLog(@"%s", __func__);
}

- (void)refreshControlDidBeginRefreshing:(RCRefreshControl *)refreshControl {
    NSLog(@"%s", __func__);
}

- (void)refreshControlDidEndRefreshing:(RCRefreshControl *)refreshControl {
    NSLog(@"%s", __func__);
}

- (void)refreshControl:(RCRefreshControl *)refreshControl pullingProgress:(CGFloat)progress {
    NSLog(@">>> %.02f", progress);
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue destinationViewController].hidesBottomBarWhenPushed = YES;
}

-(void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
