//
//  ViewController.m
//  JayScrollView
//
//  Created by qinjiandong on 2018/10/11.
//  Copyright © 2018年 qinjiandong. All rights reserved.
//

#import "ViewController.h"
#import "JayScrollView.h"

@interface ViewController ()<JayScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JayScrollView *scrollView = [[JayScrollView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 150)];
    scrollView.dataSources = self;
    [self.view addSubview:scrollView];
    [scrollView refreshData];

//    [scrollView refreshDataSoruces:@[[UIColor redColor],[UIColor blueColor],[UIColor yellowColor]]];
    // Do any additional setup after loading the view, typically from a nib.
}


- (UIView *)scrollView:(JayScrollView *)scrollView itemForIndex:(NSUInteger)index items:(UIView *)preItem{
    UIView *testView = [UIView new];
    NSLog(@"======%ld",index);
    if (index == 0) {
        testView.backgroundColor = [UIColor blackColor];
    }else if(index == 1)
    {
        testView.backgroundColor = [UIColor greenColor];
    }else if(index == 2)
    {
        testView.backgroundColor = [UIColor yellowColor];
    }
    else{
        testView.backgroundColor = [UIColor brownColor];

    }

    
    return testView;
    
}

- (NSInteger)numberOfItemsInScrollView:(JayScrollView *)scrollView{
    
    return 3;
}


@end
