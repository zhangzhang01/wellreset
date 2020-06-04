//
//  WRWireframe.m
//  rehab
//
//  Created by herson on 2016/11/16.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRWireframe.h"

#import "WRBaseViewController.h"

#import "PreventIndexController.h"

@implementation WRWireframe

+(void)presentPreventionIndexFromController:(UIViewController*)fromController
{
    PreventIndexController *viewController = [[PreventIndexController alloc] init];
    UINavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];
    [fromController presentViewController:nav animated:YES completion:nil];
    [viewController createBackBarButtonItem];
}



@end
