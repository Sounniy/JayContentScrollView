//
//  YJFPSMonitor.h
//  YJNavigationBar
//
//  Created by liuyingjie on 2017/8/15.
//  Copyright © 2017年 liuyingjieyeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YJFPSMonitor;

@protocol YJFPSMonitorDelegate <NSObject>

- (void)FPSMoitor:(YJFPSMonitor *)FPSMoitor didUpdateFPS:(float)fps;

@end



@interface YJFPSMonitor : NSObject

@property (nonatomic, weak) id<YJFPSMonitorDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval updateFPSInterval; // default 1.0s

- (void)start;

- (void)stop;

@end
