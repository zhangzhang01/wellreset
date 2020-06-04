//
//  questionResultViewController.m
//  rehab
//
//  Created by matech on 2019/11/13.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "questionResultViewController.h"
#import "questionRSTableViewCell.h"
#import "reportViewModel.h"
#import "FCAlertView.h"
#import "nextViewController.h"
#import "ComulitModel.h"
#import "resultViewController.h"
#import "singleSelectViewController.h"
@interface questionResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property UITableView* mytableview;
@property ComulitModel* viewModel;
@end

@implementation questionResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问卷确认";
     self.viewModel = [ComulitModel new];
    self.view.backgroundColor = COLOR(240, 243, 245, 1);
//    self.navigationItem.hidesBackButton = YES;
    _mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, SCREEN_HEIGHT-200) style:UITableViewStylePlain];
    [self.view addSubview:_mytableview];
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    [self.navigationItem setHidesBackButton:YES];
    self.mytableview.backgroundColor = COLOR(240, 243, 245, 1);
    self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self createBackBarButtonItem];
}
-(void)createBackBarButtonItem {
    NSLog(@"????");
    
    
   UIButton* clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 47)];
    [clearButton setTitleColor:COLOR_grayColor forState:UIControlStateNormal];
     [clearButton setTitle:@"退出" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    clearButton.hidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    self.navigationItem.rightBarButtonItem = item;
    
    
   UIButton* offerButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT-180, ScreenW-30, 60)];
       //    [clearButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
   [offerButton addTarget:self action:@selector(offerButton:) forControlEvents:UIControlEventTouchUpInside];
   offerButton.layer.cornerRadius = 20.0;
   offerButton.layer.masksToBounds = YES;
   offerButton.backgroundColor = COLOR(140, 211, 251, 1);
   [offerButton setTitle:@"提交问卷" forState:UIControlStateNormal];
   [offerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   [self.view addSubview:offerButton];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.detailArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    reportViewModel *model = self.titleArray[indexPath.row];
    reportModel *Model = self.secondArray[indexPath.row];
    questionModel *quesModel = self.detailArray[indexPath.row];
      // 定义唯一标识
      static NSString *CellIdentifier = @"Cell2";
      questionRSTableViewCell* cell=[[questionRSTableViewCell alloc]init];
      if (!cell) {
          cell=[[questionRSTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

      }
    cell.contentView.backgroundColor = COLOR(240, 243, 245, 1);
    [cell setModel:self.titleArray withSecondeModel:Model withDetailModel:quesModel withindex:indexPath.row+1 withTag:[self.tagStr integerValue]];
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    singleSelectViewController *vc = [[singleSelectViewController alloc]init];
    vc.titleArray2 = self.titleArray;
    vc.secondArray2 =self.secondArray;
    vc.detailArray2 = self.detailArray;
    vc.index = indexPath.row;
    vc.backClick = ^(NSMutableArray * _Nonnull backArray) {
        self.detailArray = backArray;
        [_mytableview reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)backButton:(UIButton *)button
{
    FCAlertView *alert = [[FCAlertView alloc] init];
        [alert showAlertInView:self withTitle:NSLocalizedString(@"提示", nil) withSubtitle:NSLocalizedString(@"要退出此次问卷调查吗?\n退出后所选记录清除！", nil) withCustomImage:nil withDoneButtonTitle:NSLocalizedString(@"取消", nil) andButtons:nil];
        [alert addButton:NSLocalizedString(@"退出", nil) withActionBlock:^{
          
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
           
            
            
            
        }];
        alert.colorScheme = [UIColor wr_themeColor];
    
  
   
}
-(void)offerButton:(UIButton *)button
{
    NSDictionary *dicOne;
      NSMutableArray *totalArray = [NSMutableArray array];
      for (NSInteger i = 0 ; i < self.detailArray.count ; i++) {
          questionModel *model = self.detailArray[i];
          NSString *interStr = model.grade;
          [totalArray addObject:interStr];
      }
      CGFloat sum = [[totalArray valueForKeyPath:@"@sum.floatValue"] floatValue];
      NSString *birthdefaule =[DEFAULTS objectForKey:@"birthYear"];
      if ([self.tagStr isEqualToString:@"0"]) {
          dicOne = [NSDictionary dictionaryWithObjectsAndKeys:[WRUserInfo selfInfo].userId,@"userId",[WRUserInfo selfInfo].name,@"userName",[NSString stringWithFormat:@"%.2f",sum],@"grade",@"1",@"istrue",birthdefaule,@"age",[NSString stringWithFormat:@"%ld",self.detailArray.count],@"number",nil];
      }else
      {
         dicOne = [NSDictionary dictionaryWithObjectsAndKeys:[WRUserInfo selfInfo].userId,@"userId",[WRUserInfo selfInfo].name,@"userName",[NSString stringWithFormat:@"%.2f",sum],@"grade",@"0",@"istrue",birthdefaule,@"age",[NSString stringWithFormat:@"%ld",self.detailArray.count],@"number",nil];
      }
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicOne options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    NSLog(@"%@",jsonString);
      [self.viewModel submitGrade:jsonString block:^(bool success,NSString *message) {
          if (success) {
              if ([self.tagStr isEqualToString:@"1"]) {
                  nextViewController *vc = [[nextViewController alloc]init];
                  [self.navigationController pushViewController:vc animated:YES];
              }else{
               
                  resultViewController *vc = [[resultViewController alloc]init];
                  [self.navigationController pushViewController:vc animated:YES];
              }
              
          }else{
              
              [AppDelegate show:message];
          }
      }];
    
    
   
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
