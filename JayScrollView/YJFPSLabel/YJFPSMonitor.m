//
//  YJFPSMonitor.m
//  YJNavigationBar
//
//  Created by liuyingjie on 2017/8/15.
//  Copyright © 2017年 liuyingjieyeah. All rights reserved.
//

#import "YJFPSMonitor.h"
#import <UIKit/UIKit.h>

@interface YJFPSMonitor()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) NSTimeInterval lastUpdateTime;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL delegateFlag;

@end

@implementation YJFPSMonitor


- (instancetype)init {
    if (self = [super init]) {
        _lastUpdateTime = 0;
        _updateFPSInterval = 1.0;
    }
    return self;
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFpsAction:)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10) {
            _displayLink.preferredFramesPerSecond = 60;
        }else {
            //_displayLink.preferredFramesPerSecond = 1;
        }
    }
    return _displayLink;
}

- (void)setDelegate:(id<YJFPSMonitorDelegate>)delegate {
    _delegate = delegate;
    _delegateFlag = [delegate respondsToSelector:@selector(FPSMoitor:didUpdateFPS:)];
}


#pragma mark - public

- (void)start {
    if (_displayLink) {
        return;
    }
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stop {
    if (!_displayLink) {
        return;
    }
    [self.displayLink invalidate];
    _displayLink = nil;
}

#pragma mark - action

- (void)updateFpsAction:(CADisplayLink *)displayLink {
    if (_lastUpdateTime == 0) {
        _lastUpdateTime = displayLink.timestamp;
    }
    ++_count;
    NSTimeInterval interval = displayLink.timestamp - _lastUpdateTime;
    if (interval < _updateFPSInterval) {
        return;
    }
    _lastUpdateTime = displayLink.timestamp;
    float fps = _count/interval;
    _count = 0;
    if (_delegateFlag) {
        [_delegate FPSMoitor:self didUpdateFPS:fps];
    }
}

@end
