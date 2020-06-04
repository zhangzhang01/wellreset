//
//  RehabUsersCloundController.m
//  rehab
//
//  Created by yefangyang on 2016/10/9.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "RehabUsersCloundController.h"
#import "DBSphereView.h"

#import <YYKit/YYKit.h>
@interface RehabUsersCloundController ()

@end

@implementation RehabUsersCloundController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createBackBarButtonItem];
}

- (instancetype)initWithIconArray:(NSArray *)iconArray
{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        BOOL biPad = [WRUIConfig IsHDApp];
        
        CGFloat imageSize;
        if (biPad) {
            imageSize = 100;
        } else if ([UIScreen mainScreen].scale >= 3.0){
            imageSize = 80;
        } else {
            imageSize = 60;
        }
        NSMutableArray *buttonArray = [NSMutableArray array];
        DBSphereView *view = [[DBSphereView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width)/2, self.view.bounds.size.width, self.view.bounds.size.width)];
        for (int i = 0; i < iconArray.count; i++) {
            WRUserInfo* userInfo = iconArray[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.cornerRadius = imageSize/2;
            button.clipsToBounds = YES;
            button.frame = CGRectMake(0, 0, imageSize, imageSize);
            [button setImageWithURL:[NSURL URLWithString:userInfo.headImageUrl] forState:UIControlStateNormal placeholder:[WRUIConfig defaultHeadImage]];
            [buttonArray addObject:button];
            [view addSubview:button];
        }

        [view setCloudTags:buttonArray];
        [self.view addSubview:view];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    UIImage *image = [[WRUIConfig defaultNavImage] imageByResizeToSize:CGSizeMake(bar.width, 1)];
//    [bar setShadowImage:image];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.navigationController.navigationBar lt_reset];
//     self.navigationController.navigationBar.barTintColor = [UINavigationBar appearance].barTintColor;
//     self.navigationController.navigationBar.tintColor = [UINavigationBar appearance].tintColor;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
