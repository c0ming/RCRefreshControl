//
//  RCRefreshControl.m
//  RCRefreshControlDemo
//
//  Created by c0ming on 10/28/15.
//  Copyright © 2015 c0ming. All rights reserved.
//

#import "RCRefreshControl.h"


#define KS_REFRESH_CONTROL_HEIGHT 48.0f
#define KS_REFRESH_MIN_OFFSET 48.0f

@interface RCRefreshControl ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, readwrite, getter = isRefreshing) BOOL refreshing;
@property (nonatomic, assign) BOOL didBeginPulling;
@property (nonatomic, assign) BOOL shouldRefresh;

@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) CGFloat refreshControlHeight;

@end

@implementation RCRefreshControl

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0.0f, -KS_REFRESH_CONTROL_HEIGHT, CGRectGetWidth([UIScreen mainScreen].bounds), KS_REFRESH_CONTROL_HEIGHT)];
    if (self) {
        _refreshControlHeight = KS_REFRESH_CONTROL_HEIGHT;
        
        self.autoresizingMask  = UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)self.superview;
        [self.scrollView.panGestureRecognizer addTarget:self action:@selector(panGestureHandler:)];
        
        [self setup];
    }
}

- (void)layoutSubviews {
    if (self.scrollView.isTracking) {
        self.shouldRefresh = NO;
        
        self.scrollView.scrollEnabled = NO;
        self.scrollView.scrollEnabled = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(heightOfRefreshControl:)]) {
        CGFloat height = [self.delegate heightOfRefreshControl:self];
        
        if (fabs(self.refreshControlHeight - height) > 1E-6) {
            CGRect frame = self.frame;
            frame.size.height = height;
            frame.origin.y = -height;
            self.frame = frame;
            
            self.refreshControlHeight = height;
        }
    }
    
    [super layoutSubviews];
}

#pragma mark - Setup

- (void)setup {
}


#pragma mark -

- (void)beginRefreshing {
    if (self.refreshing == NO) {
        self.refreshing = YES;
        
        if ([self.delegate respondsToSelector:@selector(refreshControlDidBeginRefreshing:)]) {
            [self.delegate refreshControlDidBeginRefreshing:self];
        }
        
        [UIView animateWithDuration:0.25f animations: ^{
            self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top + KS_REFRESH_CONTROL_HEIGHT, 0, self.scrollView.contentInset.bottom, 0);
        } completion:nil];
    }
}

- (void)endRefreshing {
    if (self.refreshing == YES) {
        self.refreshing = NO;
        
        [UIView animateWithDuration:0.25f animations: ^{
            self.scrollView.contentInset =  UIEdgeInsetsMake(self.scrollView.contentInset.top - KS_REFRESH_CONTROL_HEIGHT, 0, self.scrollView.contentInset.bottom, 0);
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
                    CGFloat progress = offset / KS_REFRESH_MIN_OFFSET;
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
                
                if (offset > KS_REFRESH_MIN_OFFSET && self.shouldRefresh) {
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

#pragma mark -

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
}

@end

