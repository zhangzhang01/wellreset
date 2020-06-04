//
//  WRPerfectView.m
//  rehab
//
//  Created by yefangyang on 16/8/24.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRPerfectView.h"
#import "WRViewModel.h"
#import "SVProgressHUD.h"


@implementation WRPerfectView

- (void)showChooseSexViewWithViewControlllr:(UIViewController *)viewController
{
    _viewControllr = viewController;
    self.userSex = 0;
    CGFloat YYYHorizonMargin = 10;
    CGFloat labelH = 44;
    CGFloat buttonW = 120;
//    CGFloat imageH = 60;
    CGFloat textFieldH = 60;
    CGFloat lineH = 1;
    UIView *perfectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 2 * YYYHorizonMargin, 2 * labelH + 2.5 *buttonW + 4 *YYYHorizonMargin)];
    perfectView.layer.cornerRadius = 5.0f;
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 2 *YYYHorizonMargin, labelH)];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.text = NSLocalizedString(@"完善资料", nil);
    labelTitle.textColor = [UIColor lightGrayColor];
    [perfectView addSubview:labelTitle];
    
    UILabel *labelMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelTitle.frame), [UIScreen mainScreen].bounds.size.width - 2 *YYYHorizonMargin, labelH)];
    labelMessage.textAlignment = NSTextAlignmentCenter;
    labelMessage.text = NSLocalizedString(@"WELL健康将为您量身制定方案", nil);
    labelMessage.textColor = [UIColor lightGrayColor];
    [perfectView addSubview:labelMessage];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelMessage.frame),  [UIScreen mainScreen].bounds.size.width - 2 *YYYHorizonMargin, lineH)];
    line.backgroundColor = [UIColor lightGrayColor];
    [perfectView addSubview:line];
    
    MTMissionHeadButton *manButton = [[MTMissionHeadButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 2 *YYYHorizonMargin - 2 * buttonW) / 3, CGRectGetMaxY(line.frame), buttonW, buttonW)];
    manButton.tag = 1;
    [manButton setTitle:@"男" forState:UIControlStateNormal];
    [manButton setImage:[UIImage imageNamed:@"icon_button_man"] forState:UIControlStateNormal];
    [manButton setImage:[UIImage imageNamed:@"icon_button_man_selected"] forState:UIControlStateSelected];
    [perfectView addSubview:manButton];
    [manButton addTarget:self action:@selector(onClickedSexButton:) forControlEvents:UIControlEventTouchUpInside];
    
    MTMissionHeadButton *womanButton = [[MTMissionHeadButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(manButton.frame) + ([UIScreen mainScreen].bounds.size.width - 2 *YYYHorizonMargin - 2 * buttonW) / 3, CGRectGetMaxY(line.frame), buttonW, buttonW)];
    womanButton.tag = 2;
    [womanButton setImage:[UIImage imageNamed:@"icon_button_woman_selected"] forState:UIControlStateSelected];
    [womanButton setTitle:@"女" forState:UIControlStateNormal];
    [womanButton setImage:[UIImage imageNamed:@"icon_button_woman"] forState:UIControlStateNormal];
    [perfectView addSubview:womanButton];
    [womanButton addTarget:self action:@selector(onClickedSexButton:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImageView *iconView = [[UIImageView alloc] init];
//    iconView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 2 *YYYHorizonMargin - imageH)/2, CGRectGetMaxY(womanButton.frame) +YYYHorizonMargin, imageH, imageH);
//    [perfectView addSubview:iconView];
//    self.headImageView = iconView;
//    BOOL defaultHeadImageFlag = YES;
//    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
//    if ([selfInfo isLogged]) {
//        if (![Utility IsEmptyString:selfInfo.headImageUrl]) {
//            defaultHeadImageFlag = NO;
//            [self.headImageView setImageWithUrlString:selfInfo.headImageUrl holderImage:[WRUIConfig defaultHeadImage]];
//            
//        }
//    }
//    if (defaultHeadImageFlag) {
//        self.headImageView.image = [WRUIConfig defaultHeadImage];
//    }
    
    UITextField *heightTF = [[UITextField alloc] initWithFrame:CGRectMake(YYYHorizonMargin, CGRectGetMaxY(womanButton.frame) +  YYYHorizonMargin, ([UIScreen mainScreen].bounds.size.width - 5 *YYYHorizonMargin) / 2, textFieldH)];
    [heightTF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    heightTF.leftViewMode = UITextFieldViewModeAlways;
    heightTF.keyboardType = UIKeyboardTypeDecimalPad;
    UIView *heightLeftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, textFieldH)];
    UILabel *heightL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,40 ,textFieldH )];
    [heightLeftV addSubview:heightL];
    heightL.text = NSLocalizedString(@"身高", nil);
    heightL.textColor = [UIColor blackColor];
    heightTF.leftView = heightLeftV;
        heightTF.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    heightTF.placeholder = NSLocalizedString(@"cm", nil);
    [perfectView addSubview:heightTF];
    self.heightTF = heightTF;

    UITextField *weightTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(heightTF.frame) + YYYHorizonMargin, CGRectGetMaxY(womanButton.frame) +  YYYHorizonMargin, ([UIScreen mainScreen].bounds.size.width - 5 *YYYHorizonMargin) / 2, textFieldH)];
    [weightTF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    weightTF.keyboardType = UIKeyboardTypeDecimalPad;
    weightTF.leftViewMode = UITextFieldViewModeAlways;
    UIView *weightLeftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 36)];
    UILabel *weightL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,40 ,36 )];
    [weightLeftV addSubview:weightL];
    weightL.text = NSLocalizedString(@"体重", nil);
    weightL.textColor = [UIColor blackColor];
    weightTF.leftView = weightLeftV;
        weightTF.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    weightTF.placeholder = NSLocalizedString(@"kg", nil);
    [perfectView addSubview:weightTF];
    self.weightTF = weightTF;
    
    
    UIView *ageView = [[UIView alloc] initWithFrame:CGRectMake(YYYHorizonMargin, CGRectGetMaxY(weightTF.frame) + YYYHorizonMargin, [UIScreen mainScreen].bounds.size.width - 4 *YYYHorizonMargin, textFieldH)];
        ageView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(YYYHorizonMargin, 0, textFieldH, textFieldH)];
    ageLabel.text = NSLocalizedString(@"年龄", nil);
    ageLabel.textColor = [UIColor blackColor];
    [ageView addSubview:ageLabel];
    
    UIButton *ageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ageButton.frame = CGRectMake(CGRectGetMaxX(ageLabel.frame), 0, [UIScreen mainScreen].bounds.size.width - 5 *YYYHorizonMargin - textFieldH, textFieldH);
    [ageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ageView addSubview:ageButton];
    [perfectView addSubview:ageView];
    [ageButton addTarget:self action:@selector(onClickedAgeButton:) forControlEvents:UIControlEventTouchUpInside];
    self.ageButton = ageButton;
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(YYYHorizonMargin, CGRectGetMaxY(ageView.frame) + YYYHorizonMargin, ([UIScreen mainScreen].bounds.size.width - 5 *YYYHorizonMargin)/2, 40);
    [cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onClickedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 5.0f;
    cancelButton.backgroundColor = [UIColor lightGrayColor];
    cancelButton.enabled = YES;
    [perfectView addSubview:cancelButton];
    
    UIButton * completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = [Utility moveRect:cancelButton.frame x:(cancelButton.right +  YYYHorizonMargin) y:-1];
    [completeButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(onClickedCompleteButton:) forControlEvents:UIControlEventTouchUpInside];
    completeButton.layer.cornerRadius = 5.0f;
    completeButton.backgroundColor = [UIColor wr_themeColor];
    completeButton.enabled = NO;
    [perfectView addSubview:completeButton];
    self.completeButton = completeButton;
    
    perfectView.backgroundColor = [UIColor whiteColor];
    JCAlertView *alertView = [[JCAlertView alloc] initWithCustomView:perfectView dismissWhenTouchedBackground:YES];
    self.alertView = alertView;
    [alertView show];
}

