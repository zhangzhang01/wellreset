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
#import <YYKit/YYKit.h>
@interface WRPerfectView ()<UITextFieldDelegate>

@end

@implementation WRPerfectView

- (void)showChooseSexViewWithViewControlllr:(UIViewController *)viewController
{
    _viewControllr = viewController;
    WRUserInfo *selfInfo =  [WRUserInfo selfInfo];
    self.userSex = selfInfo.sex;
    self.userHeight = selfInfo.height;
    self.userWeight = selfInfo.weight;
    self.birthday = selfInfo.birthDay;
    CGFloat offset = 10;
    CGFloat labelH = 44;
    CGFloat buttonW = 120;
    CGFloat textFieldH = 60;
    CGFloat viewWidth;
    viewWidth = viewController.view.width - 2 * WRUIOffset;
    UIView *perfectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MIN(viewWidth, 420), 2 * labelH + 2.5 *buttonW + 4 *offset)];
    perfectView.layer.cornerRadius = 5.0f;
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, perfectView.width, 0)];
    topView.image = [UIImage imageNamed:@"perfect_top_bg"];
    [perfectView addSubview:topView];

    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,perfectView.width , labelH)];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.text = NSLocalizedString(@"完善资料", nil);
    labelTitle.font = [UIFont wr_smallTitleFont];
    labelTitle.textColor = [UIColor whiteColor];
    [topView addSubview:labelTitle];
    
    UILabel *labelMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, labelTitle.bottom, labelTitle.width, labelH)];
    labelMessage.textAlignment = NSTextAlignmentCenter;
    labelMessage.text = NSLocalizedString(@"WELL健康将为您量身制定方案", nil);
    labelMessage.font = [UIFont wr_tinyFont];
    labelMessage.textColor = [UIColor whiteColor];
    [topView addSubview:labelMessage];
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, labelMessage.bottom,  labelMessage.width, lineH)];
//    line.backgroundColor = [UIColor lightGrayColor];
//    [topView addSubview:line];
    topView.height = labelMessage.bottom + offset;
    
    UILabel *label = nil;
    label = [self createLabelWithTitle:NSLocalizedString(@"性别", nil)];
    label.frame = [Utility moveRect:label.frame x:2 * offset y:topView.bottom + offset];
    [perfectView addSubview:label];
    
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"男", nil), NSLocalizedString(@"女", nil)]];
    segCtrl.tintColor = [UIColor wr_rehabBlueColor];
    [segCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    if (self.userSex) {
            segCtrl.selectedSegmentIndex = self.userSex - 1;
    }
    [segCtrl sizeToFit];
    segCtrl.frame = [Utility moveRect:segCtrl.frame x:label.right + offset y:topView.bottom + offset];
    segCtrl.frame = [Utility resizeRect:segCtrl.frame cx:perfectView.right - label.right - 3 * offset height:label.height];
    [segCtrl addTarget:self action:@selector(onSegmentControlValueChange:) forControlEvents:UIControlEventValueChanged];
    [perfectView addSubview:segCtrl];
    
/*
    MTMissionHeadButton *manButton = [[MTMissionHeadButton alloc] initWithFrame:CGRectMake((perfectView.width - 2 * buttonW) / 3, line.bottom, buttonW, buttonW)];
    manButton.tag = 1;
    [manButton setTitle:@"男" forState:UIControlStateNormal];
    [manButton setImage:[UIImage imageNamed:@"icon_button_man"] forState:UIControlStateNormal];
    [manButton setImage:[UIImage imageNamed:@"icon_button_man_selected"] forState:UIControlStateSelected];
    [perfectView addSubview:manButton];
    [manButton addTarget:self action:@selector(onClickedSexButton:) forControlEvents:UIControlEventTouchUpInside];
    
    MTMissionHeadButton *womanButton = [[MTMissionHeadButton alloc] initWithFrame:CGRectMake(manButton.right + (perfectView.width - 2 * buttonW) / 3 , line.bottom, buttonW, buttonW)];
    womanButton.tag = 2;
    [womanButton setImage:[UIImage imageNamed:@"icon_button_woman_selected"] forState:UIControlStateSelected];
    [womanButton setTitle:@"女" forState:UIControlStateNormal];
    [womanButton setImage:[UIImage imageNamed:@"icon_button_woman"] forState:UIControlStateNormal];
    [perfectView addSubview:womanButton];
    [womanButton addTarget:self action:@selector(onClickedSexButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.userSex == GenderFemale) {
        womanButton.selected = YES;
        self.clickedButton = womanButton;
    } else if (self.userSex == GenderMale) {
        manButton.selected = YES;
        self.clickedButton = manButton;
    } else {
        
    }
    */
    
    UITextField *heightTF = [[UITextField alloc] initWithFrame:CGRectMake(offset, segCtrl.bottom +  offset, perfectView.width - 2 * offset, textFieldH)];
    heightTF.delegate = self;
    [heightTF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    heightTF.leftViewMode = UITextFieldViewModeAlways;
    heightTF.rightViewMode = UITextFieldViewModeAlways;
    heightTF.keyboardType = UIKeyboardTypeDecimalPad;
    UIView *heightLeftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, textFieldH)];
    UILabel *heightL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,40 ,textFieldH )];
    [heightLeftV addSubview:heightL];
    heightL.text = NSLocalizedString(@"身高", nil);
    heightL.font = [UIFont wr_smallTitleFont];
    heightL.textColor = [UIColor blackColor];
    heightTF.text = [NSString stringWithFormat:@"%d",(int)selfInfo.height];
    
    UIView *heightRightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 36)];
    UILabel *heightR = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,40 ,36 )];
    [heightRightV addSubview:heightR];
    heightR.text = NSLocalizedString(@"cm", nil);
    heightR.textColor = [UIColor blackColor];
    
    heightTF.leftView = heightLeftV;
    heightTF.rightView = heightRightV;
    heightTF.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [perfectView addSubview:heightTF];
    self.heightTF = heightTF;
    
    UITextField *weightTF = [[UITextField alloc] initWithFrame:CGRectMake(offset, heightTF.bottom +  offset, perfectView.width - 2 *offset, textFieldH)];
    weightTF.delegate = self;
    [weightTF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    weightTF.keyboardType = UIKeyboardTypeDecimalPad;
    weightTF.leftViewMode = UITextFieldViewModeAlways;
    weightTF.rightViewMode = UITextFieldViewModeAlways;
    UIView *weightLeftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 36)];
    UILabel *weightL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,40 ,36 )];
    [weightLeftV addSubview:weightL];
    weightL.text = NSLocalizedString(@"体重", nil);
    weightL.font = [UIFont wr_smallTitleFont];
    weightL.textColor = [UIColor blackColor];
    weightTF.text = [NSString stringWithFormat:@"%d",(int)selfInfo.weight];
    UIView *weightRightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 36)];
    UILabel *weightR = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,40 ,36 )];
    [weightRightV addSubview:weightR];
    weightR.text = NSLocalizedString(@"kg", nil);
    weightR.textColor = [UIColor blackColor];
    
    weightTF.leftView = weightLeftV;
    weightTF.rightView = weightRightV;
    weightTF.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [perfectView addSubview:weightTF];
    self.weightTF = weightTF;
    
    UIView *ageView = [[UIView alloc] initWithFrame:CGRectMake(offset, weightTF.bottom + offset, perfectView.width - 2 *offset, textFieldH)];
    ageView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 0, textFieldH, textFieldH)];
    ageLabel.text = NSLocalizedString(@"年龄", nil);
    ageLabel.font = [UIFont wr_smallTitleFont];
    ageLabel.textColor = [UIColor blackColor];
    [ageView addSubview:ageLabel];
    
    UIButton *ageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ageButton.frame = CGRectMake(ageLabel.right, 0, perfectView.width - 3 *offset - textFieldH, textFieldH);
    [ageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ageView addSubview:ageButton];
    [perfectView addSubview:ageView];
    [ageButton addTarget:self action:@selector(onClickedAgeButton:) forControlEvents:UIControlEventTouchUpInside];
    self.ageButton = ageButton;
    if (![Utility IsEmptyString:_birthday]) {
        if (_birthday.length > 10)
        {
            _birthday = [_birthday substringToIndex:10];
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *birthDayDate = [dateFormatter dateFromString:_birthday];
        //当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
        NSTimeInterval time = [currentDate timeIntervalSinceDate:birthDayDate];
        int age = ((int)time)/(3600*24*365);
        self.age = [@(age) stringValue];
        [ageButton setTitle:self.age forState:UIControlStateNormal];
    }
    
//    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelButton.frame = CGRectMake(offset, ageView.bottom + offset, (perfectView.width - 3 *offset)/2, 40);
//    [cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(onClickedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
//    cancelButton.layer.cornerRadius = 5.0f;
//    cancelButton.backgroundColor = [UIColor lightGrayColor];
//    cancelButton.enabled = YES;
//    [perfectView addSubview:cancelButton];
    
    UIButton * completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(offset, ageView.bottom + offset, perfectView.width - 2 *offset, 40);
    [completeButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(onClickedCompleteButton:) forControlEvents:UIControlEventTouchUpInside];
    completeButton.layer.cornerRadius = 5.0f;
    completeButton.backgroundColor = [UIColor lightGrayColor];
    completeButton.enabled = [self checkCompleteButtonIsEnable];
    [perfectView addSubview:completeButton];
    self.completeButton = completeButton;
    
    perfectView.backgroundColor = [UIColor whiteColor];
    JCAlertView *alertView = [[JCAlertView alloc] initWithCustomView:perfectView dismissWhenTouchedBackground:YES];
    self.alertView = alertView;
    [alertView show];
}

