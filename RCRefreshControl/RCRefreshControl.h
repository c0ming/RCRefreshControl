//
//  RCRefreshControl.h
//  RCRefreshControlDemo
//
//  Created by c0ming on 10/28/15.
//  Copyright © 2015 c0ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCRefreshControl;


@class RCRefreshControl;

@protocol RCRefreshControlDelegate <NSObject>

@optional

- (CGFloat)heightOfRefreshControl:(RCRefreshControl *)refreshControl;

- (void)refreshControlDidBeginPulling:(RCRefreshControl *)refreshControl;
- (void)refreshControlDidEndPulling:(RCRefreshControl *)refreshControl;

- (void)refreshControlDidBeginRefreshing:(RCRefreshControl *)refreshControl;
- (void)refreshControlDidEndRefreshing:(RCRefreshControl *)refreshControl;

- (void)refreshControl:(RCRefreshControl *)refreshControl pullingProgress:(CGFloat)progress;

@end

@interface RCRefreshControl : UIView

- (instancetype)init;

@property (nonatomic, weak) id <RCRefreshControlDelegate> delegate;
@property (nonatomic, readonly, getter = isRefreshing) BOOL refreshing;

- (void)beginRefreshing;
- (void)endRefreshing;

@end
