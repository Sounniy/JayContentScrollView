//
//  JayScrollView.h
//  JayScrollView
//
//  Created by qinjiandong on 2018/10/11.
//  Copyright © 2018年 qinjiandong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JayScrollView;
@protocol JayScrollViewDelegate <NSObject>

@required
- (UIView *)scrollView:(JayScrollView *)scrollView itemForIndex:(NSUInteger)index items:(UIView *)preItem;

- (NSInteger)numberOfItemsInScrollView:(JayScrollView *)scrollView;

@end
@interface JayScrollView : UIScrollView

@property (nonatomic,weak)id<JayScrollViewDelegate> dataSources;

- (void)refreshData;

@end
