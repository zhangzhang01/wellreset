//
//  resultViewController.m
//  rehab
//
//  Created by matech on 2019/11/14.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "resultViewController.h"
#import "rehab-Bridging-Header.h"
#import "BarChartsHelper.h"
#import "firstQuesTableViewCell.h"
#import "secondQuesTableViewCell.h"
#import "thridQuesTableViewCell.h"
#import "ComulitModel.h"
#import "fourTableViewCell.h"
@interface resultViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL select;
    BOOL change1;
    BOOL change2;
}
@property ComulitModel* viewModel;
@property UITableView* mytableview;
@property (nonatomic, strong) NSMutableArray *xVals3;
@property (nonatomic, strong) LineChartView *lineChartView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, weak) CombinedChartView *combineChartView2;
@property (nonatomic, strong) NSMutableArray *joaArr;
@property (nonatomic, strong) NSMutableArray *odiArr;
@property (nonatomic, strong) NSMutableArray *improArr;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSDictionary *data2Dic;
@property (nonatomic, strong) resultModel *relust;
@end

@implementation resultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问卷结果";
    self.joaArr = [NSMutableArray array];
    self.odiArr = [NSMutableArray array];
    self.improArr = [NSMutableArray array];
    self.dataDic = [NSMutableDictionary dictionary];
    self.data2Dic = [NSMutableDictionary dictionary];
    [self.dataDic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",0]];
    [self.data2Dic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",0]];
    select = NO;
    change1 = YES;
    change2 = YES;
    UIButton* clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 47)];
    [clearButton setTitleColor:COLOR_grayColor forState:UIControlStateNormal];
     [clearButton setTitle:@"退出" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    clearButton.hidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.hidesBackButton = YES;
    _mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [self.view addSubview:_mytableview];
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    self.mytableview.backgroundColor = COLOR(240, 243, 245, 1);;
    self.mytableview.tableFooterView = [[UIView alloc] init];
    self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.viewModel = [ComulitModel new];
    [self getInfo];
}
-(void)backButton:(UIButton *)button
{
     [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)getInfo
{
    [self.viewModel submitresultWithuserId:[WRUserInfo selfInfo].userId withpartCode:@"0" block:^(bool success, resultModel *model) {
        if (success == YES) {
            self.relust = model;
            
            for (NSInteger i = 0 ; i < self.relust.JOAArray.count; i ++) {
                reportModel *joaModel = self.relust.JOAArray[i];
                [self.joaArr addObject:joaModel.grade];
                [self.improArr addObject:joaModel.improvement];
            }
            
            for (NSInteger i = 0 ; i < self.relust.ODIArray.count; i ++) {
                questionModel *odiModel = self.relust.ODIArray[i];
                [self.odiArr addObject:odiModel.grade];
               
            }
            
            
            [_mytableview reloadData];
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 130;
    }if (indexPath.section == 1) {
        return 380;
    }if (indexPath.section == 3) {
        return 380;
    }else
    {
        
        if (indexPath.section == 2) {
             if ([[self.dataDic valueForKey:[NSString stringWithFormat:@"%d",0]]isEqualToString:@"0"] ) {
                return 0.01;
            }else{
               return 660;
            }
        }
             else{
                 if ([[self.data2Dic valueForKey:[NSString stringWithFormat:@"%d",0]]isEqualToString:@"0"] ){
                   return 0.01;
               }else{
                  return 590;
    }

        }
        
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    if (section == 2 || section == 4 ) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
               view.backgroundColor = [UIColor whiteColor];
               
               UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenW-90, 60)];
               nameLabel.font = FONT_18;
               nameLabel.textColor = [UIColor blackColor];
               if (section == 2) {
                   nameLabel.text = @"ODI评分说明";
               }else{
                    nameLabel.text = @"JOA评分说明";
               }
              
               [view addSubview:nameLabel];
               

               UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
               selectBtn.frame = CGRectMake(0, 0, ScreenW, 60);
               [selectBtn addTarget:self action:@selector(imgVClick2:) forControlEvents:UIControlEventTouchUpInside];
               selectBtn.tag = section;
               [view  addSubview:selectBtn];
               
                UIImageView *imageV = [[UIImageView alloc]init];
               imageV.frame = CGRectMake(ScreenW-40, 20, 20, 20);
          [view addSubview:imageV];
        if (section == 2) {
            if ([[self.dataDic valueForKey:[NSString stringWithFormat:@"%d",0]]isEqualToString:@"0"] )
                              {
                                 
                                 imageV.image = IMAGE(@"收起");
                                  change1 =  YES;
                              }else
                          {
                               imageV.image = IMAGE(@"展开");
                              change1 = NO;
                          }
        }else{
            if ([[self.data2Dic valueForKey:[NSString stringWithFormat:@"%d",0]]isEqualToString:@"0"] )
                {
                   
                   imageV.image = IMAGE(@"收起");
                    change2 = YES;
                }else
            {
                  imageV.image = IMAGE(@"展开");
                  change2 = NO;
            }
        }
              
             
               
               
               
               return view;
    }else{
        
        return nil;
    }
       
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2||section ==4) {
        return 60;
    }else{
        return 0.01;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2 ) {
        if ([[self.dataDic valueForKey:[NSString stringWithFormat:@"%d",0]]isEqualToString:@"0"] ){
            return 0;
        }else{
            return 1;
        }
    }if (section == 4) {
        if ([[self.data2Dic valueForKey:[NSString stringWithFormat:@"%d",0]]isEqualToString:@"0"] ){
                  return 0;
              }else{
                  return 1;
              }
    }else{
        
        return 1;
    }
   
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"Cell2";
        firstQuesTableViewCell* cell=[[firstQuesTableViewCell alloc]init];
        if (!cell) {
            cell=[[firstQuesTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel];
        cell.backgroundColor = COLOR(240, 243, 245, 1);
        return cell;
    }if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"Cell2";
               secondQuesTableViewCell* cell=[[secondQuesTableViewCell alloc]init];
               if (!cell) {
                   cell=[[secondQuesTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

               }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.odiArr.count>0) {
         
            
            [cell setDataWithDataWithODIarr:self.odiArr withODIarr:self.odiArr withchangeArr:self.improArr];
        }
        
        cell.backgroundColor = COLOR(240, 243, 245, 1);
               return cell;
    }if (indexPath.section == 3) {
        static NSString *CellIdentifier = @"Cell3";
               fourTableViewCell* cell=[[fourTableViewCell alloc]init];
               if (!cell) {
                   cell=[[fourTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

               }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.joaArr.count>0) {
            [cell setDataWithDataWithJOAarr:self.joaArr withODIarr:self.joaArr withchangeArr:self.improArr];
           
        }
        
        cell.backgroundColor = COLOR(240, 243, 245, 1);
               return cell;
    }
    else{
        static NSString *CellIdentifier = @"Cell4";
               thridQuesTableViewCell* cell=[[thridQuesTableViewCell alloc]init];
               if (!cell) {
                   cell=[[thridQuesTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

               }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 2) {
            cell.pictView.image = IMAGE(@"ODI评分-1");
           
             if ([[self.dataDic valueForKey:[NSString stringWithFormat:@"%d",0]]isEqualToString:@"0"] ) {
                cell.pictView.hidden = YES;
            }else{
                cell.pictView.hidden = NO;
            }
            
            [cell setHightWithIndex:indexPath.section];
        }if (indexPath.section == 4)
            
        {
           
            cell.pictView.image = IMAGE(@"JOA评分说明");
             if ([[self.data2Dic valueForKey:[NSString stringWithFormat:@"%d",0]]isEqualToString:@"0"] ) {
                cell.pictView.hidden = YES;
            }else{
                cell.pictView.hidden = NO;
            }
        }
        [cell setHightWithIndex:indexPath.section];
        cell.backgroundColor = COLOR(240, 243, 245, 1);
               return cell;
    }
    
}
-(void)imgVClick2:(UIButton *)Btn{
   
    if (Btn.tag == 2) {
        if ([[self.dataDic valueForKey:[NSString stringWithFormat:@"%d",0]]isEqualToString:@"0"] )
             {
                
                 [self.dataDic setValue:@"1" forKey:@"0"];
             }else
         {
              [self.dataDic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",0]];
         }
          
           [_mytableview reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
    }if (Btn.tag == 4) {
        if ([[self.data2Dic valueForKey:[NSString stringWithFormat:@"%d",0]]isEqualToString:@"0"] )
                    {
                       
                        [self.data2Dic setValue:@"1" forKey:@"0"];
                        
                    }else
                {
                     [self.data2Dic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",0]];
                }
                 
                  [_mytableview reloadSection:4 withRowAnimation:UITableViewRowAnimationFade];
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