- (IBAction)onClickedAgeButton:(UIButton *)sender
{
    __weak __typeof(self)weakself = self;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 10; i < 81; i++) {
        [array addObject:[@(i) stringValue]];
    }
    [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"选择年龄", nil)
                                            rows:array
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [sender setTitle:array[selectedIndex] forState:UIControlStateNormal];
                                           weakself.completeButton.enabled = (weakself.heightTF.text.length > 0 && weakself.weightTF.text.length > 0 && weakself.userSex) != 0;
                                           NSLog(@"userSex%ld",(long)weakself.userSex);
                                           if (weakself.completeButton.enabled == NO) {
                                               weakself.completeButton.backgroundColor = [UIColor lightGrayColor];
                                           } else {
                                               weakself.completeButton.backgroundColor = [UIColor wr_themeColor];
                                           }
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         
                                     }
                                          origin:_viewControllr.view];
}

- (void)textChange
{
    NSString *age = [self.ageButton titleForState:UIControlStateNormal];
    self.completeButton.enabled = (self.heightTF.text.length > 0 && self.weightTF.text.length > 0 && age.length > 0 && self.userSex != 0);
    if (self.completeButton.enabled == NO) {
        self.completeButton.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.completeButton.backgroundColor = [UIColor wr_themeColor];
    }
}

