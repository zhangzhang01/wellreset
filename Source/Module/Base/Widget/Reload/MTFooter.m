//
//  MTFooter.m
//  oa
//
//  Created by yefangyang on 16/5/17.
//  Copyright © 2016年 yefangyang. All rights reserved.
//

#import "MTFooter.h"

@implementation MTFooter

- (void)prepare
{
    [super prepare];
    self.stateLabel.textColor = [UIColor blackColor];
    [self setTitle:@"" forState:MJRefreshStateIdle];
    [self setTitle:@"正在加载更多" forState:MJRefreshStateRefreshing];
    [self setTitle:@"我也是有底线的..." forState:MJRefreshStateNoMoreData];
}
@end
