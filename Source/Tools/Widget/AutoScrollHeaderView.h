//
//  AutoScrollHeaderView.h
//  rehab
//
//  Created by herson on 8/16/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDChannelLabel.h"

@interface AutoScrollHeaderView : UIScrollView

@property(nonatomic, copy) void(^clickedEvent)(AutoScrollHeaderView *sender, NSInteger index);
@property(nonatomic) UIColor *textColor, *focusTextColor, *underLineColor;
-(instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color;
-(DDChannelLabel*)addChannel:(NSString*)text labelCount:(NSInteger)labelCount; 
-(void)syncWithScrollViewDidScroll:(UIScrollView *)scrollView;
-(void)syncWithScrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
-(void)scrollToIndex:(NSInteger)index needUpdate:(BOOL)needUpdate;


@end
