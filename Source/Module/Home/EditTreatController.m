//
//  EditTreatController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/3.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "EditTreatController.h"
#import "ShareUserData.h"
#import "ShareData.h"
#import "EditVIewModel.h"
#import "WRUserInfo.h"
#import "AppDelegate+WR.h"
#import <YYKit/YYKit.h>
@interface EditTreatController ()<UIAlertViewDelegate>
@property UIButton* editBtn;
//@property NSMutableArray* arrrehad;
@property (nonatomic)EditVIewModel* viewModel;
@property (nonatomic)WRRehab* rehab;
@property NSIndexPath* index;
@end

@implementation EditTreatController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    self.title  =@"方案编辑";
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(self.view.frame.size.width-60, 25, 50, 34);
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitle:@"完成" forState:UIControlStateSelected];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _editBtn.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5];
    [_editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
   
    
    self.viewModel = [EditVIewModel new];

    [self.tableView reloadData];
    
    BOOL flag = !self.tableView.editing;
    self.tableView.editing = YES;
    
    _editBtn.selected = flag;
    self.tableView.allowsMultipleSelectionDuringEditing =NO;
    self.tableView.tableFooterView = [UIView new];
//    self.tableView.allowsMultipleSelection = NO;
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idGood = @"goods";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idGood];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idGood];
    }
    WRRehab* re =self.dataarr [indexPath.row ];
    cell.textLabel.text =[NSString stringWithFormat:@"%@",re.disease.diseaseName];
    cell.detailTextLabel.numberOfLines = 6;
    cell.detailTextLabel.textColor = [UIColor brownColor];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (IBAction)clickEditBtn:(UIButton *)sender {
    
    //设置tableview编辑状态
    
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 取出要拖动的模型数据
     WRRehab* re =self.dataarr[sourceIndexPath.row ];
    [self.dataarr removeObject:re];
    [self.dataarr insertObject:re atIndex:destinationIndexPath.row];
    
    
    [self.tableView reloadData];
    //本地处理排序
    NSMutableArray* arr = [NSMutableArray array];
    for (WRRehab* rehab in self.dataarr ) {
        [arr addObject:rehab.indexId];
        
    }
    
    
    
    
    [AppDelegate show:@"排序成功"];
    
    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"rehab"];
    
    
//    NSMutableDictionary * data = [NSMutableDictionary dictionary];
//    NSMutableDictionary * dic  = [NSMutableDictionary dictionary];
//    int i=0;
//    for (WRRehab* re in  self.arrrehad ) {
//        [dic setObject:[NSNumber numberWithInt:i] forKey:re.indexId];
//        i++;
//    }
//    NSLog(@"%@",[dic modelToJSONString]);
//    data[@"map"]= dic;
//    data[@"userId"] = [WRUserInfo  selfInfo].userId;
//    
//    
//    
//    
//    [self.viewModel fetchEditRehabWithMap:[data modelToJSONString]  completion:^(NSError * _Nonnull error) {
//        
//    }];
    
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRRehab* re =self.dataarr [indexPath.row ];
    if (re.disease.isProTreat||re.isSelfRehab) {
        UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"定制方案和自建方案暂时不支持删除功能？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        self.rehab = re;
        self.index = indexPath;
        [al show];
    }
   else
   {
       
       
       [self.viewModel fetchDeleRehabWithRehabid:re.indexId completion:^(NSError * _Nonnull error) {
           if (!error) {
               [AppDelegate show:@"方案已经删除"];
               [self.dataarr removeObject:re];
               [self.tableView deleteRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
               if ([WRUserInfo selfInfo].isLogged) {
                   [ [NSNotificationCenter defaultCenter]postNotificationName:WRLogInNotification object:nil];
               }
               else
               {
                   [ [NSNotificationCenter defaultCenter]postNotificationName:WRLogOffNotification object:nil];
               }
           }
       }];
   }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        
        [self.viewModel fetchDeleRehabWithRehabid:self.rehab.indexId completion:^(NSError * _Nonnull error) {
            if (!error) {
                [AppDelegate show:@"方案已经删除"];
                [self.dataarr removeObject:self.rehab];
                [self.tableView deleteRow:_index.row inSection:_index.section withRowAnimation:UITableViewRowAnimationFade];
                if ([WRUserInfo selfInfo].isLogged) {
                    [ [NSNotificationCenter defaultCenter]postNotificationName:WRLogInNotification object:nil];
                }
                else
                {
                    
                    [ [NSNotificationCenter defaultCenter]postNotificationName:WRLogOffNotification object:nil];
                }
            }
        }];
        
    }

}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRRehab* re =self.dataarr [indexPath.row ];
    if ([re.disease isProTreat]) {
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
