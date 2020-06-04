//
//  WRBannerViewController.h
//  rehab
//
//  Created by Matech on 4/25/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

typedef void(^AlphaBlock)(CGFloat alpha);

@interface WRBannerViewController : WRViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, assign) CGFloat topContentInset;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic, copy) AlphaBlock alphaBlock;
@property (nonatomic) BOOL shouldBounce;

-(UIImage*)bannerPlaceHolderImage;
@end