- (IBAction)onClickedSexButton:(MTMissionHeadButton *)sender
{
    NSString *age = [self.ageButton titleForState:UIControlStateNormal];
    self.clickedButton.selected = NO;
//    self. clickedButton.backgroundColor = [UIColor whiteColor];
    self.clickedButton = sender;
    self.clickedButton.selected = YES;
//    self.clickedButton.backgroundColor = [UIColor lightGrayColor];
    self.completeButton.enabled = (self.heightTF.text.length > 0 && self.weightTF.text.length > 0 && age.length > 0 &&self.clickedButton != nil);
    if (self.completeButton.enabled == NO) {
        self.completeButton.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.completeButton.backgroundColor = [UIColor wr_themeColor];
    }
    self.userSex = sender.tag;
}

- (IBAction)onClickedCompleteButton:(UIButton *)sender
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSInteger age = [[self.ageButton titleForState:UIControlStateNormal] integerValue];;
    params[@"age"] = @(age);
    params[@"height"] = @([self.heightTF.text integerValue]);
    params[@"weight"] = @([self.weightTF.text integerValue]);
    params[@"sex"] = @(self.userSex);
    if (params.count == 0) {
        [Utility showToast:NSLocalizedString(@"并没有修改任何信息", nil) position:ToastPositionBottom];
    } else {
        __weak __typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在提交请求", nil)];
        [WRViewModel modifySelfBasicInfo:params completion:^(NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            if (error) {
                NSString *errorString = error.domain;
                if ([Utility IsEmptyString:errorString]) {
                    errorString = NSLocalizedString(@"修改信息失败,请检查网络", nil);
                }
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:errorString message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [controller addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                     [weakSelf onClickedCompleteButton:sender];
                    }]];
                    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf.alertView dismissWithCompletion:nil];
                    }]];

                    [(UIViewController *)weakSelf.alertView.vc presentViewController:controller animated:YES completion:nil];
            } else {
                [self.alertView dismissWithCompletion:^{
                    if (_completionBlock) {
                        _completionBlock();
                    }
                }];
                [[NSNotificationCenter defaultCenter] postNotificationName:WRUpdateSelfInfoNotification object:nil];
            }
        }];
    }
}

