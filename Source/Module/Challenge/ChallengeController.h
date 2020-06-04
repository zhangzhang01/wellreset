//
//  ChallengeController.h
//  rehab
//
//  Created by yefangyang on 2016/9/27.
//  Copyright © 2016年 WELL. All rights reserved.
//
//#import "WRBannerViewController.h"
#import "WRBaseViewController.h"
typedef void(^AlphaBlock)(CGFloat alpha);
@interface ChallengeController : WRViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, assign) CGFloat topContentInset;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic, copy) AlphaBlock alphaBlock;
@property (nonatomic) BOOL shouldBounce;

//-(UIImage*)bannerPlaceHolderImage;
-(void)fetchData;

@end






