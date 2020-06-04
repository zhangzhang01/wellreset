//
//  DDChannelCell.m
//  DDNews
//
//  Created by Dvel on 16/4/7.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import "DDChannelCell.h"

@implementation DDChannelCell

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
	}
	return self;
}

- (void)setViewContolller:(ArticleListController *)viewContolller
{
    if (_viewContolller) {
        [_viewContolller.view removeFromSuperview];
    }
    _viewContolller = viewContolller;
    _viewContolller.view.frame = self.bounds;
    [self addSubview:_viewContolller.view];
}

@end
