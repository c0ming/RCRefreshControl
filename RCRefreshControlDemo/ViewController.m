//
//  ViewController.m
//  RCRefreshControlDemo
//
//  Created by c0ming on 10/28/15.
//  Copyright © 2015 c0ming. All rights reserved.
//

#import "ViewController.h"

#import "RCRefreshControl.h"

@interface ViewController () <RCRefreshControlDelegate>

//@property (nonatomic, strong) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) RCRefreshControl *refreshControl;

@end

@implementation ViewController

#pragma mark - Actions

- (IBAction)stopAction:(UIBarButtonItem *)sender {
    [self.refreshControl endRefreshing];
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.scrollView.alwaysBounceVertical = YES;
//    self.scrollView.autoresizingMask = 63;
//    [self.view addSubview:self.scrollView];
    
    self.refreshControl = [[RCRefreshControl alloc] init];
    self.refreshControl.delegate = self;
    self.refreshControl.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:self.refreshControl];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
