//
//  PreventVideosController.h
//  rehab
//
//  Created by herson on 2016/11/17.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@class WRScene;

@interface PreventVideosController : WRScrollViewController

@property (nonatomic, copy) NSString *category;

-(void)setScene:(WRScene*)scene banner:(UIImage*)bannerImage  mostColor:(UIColor*)mostColor;

@end
