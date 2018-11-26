//
//  YJFPSLabel.m
//  YJNavigationBar
//
//  Created by liuyingjie on 2017/8/15.
//  Copyright © 2017年 liuyingjieyeah. All rights reserved.
//

#import "YJFPSLabel.h"
#import "YJFPSMonitor.h"

@interface YJFPSLabel ()<YJFPSMonitorDelegate>

@property (nonatomic, strong) YJFPSMonitor *fpsMonitor;

@end

@implementation YJFPSLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.font=[UIFont boldSystemFontOfSize:12];
        self.textColor=[UIColor colorWithRed:203/255.0 green:66/255.0 blue:59/255.0 alpha:1.0];
        [self addFPSMonitor];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationDidBecomeActiveNotification)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationWillResignActiveNotification)
                                                     name: UIApplicationWillResignActiveNotification
                                                   object: nil];
    }
    return self;
}

- (void)addFPSMonitor {
    YJFPSMonitor *fpsMonitor = [[YJFPSMonitor alloc]init];
    fpsMonitor.delegate = self;
    _fpsMonitor = fpsMonitor;
}

#pragma mark - public

- (void)start {
    [_fpsMonitor start];
}

- (void)stop {
    [_fpsMonitor stop];
    self.text = nil;
}

+ (void)showInStutasBar {
    YJFPSLabel *label = [[YJFPSLabel alloc]initWithFrame:CGRectMake(([self correctWindowWidth])/2+30, 0, 50, 20)];
    label.layer.zPosition = 1000;
    [[self mainWindow].rootViewController.view addSubview:label];
    [label start];
}

+ (void)hide {
    for (UIView *subView in [self mainWindow].rootViewController.view.subviews) {
        if ([subView isKindOfClass:[YJFPSLabel class]]) {
            YJFPSLabel *label = (YJFPSLabel *)subView;
            [label stop];
            [label removeFromSuperview];
        }
    }
}

#pragma mark - private

+ (CGFloat)correctWindowWidth {
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        default:
            return MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }
}

+ (UIWindow *)mainWindow {
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]) {
        return [app.delegate window];
    } else {
        return [app keyWindow];
    }
}

#pragma mark - TYFPSMonitorDelegate

- (void)FPSMoitor:(YJFPSMonitor *)FPSMoitor didUpdateFPS:(float)fps {
    self.text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
}

#pragma mark - Notification

- (void)applicationDidBecomeActiveNotification {
    [_fpsMonitor start];
}

- (void)applicationWillResignActiveNotification {
    [_fpsMonitor stop];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_fpsMonitor stop];
}

@end
