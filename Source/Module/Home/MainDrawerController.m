//
//  MainDrawerController.m
//  rehab
//
//  Created by herson on 2016/11/23.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "MainDrawerController.h"

#define DECLARE_STYLE -(BOOL)shouldAutorotate {\
return YES;\
}\
\
-(UIInterfaceOrientationMask)supportedInterfaceOrientations {\
return UIInterfaceOrientationMaskPortrait;\
}\
\
-(UIStatusBarStyle)preferredStatusBarStyle {\
return UIStatusBarStyleDefault;\
}\

@interface MainDrawerController ()

@end

@implementation MainDrawerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

DECLARE_STYLE

@end