- (IBAction)onSegmentControlValueChange:(UISegmentedControl *)sender
{
    self.userSex = sender.selectedSegmentIndex + 1;
    self.completeButton.enabled = [self checkCompleteButtonIsEnable];
    if (self.completeButton.enabled == NO) {
        self.completeButton.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.completeButton.backgroundColor = [UIColor wr_rehabBlueColor];
    }

}

- (UILabel *)createLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont wr_smallTitleFont];
    [label sizeToFit];
    label.frame = [Utility resizeRect:label.frame cx:label.width * 4 / 3 height:label.height * 4 / 3];
    return label;
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
                                           weakself.age = array[selectedIndex];
                                           [sender setTitle:weakself.age forState:UIControlStateNormal];
                                           
                                           NSDate *date = [NSDate date];
                                           NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                           [formatter setDateFormat:@"yyyy"];
                                           NSInteger currentYear = [[formatter stringFromDate:date] integerValue];
                                           [formatter setDateFormat:@"MM"];
                                           NSInteger currentMonth=[[formatter stringFromDate:date] integerValue];
                                           [formatter setDateFormat:@"dd"];
                                           NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
                                           NSInteger birthdayYear = currentYear - [weakself.age integerValue];
                                           NSString * birthdayStr =[NSString stringWithFormat:@"%d-%d-%d",(int)birthdayYear,(int)currentMonth,(int)currentDay];
                                           weakself.birthday = birthdayStr;
                                           
                                           weakself.completeButton.enabled = [self checkCompleteButtonIsEnable];
                                           if (weakself.completeButton.enabled == NO) {
                                               weakself.completeButton.backgroundColor = [UIColor lightGrayColor];
                                           } else {
                                               weakself.completeButton.backgroundColor = [UIColor wr_rehabBlueColor];
                                           }
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         
                                     }
                                          origin:_alertView];
}

