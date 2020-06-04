//
//  BaseIndexController.h
//  rehab
//
//  Created by 何寻 on 6/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface BaseIndexController : WRScrollViewController
{
    __weak UIButton *_leftButton, *_rightButton;
    __weak UIScrollView* _bannerScrollView;
    __weak UILabel* _bannerDetailLabel, *_bannerTitleLabel;
    __weak UIPageControl* _bannerPageCtrl;
    
    NSTimer* _bannerScrollTimer;
    
    NSArray *_bannerInfoArray;
}

-(void)updateBannerInfo;
-(void)scrollToNextPage:(id)sender;
-(void)layout;

#pragma mark - Override
-(CGFloat)layoutOtherViews:(CGFloat)y;
-(NSString *)getBannerImageUrlString:(id)item;
-(void)showBannerInfo:(NSUInteger)index;
-(void)actionOnItem:(NSArray*)data index:(NSUInteger)index;
@end
