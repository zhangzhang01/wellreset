//
//  CreatTreatController.m
//  rehab
//
//  Created by yongen zhou on 2017/11/16.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "CreatTreatController.h"
#import "StageFavorListController.h"
#import "TreatNameController.h"
#import "JCAlertView.h"
@interface CreatTreatController ()
@property UIButton* editBtn;
//@property NSMutableArray* arrrehad;
@property (nonatomic)WRRehab* rehab;
@property NSIndexPath* index;
@property NSMutableArray* resultarry;
@property UIButton* next;
@end

@implementation CreatTreatController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    if ([[ud objectForKey:@"creatTreatShowIntro"]intValue]!=1)
    {
        [JCAlertView showOneButtonWithTitle:nil Message:@"自定义方案是在自己收藏的动作中,自由选取动作来组成新的方案\n建议\n1.可以选取自己做起来觉得舒服的动作;\n2.避免所选动作均为高强度动作,应注意高低结合,可将低强度的拉伸与高强度的强化运动结合\n3.新建方案时常不宜超过30分钟" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"确定" Click:^{
            
        }];
        [ud setObject:@"1" forKey:@"creatTreatShowIntro"];
    }
    
    
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message: preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alertController addAction:actionCancel];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    
    self.title  =@"动作编辑";
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(self.view.frame.size.width-60, 25, 50, 34);
    [_editBtn setImage:[UIImage imageNamed:@"问号"] forState:0];
   
    UIBarButtonItem* by  =[[UIBarButtonItem alloc]initWithCustomView:_editBtn];
    self.navigationItem.rightBarButtonItem = by;
    [_editBtn bk_whenTapped:^{
        [JCAlertView showOneButtonWithTitle:nil Message:@"自定义方案是在自己收藏的动作中,自由选取动作来组成新的方案\n建议\n1.可以选取自己做起来觉得舒服的动作;\n2.避免所选动作均为高强度动作,应注意高低结合,可将低强度的拉伸与高强度的强化运动结合\n3.新建方案时常不宜超过30分钟" ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"确定" Click:^{
            
        }];
    }];
    
    
  
    
    [self.tableView reloadData];
    
    self.tableView.editing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing =NO;
    self.resultarry = [NSMutableArray array];
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 60+57)];
    UIButton* btn = [UIButton new];
    btn.y = 9;
    
    btn.width = 184;
    btn.height = 43;
    btn.centerX = ScreenW*1.0/2;
    [btn setTitle:@"+ 添加动作" forState:0];
    [btn setTitleColor:[UIColor wr_themeColor] forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 43.f/2;
    btn.layer.borderColor = [UIColor wr_themeColor].CGColor;
    btn.layer.borderWidth = 1;
    [v addSubview:btn];
    [btn bk_whenTapped:^{
        
        StageFavorListController* vc= [StageFavorListController new];
        [self.choosearry removeAllObjects];
        vc.chooes = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    
    self.tableView.tableFooterView = v;
    
    btn = [[UIButton alloc]initWithFrame:CGRectMake(0,YYScreenSize().height-57-64, ScreenW, 57)];
    [btn setTitle:@"下一步" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.backgroundColor = [UIColor wr_themeColor];
    
    [self.view addSubview:btn];
    
    
    
    [btn bk_whenTapped:^{
        if (self.resultarry.count>0) {
            TreatNameController* name = [TreatNameController new];
            name.arry = self.resultarry;
            name.indexid = self.indexid;
            name.namel = self.name;
            [self.navigationController pushViewController:name animated:YES];
        }
        else
        {
            [AppDelegate show:@"至少选择一个动作"];
        }
       
    }];
    
    self.next = btn;
    //    self.tableView.allowsMultipleSelection = NO;
    // Do any additional setup after loading the view.
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.next.frame = CGRectMake(0, YYScreenSize().height-57-64 +scrollView.contentOffset.y, ScreenW, 57);
}
-(void)viewWillAppear:(BOOL)animated
{
    if (self.isadd) {
        [self.resultarry addObjectsFromArray:self.choosearry];
        self.isadd = NO;
        [self.choosearry removeAllObjects];
        [self.tableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultarry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idGood = @"goods";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idGood];
  
    
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idGood];
            
            if (indexPath.row==0) {
                CGSize s =  self.tableView.contentSize;
                s.height+=57;
                
                self.tableView.contentSize =s;
                
            }
            
        }
    
    
    
    id object = self.resultarry[indexPath.row];
    FavorContent *content = object;
    WRTreatRehabStage *stage = (WRTreatRehabStage*)content.collectContent;
    
    
        cell.textLabel.text =[NSString stringWithFormat:@"%@",stage.mtWellVideoInfo.videoName];
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
    FavorContent* re =self.resultarry[sourceIndexPath.row ];
    [self.resultarry removeObject:re];
    [self.resultarry insertObject:re atIndex:destinationIndexPath.row];
    
    
    [self.tableView reloadData];
    //本地处理排序
   
    
    
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
    FavorContent* re =self.resultarry [indexPath.row ];
    

    
                [self.resultarry removeObject:re];
    [self.tableView deleteRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
    
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
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