-(IBAction)onClickedCancelButton:(id)sender
{
    [_alertView dismissWithCompletion:nil];
}
//- (IBAction)onClickedPrefectCompleteButton:(UIButton *)sender
//{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSInteger age = [[self.ageButton titleForState:UIControlStateNormal] integerValue];;
//    params[@"age"] = @(age);
//    params[@"height"] = @([self.heightTF.text integerValue]);
//    params[@"weight"] = @([self.weightTF.text integerValue]);
//    if (params.count == 0) {
//        [Utility showToast:NSLocalizedString(@"并没有修改任何信息", nil)];
//    } else {
//        __weak __typeof(self) weakSelf = self;
//        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在提交请求", nil)];
//        [WRViewModel modifySelfBasicInfo:params completion:^(NSError * _Nonnull error) {
//            [SVProgressHUD dismiss];
//            if (error) {
//                NSString *errorString = error.domain;
//                if ([Utility IsEmptyString:errorString]) {
//                    errorString = NSLocalizedString(@"修改信息失败,请检查网络", nil);
//                }
//                [Utility retryAlertWithViewController:weakSelf.viewControllr title:errorString completion:^{
//                    [weakSelf onClickedCompleteButton:sender];
//                }];
//            } else {
//                //                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"修改成功", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
//                //                [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                //                    [weakSelf.viewControllr.navigationController popViewControllerAnimated:YES];
//                //                }]];
//                //                [weakSelf.viewControllr presentViewController:controller animated:YES completion:nil];
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:WRUpdateSelfInfoNotification object:nil];
//            }
//        }];
//    }
//    [self.alertView dismissWithCompletion:nil];
//}
//
//
//
//- (void)showWriteMaterialWithViewControlllr:(UIViewController *)viewController
//{
//    _viewControllr = viewController;
//    CGFloat labelH = 44;
//    CGFloat imageH = 60;
//    CGFloat textFieldH = 60;
//    CGFloat YYYHorizonMargin = 10;
//    UIView *prefectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 3 * YYYHorizonMargin, labelH + 6 * YYYHorizonMargin + 3 * textFieldH + imageH)];
//    prefectView.layer.cornerRadius = 5.0f;
//    prefectView.backgroundColor = [UIColor whiteColor];
//    
//    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 3 *YYYHorizonMargin, labelH)];
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    labelTitle.text = NSLocalizedString(@"完善资料", nil);
//    labelTitle.textColor = [UIColor blackColor];
//    labelTitle.font = [UIFont wr_titleFont];
//    [prefectView addSubview:labelTitle];
//    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelTitle.frame), [UIScreen mainScreen].bounds.size.width - 3 *YYYHorizonMargin, 1)];
//    line.backgroundColor = [UIColor lightGrayColor];
//    [prefectView addSubview:line];
//    
//    
//    UIImageView *iconView = [[UIImageView alloc] init];
//    iconView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 2 *YYYHorizonMargin - 60)/2, CGRectGetMaxY(line.frame) +YYYHorizonMargin, imageH, imageH);
//    [prefectView addSubview:iconView];
//    self.headImageView = iconView;
//    BOOL defaultHeadImageFlag = YES;
//    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
//    if ([selfInfo isLogged]) {
//        if (![Utility IsEmptyString:selfInfo.headImageUrl]) {
//            defaultHeadImageFlag = NO;
//            [self.headImageView setImageWithUrlString:selfInfo.headImageUrl holderImage:[WRUIConfig defaultHeadImage]];
//            
//        }
//    }
//    if (defaultHeadImageFlag) {
//        self.headImageView.image = [WRUIConfig defaultHeadImage];
//    }
//    
//    UITextField *heightTF = [[UITextField alloc] initWithFrame:CGRectMake(YYYHorizonMargin, CGRectGetMaxY(iconView.frame) +  YYYHorizonMargin, ([UIScreen mainScreen].bounds.size.width - 6 *YYYHorizonMargin) / 2, textFieldH)];
//    [heightTF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
//    heightTF.leftViewMode = UITextFieldViewModeAlways;
//    heightTF.keyboardType = UIKeyboardTypeDecimalPad;
//    UIView *heightLeftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 36)];
//    UILabel *heightL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,40 ,36 )];
//    [heightLeftV addSubview:heightL];
//    heightL.text = NSLocalizedString(@"身高", nil);
//    heightL.textColor = [UIColor blackColor];
//    heightTF.leftView = heightLeftV;
//    //    heightTF.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
//    heightTF.placeholder = NSLocalizedString(@"未填写", nil);
//    [prefectView addSubview:heightTF];
//    self.heightTF = heightTF;
//    
//    
//    UITextField *weightTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(heightTF.frame) + YYYHorizonMargin, CGRectGetMaxY(iconView.frame) +  YYYHorizonMargin, ([UIScreen mainScreen].bounds.size.width - 6 *YYYHorizonMargin) / 2, textFieldH)];
//    [weightTF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
//    weightTF.keyboardType = UIKeyboardTypeDecimalPad;
//    weightTF.leftViewMode = UITextFieldViewModeAlways;
//    UIView *weightLeftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 36)];
//    UILabel *weightL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,40 ,36 )];
//    [weightLeftV addSubview:weightL];
//    weightL.text = NSLocalizedString(@"体重", nil);
//    weightL.textColor = [UIColor blackColor];
//    weightTF.leftView = weightLeftV;
//    //    weightTF.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
//    weightTF.placeholder = NSLocalizedString(@"未填写", nil);
//    [prefectView addSubview:weightTF];
//    self.weightTF = weightTF;
//    
//    
//    UIView *ageView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(weightTF.frame) + YYYHorizonMargin, [UIScreen mainScreen].bounds.size.width - 5 *YYYHorizonMargin, textFieldH)];
//    //    ageView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
//    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 60)];
//    ageLabel.text = NSLocalizedString(@"年龄", nil);
//    ageLabel.textColor = [UIColor blackColor];
//    [ageView addSubview:ageLabel];
//    
//    UIButton *ageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    ageButton.frame = CGRectMake(CGRectGetMaxX(ageLabel.frame), 0, [UIScreen mainScreen].bounds.size.width - 5 *YYYHorizonMargin - 60, textFieldH);
//    [ageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [ageView addSubview:ageButton];
//    [prefectView addSubview:ageView];
//    [ageButton addTarget:self action:@selector(onClickedAgeButton:) forControlEvents:UIControlEventTouchUpInside];
//    self.ageButton = ageButton;
//    
//    
//    UIButton *completePrefectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    completePrefectButton.frame = CGRectMake(10, CGRectGetMaxY(ageView.frame) + YYYHorizonMargin, [UIScreen mainScreen].bounds.size.width - 5 *YYYHorizonMargin, textFieldH);
//    [completePrefectButton setTitle:@"确定" forState:UIControlStateNormal];
//    [completePrefectButton addTarget:self action:@selector(onClickedPrefectCompleteButton:) forControlEvents:UIControlEventTouchUpInside];
//    completePrefectButton.layer.cornerRadius = 5.0f;
//    [prefectView addSubview:completePrefectButton];
//    self.completeButton = completePrefectButton;
//    [self textChange];
//    
//    JCAlertView *alertPrefectView = [[JCAlertView alloc] initWithCustomView:prefectView dismissWhenTouchedBackground:YES];
//    self.alertView = alertPrefectView;
//    [alertPrefectView show];
//}



@end
