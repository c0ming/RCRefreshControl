//
//  RCRefreshControl.m
//  RCRefreshControlDemo
//
//  Created by c0ming on 10/28/15.
//  Copyright © 2015 c0ming. All rights reserved.
//

#import "RCRefreshControl.h"

#define RC_REFRESH_CONTROL_DEFAULT_HEIGHT 48.0f
#define RC_REFRESH_CONTROL_DEFAULT_PULLING_OFFSET 48.0f

@interface RCRefreshControl ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, readwrite, getter = isRefreshing) BOOL refreshing;
@property (nonatomic, assign) BOOL didBeginPulling;
@property (nonatomic, assign) BOOL shouldRefresh;

@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) CGFloat refreshControllHeight;
@property (nonatomic, assign) CGFloat refreshControllPullingOffset;

@end

@implementation RCRefreshControl

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)self.superview;
        [self.scrollView.panGestureRecognizer addTarget:self action:@selector(panGestureHandler:)];
        
        CGFloat refreshControlWidth = [RCRefreshControl _portraitScreenWidth];
        CGFloat refreshControlHeight = RC_REFRESH_CONTROL_DEFAULT_HEIGHT;
        if ([self.delegate respondsToSelector:@selector(heightOfRefreshControl:)]) {
            refreshControlHeight = [self.delegate heightOfRefreshControl:self];
        }
        
        CGFloat refreshControllPullingOffset = RC_REFRESH_CONTROL_DEFAULT_PULLING_OFFSET;
        if ([self.delegate respondsToSelector:@selector(pullingOffsetOfRefreshControl:)]) {
            refreshControllPullingOffset = [self.delegate pullingOffsetOfRefreshControl:self];
        }
        
        NSDictionary *views = NSDictionaryOfVariableBindings(self);
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%@)-[self(%@)]", @(-refreshControlHeight), @(refreshControlHeight)] options:0 metrics:nil views:views]];
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[self(%@)]", @(refreshControlWidth)] options:0 metrics:nil views:views]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        
        self.refreshControllHeight = refreshControlHeight;
        self.refreshControllPullingOffset = refreshControllPullingOffset;
    }
}

- (void)layoutSubviews {
    if (self.scrollView.isTracking) {
        self.shouldRefresh = NO;
        
        self.scrollView.scrollEnabled = NO;
        self.scrollView.scrollEnabled = YES;
    }
    
    [super layoutSubviews];
}

#pragma mark -

- (void)beginRefreshing {
    if (self.refreshing == NO) {
        self.refreshing = YES;
        
        if ([self.delegate respondsToSelector:@selector(refreshControlDidBeginRefreshing:)]) {
            [self.delegate refreshControlDidBeginRefreshing:self];
        }
        
        [UIView animateWithDuration:0.25f animations: ^{
            self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top + self.refreshControllHeight, 0, self.scrollView.contentInset.bottom, 0);
        } completion:nil];
    }
}

- (void)endRefreshing {
    if (self.refreshing == YES) {
        self.refreshing = NO;
        
        [UIView animateWithDuration:0.25f animations: ^{
            self.scrollView.contentInset =  UIEdgeInsetsMake(self.scrollView.contentInset.top - self.refreshControllHeight, 0, self.scrollView.contentInset.bottom, 0);
        }];
        
        if ([self.delegate respondsToSelector:@selector(refreshControlDidEndRefreshing:)]) {
            [self.delegate refreshControlDidEndRefreshing:self];
        }
    }
}

#pragma mark - Private Methods

- (void)panGestureHandler:(UIPanGestureRecognizer *)recognizer {
    if (!self.isRefreshing) {
        CGFloat contentOffsetY = self.scrollView.contentOffset.y;
        CGFloat contentInsetTop = self.scrollView.contentInset.top;
        CGFloat offset = -contentInsetTop - self.lastOffsetY;
        
        UIGestureRecognizerState state = recognizer.state;
        if (state == UIGestureRecognizerStateChanged) {
            if (offset > 0.0f) {
                if (!self.didBeginPulling) {
                    self.didBeginPulling = YES;
                    self.shouldRefresh = YES;
                    
                    if ([self.delegate respondsToSelector:@selector(refreshControlDidBeginPulling:)]) {
                        [self.delegate refreshControlDidBeginPulling:self];
                    }
                }
                
                if ([self.delegate respondsToSelector:@selector(refreshControl:pullingProgress:)]) {
                    CGFloat progress = offset / self.refreshControllPullingOffset;
                    if (progress < 0.0f) {
                        progress = 0.0f;
                    } else if (progress > 1.0f) {
                        progress = 1.0f;
                    }
                    
                    [self.delegate refreshControl:self pullingProgress:progress];
                }
            }
        } else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
            if (self.didBeginPulling) {
                self.didBeginPulling = NO;
                
                if (offset > self.refreshControllPullingOffset && self.shouldRefresh) {
                    [self beginRefreshing];
                }
                
                if ([self.delegate respondsToSelector:@selector(refreshControlDidEndPulling:)]) {
                    [self.delegate refreshControlDidEndPulling:self];
                }
            }
        }
        
        self.lastOffsetY = contentOffsetY;
    }
}

#pragma mark - Private Methods

+ (CGFloat)_portraitScreenWidth {
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? CGRectGetWidth([UIScreen mainScreen].bounds) : CGRectGetHeight([UIScreen mainScreen].bounds);
}

#pragma mark -

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
}

@end
