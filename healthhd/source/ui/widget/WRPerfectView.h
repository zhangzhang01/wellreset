//
//  WRPerfectView.h
//  rehab
//
//  Created by yefangyang on 16/8/24.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WRUserInfo.h"
#import "MTMissionHeadButton.h"
#import "ActionSheetStringPicker.h"
#import "JCAlertView.h"

@interface WRPerfectView : NSObject
@property (nonatomic, strong) UIViewController *viewControllr;
@property (nonatomic, strong) JCAlertView *alertView;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) UIButton *ageButton;
@property (nonatomic, strong) MTMissionHeadButton *clickedButton;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) void (^completionBlock)();

@property (nonatomic, strong) UITextField *heightTF;
@property (nonatomic, strong) UITextField *weightTF;
@property (nonatomic, assign) NSInteger userSex;
- (void)showChooseSexViewWithViewControlllr:(UIViewController *)viewController;
//- (void)showWriteMaterialWithViewControlllr:(UIViewController *)viewController;
@end
