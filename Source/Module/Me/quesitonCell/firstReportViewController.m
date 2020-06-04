//
//  firstReportViewController.m
//  rehab
//
//  Created by yefangyang on 2019/3/7.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "firstReportViewController.h"
#import "mainReportViewController.h"
#import "WRSheetView.h"
#import "UIViewController+WR.h"
#import "resultViewController.h"
@interface firstReportViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *textFArr;
@end

@implementation firstReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问卷";
    self.textFArr = [NSMutableArray array];
    UIImageView *backimageV =[[UIImageView alloc]initWithFrame:CGRectMake(ScreenW/2-75, 30, 150, 150)];
    backimageV.image = [UIImage imageNamed:@"开始答题图标"];
//    backimageV.backgroundColor = [UIColor redColor];
    [self.view addSubview:backimageV];
    NSArray *titleArr = [NSArray arrayWithObjects:@"姓名",@"性别",@"生日", nil];
    NSArray *placeHoderArr = [NSArray arrayWithObjects:@"请填写您的姓名",@"请填写您的性别",@"请填写您的填写日期", nil];
    for (NSInteger i = 0 ; i < 3 ; i ++) {
         
            UILabel* count = [UILabel new];
            count.x = 20;
            count.y = MaxY(backimageV)+40+70*i;
            count.textColor = [UIColor blackColor];
            count.font = [UIFont systemFontOfSize:18];
            count.text =titleArr[i] ;
            count.width = 80;
            count.height = 50;
            count.textAlignment = NSTextAlignmentLeft;
            [self.view addSubview:count];
        
        
        UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(MaxX(count)+5, MaxY(backimageV)+40+70*i, ScreenW-130, 50)];
        smallView.backgroundColor = COLOR(244, 247, 250, 1);
        smallView.layer.cornerRadius = 20.0;
        smallView.layer.masksToBounds = YES;
        [self.view addSubview:smallView];
        
        UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, ScreenW-150, 50)];
        textF.delegate = self;
        textF.font = FONT_14;
        textF.tag = i;
        textF.textAlignment = NSTextAlignmentRight;
        //    _textF.userInteractionEnabled = NO;
        textF.placeholder = placeHoderArr[i];
        if (i == 0) {
            textF.text = [WRUserInfo selfInfo].name;
        }if (i ==1) {
            if ([WRUserInfo selfInfo].sex == 0) {
                textF.text = @"男";
            }else{
                textF.text = @"男";
            }
        }if(i ==2){
            textF.text =[[WRUserInfo selfInfo].birthDay substringToIndex:10]  ;
             [DEFAULTS setObject:textF.text forKey:@"birthYear"];
        }
        [self.textFArr addObject:textF];
        [smallView addSubview:textF];
        
        
        
    }
    
    
    
    
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(15, MaxY(backimageV)+40+70*3, ScreenW-30, 50)];
//    [clearButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(onClickedBackButton:) forControlEvents:UIControlEventTouchUpInside];
    clearButton.layer.cornerRadius = 20.0;
    clearButton.layer.masksToBounds = YES;
    clearButton.backgroundColor = COLOR(140, 211, 251, 1);
    [clearButton setTitle:@"开始答题" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:clearButton];
    
    UILabel* count2 = [UILabel new];
    count2.x = 20;
    count2.y = MaxY(clearButton)+20;
    count2.textColor = [UIColor blackColor];
    count2.font = [UIFont systemFontOfSize:15];
//    count2.text =@"请阅读每个部分的项目，根据您最后一天的情况，选择一个最符合或与您最接近的答案。";
    count2.numberOfLines= 2.0;
    count2.width = ScreenW-40;
    count2.height = 50;
    count2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:count2];
    
    
    CGFloat x = 0, y = 0, cx = 0, cy = 0, offset = WRUIOffset;
    UIView *oauthView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(count2), ScreenW, 0)];
           y = offset;
           UILabel *label = [[UILabel alloc] init];
           label.text = NSLocalizedString(@"WELL健康", nil);
           label.font = [UIFont systemFontOfSize:WRDetailFont];
           label.textColor = [UIColor wr_titleTextColor];
           label.textAlignment = NSTextAlignmentCenter;
           [label sizeToFit];
           label.width = 103;
           label.centerX = oauthView.centerX;
           label.y = offset;
           label.backgroundColor = [UIColor whiteColor];
           
           
           UIView * line = [UIView new];
           line.x = WRUIBigOffset+WRUIDiffautOffset;
           line.width = self.view.width - (WRUIBigOffset+WRUIDiffautOffset)*2;
           line.height = 1;
           line.backgroundColor = [UIColor wr_lineColor];
           line.centerY = label.centerY;
           [oauthView addSubview:line];
           [oauthView addSubview:label];
           [self.view addSubview:oauthView];
    
    
    
//
//    UIButton *jumpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, ScreenW, 100)];
//    [jumpButton addTarget:self action:@selector(jumpReportButton) forControlEvents:UIControlEventTouchUpInside];
//    [backimageV addSubview:jumpButton];
    
}
//-(void)viewWillAppear
//{
//    self.navigationController.navigationBar.hidden = YES;
//}

-(void)onClickedBackButton:(UIButton *)button
{
    
    
    
    
    
    
   mainReportViewController *vc =[[mainReportViewController alloc]init];
    vc.tag = @"1";
    [self.navigationController pushViewController:vc animated:YES];
//    resultViewController *vc =[[resultViewController alloc]init];
//    //    vc.tag = @"0";
//        [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
         [textField resignFirstResponder];
        UIView *sourceView = nil;
                       CGRect sourceRect = CGRectZero;
//                       if (IPAD_DEVICE) {
//                           UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//                           sourceView = cell;
//                           sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
//                       }
        [self showSexSelectorWithCompletion:^(NSInteger sex) {
//            _userInfo.sex = sex;
//            [weakSelf.tableView reloadData];
//            [weakSelf onClickedSubmitButton:nil];
//            [WRUserInfo selfInfo].sex = sex;
//            [[WRUserInfo selfInfo] save];
            
            if(sex == 0)
            {
                textField.text = @"男";
            }if (sex == 1) {
                textField.text = @"女";
            }
            
            
        } sourceView:sourceView sourceRect:sourceRect];
        
        
    }if (textField.tag == 2) {
        [textField resignFirstResponder];
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 40, 216)];
        picker.datePickerMode =UIDatePickerModeDate;
        [WRSheetView showWithCustomView:picker completion:^{
            NSDate *date = picker.date;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy"];
            NSInteger currentYear = [[formatter stringFromDate:date] integerValue];
            [formatter setDateFormat:@"MM"];
            NSInteger currentMonth=[[formatter stringFromDate:date] integerValue];
            [formatter setDateFormat:@"dd"];
            NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
            NSInteger birthdayYear = currentYear;
            NSString * birthdayStr =[NSString stringWithFormat:@"%d-%d-%d",(int)birthdayYear,(int)currentMonth,(int)currentDay];
            textField.text = birthdayStr;
           
            [DEFAULTS setObject:textField.text forKey:@"birthYear"];
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
