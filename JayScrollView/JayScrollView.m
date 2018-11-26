//
//  JayScrollView.m
//  JayScrollView
//
//  Created by qinjiandong on 2018/10/11.
//  Copyright © 2018年 qinjiandong. All rights reserved.
//

#import "JayScrollView.h"
@interface JayScrollView ()<UIScrollViewDelegate>
@property (nonatomic ,strong)UIView *contentView;
@property (nonatomic ,strong)NSMutableArray *itemsArray;
@property (nonatomic, assign)CGFloat preContentOffSetX;
@property (nonatomic, assign)NSInteger curentIndex;


@property (nonatomic ,assign)NSInteger dataSourcesCount;

@property (nonatomic ,strong)UIView *leftView;
@property (nonatomic ,strong)UIView *centerView;
@property (nonatomic ,strong)UIView *rightView;

@property (nonatomic ,strong)NSTimer *countTimer;
@end
@implementation JayScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.directionalLockEnabled = YES;
        self.bounces = NO;
        self.curentIndex = 0;
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame) *3, CGRectGetHeight(frame))];
        [self addSubview:contentView];
        self.contentSize = contentView.frame.size;
        self.contentView = contentView;
        self.delegate = self;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0*CGRectGetWidth(frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self.contentView addSubview:leftView];;
        self.leftView = leftView;
        UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(1*CGRectGetWidth(frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self.contentView addSubview:centerView];
        self.centerView = centerView;
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(2*CGRectGetWidth(frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self.contentView addSubview:rightView];
        self.rightView = rightView;
        self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
        self.preContentOffSetX = CGRectGetWidth(self.frame);
        self.itemsArray = [NSMutableArray arrayWithArray:@[self.leftView,self.centerView,self.rightView]];
        self.countTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(circleAction) userInfo:nil repeats:YES];

        [[NSRunLoop currentRunLoop] addTimer:self.countTimer forMode:NSDefaultRunLoopMode];
//        NSTimer *countTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(circleAction) userInfo:nil repeats:YES]; //初始化一个5分钟执行一次的计时器]
        
    }
    return self;
}
- (void)circleAction{
    [self setContentOffset:CGPointMake(2 * CGRectGetWidth(self.frame), 0) animated:YES];
    [self scrollViewRefreshSubviews];

}
- (void)refreshData{
    
    if (self.dataSources && [self.dataSources respondsToSelector:@selector(numberOfItemsInScrollView:)]) {
        NSInteger dataCount = [self.dataSources numberOfItemsInScrollView:self];
        if (dataCount <= 0) {
            return;
        }
        
        self.dataSourcesCount = dataCount;
        if (self.dataSources && [self.dataSources respondsToSelector:@selector(scrollView:itemForIndex:items:)]) {

            NSInteger leftIndex = self.dataSourcesCount-1;
            NSInteger rightIndex = 0 < (self.dataSourcesCount-1) ? (self.curentIndex+1) : 0;
            UIView *centerItemView = [self.dataSources scrollView:self itemForIndex:0 items:nil];
            centerItemView.frame = self.leftView.bounds;
            [self.centerView addSubview:centerItemView];
            UIView *leftItemView = [self.dataSources scrollView:self itemForIndex:leftIndex items:nil];
            leftItemView.frame = self.centerView.bounds;
            [self.leftView addSubview:leftItemView];
            UIView* rightItemView = [self.dataSources scrollView:self itemForIndex:rightIndex items:nil];
            rightItemView.frame = self.rightView.bounds;
            [self.rightView addSubview:rightItemView];

            self.curentIndex = 1;
        
    
        }
    }
    
   
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    if (self.preContentOffSetX == self.contentOffset.x) {
        return;
    }
    [self scrollViewRefreshSubviews];

 
}
- (void)scrollViewRefreshSubviews{
    
    NSInteger leftIndex = self.curentIndex > 0 ? (self.curentIndex-1) : (self.dataSourcesCount-1);
    NSInteger rightIndex = (self.curentIndex < (self.dataSourcesCount-1)) ? (self.curentIndex+1) : 0;
    NSInteger tempIndex = rightIndex;

    if (self.preContentOffSetX < self.contentOffset.x) {
        tempIndex = leftIndex;
    }

    if(self.preContentOffSetX > self.contentOffset.x){
        
        self.curentIndex = ((self.curentIndex - 1) < 0) ? (self.dataSourcesCount-1):(self.curentIndex - 1);
        
        UIView *lastView = [self.itemsArray lastObject];
        [self.itemsArray removeObjectAtIndex:2];
        [self.itemsArray insertObject:lastView atIndex:0];
        [self chageViewWithSuperView:lastView index:leftIndex];

    }else{
        self.curentIndex = ((self.curentIndex + 1) > self.dataSourcesCount-1) ? 0 :(self.curentIndex + 1) ;
      
        UIView *firstView = [self.itemsArray firstObject];
        [self.itemsArray removeObjectAtIndex:0];
        [self.itemsArray addObject:firstView];
        [self chageViewWithSuperView:firstView index:rightIndex];

        
    }
    [self reLoadViewsFrame];
    self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);

}
- (void)reLoadViewsFrame{
    
    for (int i = 0; i < 3; i++) {
        UIView *tempView = self.itemsArray[i];
        tempView.frame = CGRectMake(i*CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }
}

- (void)chageViewWithSuperView:(UIView *)superView index:(NSInteger)tempIndex{
    
    UIView *subView = nil;
    NSArray *subViewsArr = [superView subviews];
    if (subViewsArr && [subViewsArr count] == 1) {
        subView = [subViewsArr firstObject];
    }else{
        if ([subViewsArr count] > 1) {
            for(UIView *view in subViewsArr)
            {
                [view removeFromSuperview];
            }
        }
    }
    
    if (self.dataSources && [self.dataSources respondsToSelector:@selector(scrollView:itemForIndex:items:)]) {
        UIView *itemView = [self.dataSources scrollView:self itemForIndex:tempIndex items:subView];
        if (![itemView isEqual:subView]) {
            [subView removeFromSuperview];
            itemView.frame = superView.bounds;
            [superView addSubview:itemView];
        }
    }
    
}
-(void)dealloc{
    
    [self.countTimer invalidate];
    self.countTimer = nil;
    
}
 
 
 

@end
