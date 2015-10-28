//
//  TableViewController.m
//  RCRefreshControlDemo
//
//  Created by c0ming on 10/28/15.
//  Copyright © 2015 c0ming. All rights reserved.
//

#import "TableViewController.h"

#import "RCRefreshControl.h"
#import "SampleView.h"

static NSString *identifier = @"Cell";

@interface TableViewController () <RCRefreshControlDelegate>

@property (nonatomic, strong) RCRefreshControl *refreshControl2;
@property (nonatomic, strong) SampleView *sampleView;

@end

@implementation TableViewController

#pragma mark - Actions

- (IBAction)stopAction:(UIBarButtonItem *)sender {
    [self.refreshControl2 endRefreshing];
}

#pragma mark - Setup

- (void)setup {
    self.refreshControl2 = [[RCRefreshControl alloc] init];
    self.refreshControl2.delegate = self;
    self.refreshControl2.backgroundColor = [UIColor redColor];
    [self.tableView addSubview:self.refreshControl2];
    
    self.sampleView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SampleView class]) owner:self options:nil] firstObject];
    [self.refreshControl2 addSubview:self.sampleView];
    self.sampleView.frame = self.refreshControl2.bounds; // or use Auto Layout
}


#pragma mark - 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
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
    
    self.sampleView.titleLabel.hidden = YES;
    [self.sampleView.activityIndicator startAnimating];
}

- (void)refreshControlDidEndRefreshing:(RCRefreshControl *)refreshControl {
    NSLog(@"%s", __func__);
    
    self.sampleView.titleLabel.hidden = NO;
    [self.sampleView.activityIndicator stopAnimating];
}

- (void)refreshControl:(RCRefreshControl *)refreshControl pullingProgress:(CGFloat)progress {
    NSLog(@">>> %.02f", progress);
    
    if (progress < 1.0f) {
        self.sampleView.titleLabel.text = @"Pull Down to Refresh";
    } else {
        self.sampleView.titleLabel.text = @"Release to Update";
    }
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