- (BOOL)checkCompleteButtonIsEnable
{
    BOOL isEnable = NO;
    if ((self.userSex == GenderMale || self.userSex == GenderFemale) && ![Utility IsEmptyString:self.birthday] && self.userHeight != 0 && self.userWeight != 0) {
        isEnable = YES;
    }
    return isEnable;
}

- (void)textChange
{
    self.userWeight = [self.weightTF.text integerValue];
    self.userHeight = [self.heightTF.text integerValue];
    self.completeButton.enabled = [self checkCompleteButtonIsEnable];
    if (self.completeButton.enabled == NO) {
        self.completeButton.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.completeButton.backgroundColor = [UIColor wr_rehabBlueColor];
    }
}

- (IBAction)onClickedSexButton:(MTMissionHeadButton *)sender
{
    self.clickedButton.selected = NO;
    self.clickedButton = sender;
    self.clickedButton.selected = YES;
    self.userSex = sender.tag;
    self.completeButton.enabled = [self checkCompleteButtonIsEnable];
    if (self.completeButton.enabled == NO) {
        self.completeButton.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.completeButton.backgroundColor = [UIColor wr_rehabBlueColor];
    }
}

- (IBAction)onClickedCompleteButton:(UIButton *)sender
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"birthDay"] = self.birthday;
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
                WRUserInfo *userInfo = [WRUserInfo selfInfo];
                userInfo.sex = weakSelf.userSex;
                userInfo.birthDay = weakSelf.birthday;
                userInfo.height = [weakSelf.heightTF.text integerValue];
                userInfo.weight = [weakSelf.weightTF.text integerValue];
                [userInfo save];
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


@end
