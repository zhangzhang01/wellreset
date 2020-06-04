//
//  singleSelectViewController.m
//  rehab
//
//  Created by matech on 2019/12/17.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "singleSelectViewController.h"
#import "selectSingleTableViewCell.h"
#import "reportViewModel.h"
@interface singleSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentIndex;
}
@property UITableView* mytableview;
@property(nonatomic,strong)UILabel* countText;
@property(nonatomic, copy)NSMutableArray *selectedsSelectArray;
@end

@implementation singleSelectViewController
- (NSMutableArray *)selectedUserArray {

    if (!_selectedsSelectArray) {
        _selectedsSelectArray = [NSMutableArray array];
    }
    return _selectedsSelectArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedsSelectArray = [NSMutableArray array];
      UIImageView *imageView = [[UIImageView alloc] init];
          imageView.frame = CGRectMake(0, 0, ScreenW , SCREEN_HEIGHT-64);
           imageView.image = IMAGE(@"问卷答题背景");
      [self.view addSubview:imageView];
      UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(ScreenW/2-50, 0, 100, 40)];;
    
    UILabel* count = [[UILabel alloc]init];
           count.x = ScreenW/2-50;
           count.y = 0;
           count.textColor = [UIColor lightGrayColor];
           count.font = [UIFont systemFontOfSize:18];
    //       count.text =[NSString stringWithFormat:@"1/14"] ;
           count.width = 100;
           count.height = 40;
           count.textAlignment = NSTextAlignmentCenter;
           self.countText = count;
           self.navigationItem.titleView = count;
    
    [self createLeftBarButtonItem];
    
       _mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, SCREEN_HEIGHT-200) style:UITableViewStylePlain];
       [self.view addSubview:_mytableview];
       self.mytableview.delegate = self;
       self.mytableview.dataSource = self;
       self.mytableview.backgroundColor = [UIColor clearColor];
       self.mytableview.tableFooterView = [[UIView alloc] init];
       self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}
-(void)createLeftBarButtonItem {
    NSLog(@"????");
    
    
   UIButton *LeftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 47)];
    [LeftButton setTitleColor:[UIColor wr_themeColor] forState:UIControlStateNormal];
     [LeftButton setTitle:@"返回" forState:UIControlStateNormal];
    [LeftButton addTarget:self action:@selector(onClickedbackQuesButton:) forControlEvents:UIControlEventTouchUpInside];
   
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:LeftButton];
    self.navigationItem.leftBarButtonItem = item;
    
}
-(void)onClickedbackQuesButton:(UIButton *)button
{
    if (self.backClick) {
        self.backClick(self.detailArray2);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

   NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/%ld",self.index,self.detailArray2.count]];
   NSRange strRange = {0,1};
   [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
   [str addAttribute:NSForegroundColorAttributeName value:[UIColor wr_themeColor] range:strRange];
   [self.countText setAttributedText:str];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 90)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, ScreenW , 60);
         imageView.image = IMAGE(@"问卷标题背景");
    [view addSubview:imageView];

    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenW-90, 60)];
    nameLabel.font = FONT_16;
    nameLabel.textColor = [UIColor blackColor];
//    nameLabel.text = model.symptomName;
    [view addSubview:nameLabel];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, MaxY(nameLabel), ScreenW-90, 30)];
    titleLabel.font = FONT_16;
    titleLabel.textColor = [UIColor blackColor];
    reportModel *questionmodel =self.secondArray2[self.index];
    titleLabel.text =questionmodel.issueName ;
    [view addSubview:titleLabel];
    
    
    for (NSInteger i = 0 ; i < _titleArray2.count; i ++) {
              reportViewModel *model = _titleArray2[i];
               reportModel *model2 = self.secondArray2[self.index];
              if ([model.objectArray containsObject:model2]) {
                  nameLabel.text =[NSString stringWithFormat:@"%@",model.symptomName] ;
              }
          }
    
    
    UIButton* questionButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-70, MaxY(nameLabel)-10, 40, 40)];
    //    [clearButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
        [questionButton addTarget:self action:@selector(questionButton:) forControlEvents:UIControlEventTouchUpInside];
        questionButton.layer.cornerRadius = 15.0;
        questionButton.layer.masksToBounds = YES;
    questionButton.hidden = YES;
    reportModel *model2 = self.secondArray2[self.index];
      [questionButton setImage:IMAGE(@"说明图标-1") forState:UIControlStateNormal];
    if ([model2.isTrue isEqualToString:@"1"]) {
        questionButton.hidden = NO;
    }
        [view addSubview:questionButton];

    return view;



}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 90;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    reportModel *reportModel = self.secondArray2[self.index];
    
    return reportModel.SecondobjectArray.count;


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
         // 定义唯一标识
                reportModel *Model = self.secondArray2[self.index];
                 questionModel *quesModel = Model.SecondobjectArray[indexPath.row];
                static NSString *CellIdentifier = @"Cell2";
                selectSingleTableViewCell* cell=[[selectSingleTableViewCell alloc]init];
                if (!cell) {
                    cell=[[selectSingleTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

                }
  
                [cell setModelValue:quesModel];
                [cell.collectbutton10 setImage:IMAGE(@"选择默认") forState:UIControlStateNormal];
                       
                [cell.collectbutton10 setImage:IMAGE(@"选中圈状态") forState:UIControlStateSelected];
             
    
    
                 if ([self.selectedsSelectArray containsObject:quesModel]) {
                     cell.collectbutton10.selected = YES;
                 }else
                 {
                     cell.collectbutton10.selected = NO;;
                 }
                if ([self.detailArray2 containsObject:quesModel]) {
                                 cell.collectbutton10.selected = YES;
                    }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [self.selectedsSelectArray removeAllObjects];
    reportModel *selectModel2 = self.secondArray2[_index];
     questionModel *quesitionModel = selectModel2.SecondobjectArray[indexPath.row];
    [self.detailArray2 replaceObjectAtIndex:_index withObject:quesitionModel];
    [self.selectedsSelectArray addObject:quesitionModel];
    [_mytableview reloadData];
    
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
