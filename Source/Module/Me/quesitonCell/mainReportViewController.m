//
//  mainReportViewController.m
//  rehab
//
//  Created by yefangyang on 2019/3/7.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "mainReportViewController.h"
//#import "MQGradientProgressView.h"
//#import "reportDetailSlideTableViewCell.h"
//#import "reportSelectTableViewCell.h"
#import "selectSingleTableViewCell.h"
//#import "textFTableViewCell.h"
//#import "WRImagePicker.h"
//#import "XHImageViewer.h"
//#import "reportViewModel.h"
#import "JCAlertView.h"
#import "ComulitModel.h"
#import "reportViewModel.h"
#import "questionResultViewController.h"
@interface mainReportViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentIndex;
    NSInteger tableIndex;
    NSInteger secondIndex;
    CGFloat value;
//    MQGradientProgressView *progressView;
    NSInteger totalValue;
    NSArray *arr;
    NSArray *items;
    NSInteger item;
    UIButton *clearButton;
    BOOL changeIndex;
    CGFloat imageHeight;
    UIButton* LeftButton;
    UIButton *offerButton;
}
@property UITableView* mytableview;
//@property (nonatomic,strong)NSMutableArray*imageArray;
@property (nonatomic,strong)NSMutableArray*uiimageArr;
@property (nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,strong)UILabel* countText;
@property(nonatomic,strong)UIButton* endBtn;
@property(nonatomic, copy)NSMutableArray *selectedsSelectArray;
@property(nonatomic, copy)NSMutableArray *secondSelectArray;
@property(nonatomic, copy)NSMutableArray *alreadyArr;
@property(nonatomic, copy)NSMutableArray *titleArr;
@property ComulitModel* viewModel;
@property(nonatomic,strong)NSMutableDictionary *dataDict;
@property(nonatomic,strong)NSMutableDictionary *buttonDict;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newheight;
@end

@implementation mainReportViewController
- (NSMutableArray *)selectedUserArray {

    if (!_selectedsSelectArray) {
        _selectedsSelectArray = [NSMutableArray array];
    }
    return _selectedsSelectArray;
}

- (NSMutableArray *)secondSelectArray {

    if (!_secondSelectArray) {
        _secondSelectArray = [NSMutableArray array];
    }
    return _secondSelectArray;
}
- (NSMutableArray *)alreadyArr {

    if (!_alreadyArr) {
        _alreadyArr = [NSMutableArray array];
    }
    return _alreadyArr;
}
- (NSMutableArray *)titleArr {

    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, ScreenW , SCREEN_HEIGHT-64);
         imageView.image = IMAGE(@"问卷答题背景");
    [self.view addSubview:imageView];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(ScreenW/2-50, 0, 100, 40)];;
    currentIndex = 1;
    secondIndex = 0;
    tableIndex = 0;
    totalValue = 0;
    [self.navigationItem setHidesBackButton:YES];
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
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:count.text];
//       NSRange strRange = {0,1};
//       [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
//       [str addAttribute:NSForegroundColorAttributeName value:[UIColor wr_themeColor] range:strRange];
//       [count setAttributedText:str];
//    [titleView addSubview:count];
    self.navigationItem.titleView = count;
 
    
//    self.dataDict = [NSMutableDictionary dictionary];
//    changeIndex = NO;
//    items = @[@"lg-text", @"single-select", @"_multi", @"multi-select", @"text", @"date"];
//    item = [items indexOfObject:@"lg-text"];

//    tableIndex = 1;
    _selectedsSelectArray = [NSMutableArray array];
    _secondSelectArray = [NSMutableArray array];
    _alreadyArr = [NSMutableArray array];
    _titleArr = [NSMutableArray array];
    [self createBackBarButtonItem];
    [self createLeftBarButtonItem];
    self.viewModel = [ComulitModel new];
    [self getInfo];

    _mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, SCREEN_HEIGHT-200) style:UITableViewStylePlain];
    [self.view addSubview:_mytableview];
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    self.mytableview.backgroundColor = [UIColor clearColor];
    self.mytableview.tableFooterView = [[UIView alloc] init];
        self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        offerButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT-180, ScreenW-30, 60)];
    //    [clearButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
        [offerButton addTarget:self action:@selector(onClickedofferButton:) forControlEvents:UIControlEventTouchUpInside];
        offerButton.layer.cornerRadius = 20.0;
        offerButton.layer.masksToBounds = YES;
        offerButton.hidden = YES;
        offerButton.backgroundColor = COLOR(140, 211, 251, 1);
        [offerButton setTitle:@"提交问卷" forState:UIControlStateNormal];
        [offerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:offerButton];
    
}
-(void)createBackBarButtonItem {
    NSLog(@"????");
    
    
    clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 47)];
    [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [clearButton setTitle:@"退出" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(onClickedBackButton:) forControlEvents:UIControlEventTouchUpInside];
    clearButton.hidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    self.navigationItem.rightBarButtonItem = item;
    
    
//   UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 47)];
//       [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [backButton setTitle:@"退出" forState:UIControlStateNormal];
//       [backButton addTarget:self action:@selector(onClickedBackButton:) forControlEvents:UIControlEventTouchUpInside];
//       backButton.hidden = NO;
//       UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//       self.navigationItem.leftBarButtonItem = item;
    
}
-(void)createLeftBarButtonItem {
    NSLog(@"????");
    
    
    LeftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 47)];
    [LeftButton setTitleColor:[UIColor wr_themeColor] forState:UIControlStateNormal];
     [LeftButton setTitle:@"上一题" forState:UIControlStateNormal];
    [LeftButton addTarget:self action:@selector(onClickedbackButton:) forControlEvents:UIControlEventTouchUpInside];
    LeftButton.hidden = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:LeftButton];
    self.navigationItem.leftBarButtonItem = item;
    
}
- (void)extracted {
    [self.viewModel getreportuserId:[WRUserInfo selfInfo].userId  region:@"WAIST" tag:self.tag block:^(bool success, NSMutableArray *blockArray) {
        if (success == YES) {
            self.dataArr = blockArray;
            //            reportModel *repMpdel = self.dataArr[0];
            for (NSInteger i = 0 ; i < self.dataArr.count; i ++) {
                reportViewModel *model = self.dataArr[i];
                for (NSInteger j = 0 ; j < model.objectArray.count ; j++) {
                    reportModel *model2 = model.objectArray[j];
                    [_secondSelectArray addObject:model2];
                    totalValue++;
                }
                
                
            }
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"1/%ld",(long)totalValue]];
            NSRange strRange = {0,1};
            [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor wr_themeColor] range:strRange];
            [self.countText setAttributedText:str];
            //            self.countText.text = [NSString stringWithFormat:@"1/%ld",(long)totalValue];
            [_mytableview reloadData];
        }
        
        //                    [self.dataArr  addObjectsFromArray:self.viewModel.reportArr.copy];
        //                    if (self.viewModel.reportArr.count>0) {
        //
        //                        [self.mytableview reloadData];
        //                    }
        
        
    }];
}

-(void)getInfo
{
    

    [self extracted];


    
    
}


// 添加选择
//- (void)addUserDicToUsers:(questionModel *)userDic {
//    [self.selectedsSelectArray addObject:userDic];
//    NSLog(@"%@",self.selectedsSelectArray);
//    NSLog(@"1");
//    [_mytableview reloadData];
//}
//
//// 删除选择
//- (void)deleteUserDicFromUsers:(questionModel *)userDic {
//    [self.selectedsSelectArray removeObject:userDic];
//    NSLog(@"%@",self.selectedsSelectArray);
//    NSLog(@"0");
//    [_mytableview reloadData];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    reportViewModel *model = self.dataArr[tableIndex];
    reportModel *model2 = model.objectArray[secondIndex];
    UIView *view = [[UIView alloc]init];;
  
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 110)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, ScreenW , 60);
         imageView.image = IMAGE(@"问卷标题背景");
    [view addSubview:imageView];

    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenW-90, 60)];
    nameLabel.font = FONT_16;
    nameLabel.textColor = [UIColor whiteColor];
    
    [view addSubview:nameLabel];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, MaxY(nameLabel), ScreenW-90, 50)];
    titleLabel.font = FONT_16;
    titleLabel.textColor = [UIColor blackColor];
    
    [view addSubview:titleLabel];
    
    if ([self.tag isEqualToString:@"1"]) {
         view.frame=CGRectMake(0, 0, ScreenW, 60);
        titleLabel.hidden = YES;
        nameLabel.text = model2.issueName;
      }else{
          
         view.frame=CGRectMake(0, 0, ScreenW, 110);
          titleLabel.hidden = NO;;
          nameLabel.text = model.symptomName;
          titleLabel.text = model2.issueName;
      }
    
    UIButton* questionButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-70, MaxY(nameLabel)+10, 50, 50)];
    //    [clearButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
        [questionButton addTarget:self action:@selector(questionButton:) forControlEvents:UIControlEventTouchUpInside];
        questionButton.layer.cornerRadius = 15.0;
        questionButton.layer.masksToBounds = YES;
    questionButton.hidden = YES;
      [questionButton setImage:IMAGE(@"说明图标-1") forState:UIControlStateNormal];
    if ([model2.isTrue isEqualToString:@"1"]) {
        questionButton.hidden = NO;
    }
        [view addSubview:questionButton];

    return view;



}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.tag isEqualToString:@"1"]) {
        return 60;
    }else{
       return 110;
    }
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    reportViewModel *model = self.dataArr[tableIndex];
    reportModel *reportModel = model.objectArray[secondIndex];

    return reportModel.SecondobjectArray.count;


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//
    reportViewModel *model = self.dataArr[tableIndex];
    reportModel *reportModel = model.objectArray[secondIndex];
    questionModel *questionModel = reportModel.SecondobjectArray[indexPath.row];
//            // 定义唯一标识
            static NSString *CellIdentifier = @"Cell2";
            selectSingleTableViewCell* cell=[[selectSingleTableViewCell alloc]init];
            if (!cell) {
                cell=[[selectSingleTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

            }

            [cell setModelValue:questionModel];
            [cell.collectbutton10 setImage:IMAGE(@"选择默认") forState:UIControlStateNormal];
                   
            [cell.collectbutton10 setImage:IMAGE(@"选中圈状态") forState:UIControlStateSelected];

             if ([self.selectedsSelectArray containsObject:questionModel]) {
                 cell.collectbutton10.selected = YES;
                 cell.titleLabel.textColor = kBlue;
             }else
             {
                 cell.collectbutton10.selected = NO;;
             }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      reportViewModel *model7 = self.dataArr[tableIndex];
     reportModel *selectModel2 = model7.objectArray[secondIndex];
    questionModel *quesitionModel = selectModel2.SecondobjectArray[indexPath.row];
   
    if (![_titleArr containsObject:model7]) {
        [_titleArr addObject:model7];
    }
    
    
    if (![_alreadyArr containsObject:selectModel2]) {
        [_alreadyArr addObject:selectModel2];
        [self.selectedsSelectArray addObject:quesitionModel];
    }else
    {
        [self.selectedsSelectArray replaceObjectAtIndex:currentIndex-1 withObject:quesitionModel];
        
    }
   
       NSLog(@"%@",self.selectedsSelectArray);
    //显示用
    currentIndex++;
    if (currentIndex == totalValue+1) {
        currentIndex = totalValue;
       
//        [AppDelegate show:@"已经最后一页啦。。"];
        [_mytableview reloadData];
        
        
        offerButton.hidden = NO;
        
       questionResultViewController *vc = [[questionResultViewController alloc]init];
        vc.titleArray =self.titleArr;
        vc.secondArray = self.alreadyArr;
        vc.detailArray = self.selectedsSelectArray;
        vc.tagStr = self.tag;
        [self.navigationController pushViewController:vc animated:YES];
       
     
    }
   
    

     secondIndex++;
    NSLog(@"%ld",(long)secondIndex);
    
      reportViewModel *model = self.dataArr[tableIndex];
    if (secondIndex == model.objectArray.count) {
        secondIndex = 0;
        if (tableIndex < self.dataArr.count-1) {
            tableIndex++;
            
           if (tableIndex == self.dataArr.count-1) {
                tableIndex =self.dataArr.count-1;
            }
        }

 
    }
    
//     reportModel *reportModel = model.objectArray[secondIndex];
//     questionModel *questionModel = reportModel.SecondobjectArray[indexPath.row];

    
    //title变化方法
    NSLog(@"%ld---%lu--%ld",(long)tableIndex,(unsigned long)model.objectArray.count,(long)secondIndex);
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/%ld",(long)currentIndex,(long)totalValue]];
    if (currentIndex>1) {
         [self.navigationItem setHidesBackButton:NO];
        LeftButton.hidden = NO;
    }else{
        [self.navigationItem setHidesBackButton:YES];
        LeftButton.hidden = YES;
    }
           
    if (currentIndex>9) {
        NSRange strRange = {0,2};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
                  [str addAttribute:NSForegroundColorAttributeName value:[UIColor wr_themeColor] range:strRange];
                  [self.countText setAttributedText:str];
    }else{
        
        NSRange strRange = {0,1};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
                  [str addAttribute:NSForegroundColorAttributeName value:[UIColor wr_themeColor] range:strRange];
                  [self.countText setAttributedText:str];
    }
          

    
           
        [_mytableview reloadData];
    
       //动画
              CATransition * animation = [CATransition animation];
              animation.type = kCATransitionReveal;  //动画切换风格
              animation.subtype = kCATransitionFromRight; //动画切换方向
              animation.duration = 0.3f;
             

              [_mytableview.layer addAnimation:animation forKey:nil];
   
            
           
    
}
-(void)questionButton:(UIButton *)button
{
    reportViewModel *model = self.dataArr[tableIndex];
       reportModel *model2 = model.objectArray[secondIndex];
   UIView* view = [UIView new];
   view.frame = CGRectMake(0, 0, ScreenW-80, 500);
    view.layer.cornerRadius = 10.0;
    view.layer.masksToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, ScreenW-80 , 500);
         imageView.image = IMAGE(@"第四题（直腿抬高试验）说明弹窗");
    [view addSubview:imageView];
    
    
    UITextView * text = [[UITextView alloc]initWithFrame:CGRectMake(10, 80, ScreenW-100, 250)];
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithData:[model2.issDesc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
      [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, string.length)];
       [string setLineSpacing:3];
    text.userInteractionEnabled = NO;
    text.attributedText = string;
//    text.frame = CGRectMake(10, 80, ScreenW-100, string.length);
    text.layer.cornerRadius = 10.0;
    
    text.layer.masksToBounds = YES;
//    text.text = @"kjdhflasjfasflasjdhalsdfj;asdf;lasflasdf;askd;avadhasfja'sdfjasldfj";
    [imageView addSubview:text];
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
          imageView2.frame = CGRectMake(10, 320,WIDTH(view)-20 , 170);
           [imageView2 sd_setImageWithURL:[NSURL URLWithString:model2.issFile] placeholderImage:IMAGE(@"")];
      [view addSubview:imageView2];
    
    
    
    
    JCAlertView* jc = [[JCAlertView alloc]initWithCustomView:view dismissWhenTouchedBackground:YES];
    [jc show];
    
        
    
}
- (void)dismissWithCompletion:(void(^)(void))completion{
    
}
-(void)onClickedbackButton:(UIButton *)button
{
    //标题
    offerButton.hidden = YES;
       currentIndex--;
       
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/%ld",(long)currentIndex,(long)totalValue]];
       if (currentIndex>1) {
            [self.navigationItem setHidesBackButton:NO];
           LeftButton.hidden = NO;
       }else{
           [self.navigationItem setHidesBackButton:YES];
           LeftButton.hidden = YES;
       }
    if (currentIndex<10) {
        NSRange strRange = {0,1};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
                  [str addAttribute:NSForegroundColorAttributeName value:[UIColor wr_themeColor] range:strRange];
        [self.countText setAttributedText:str];
    }else
    {
        NSRange strRange = {0,2};
               [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
                         [str addAttribute:NSForegroundColorAttributeName value:[UIColor wr_themeColor] range:strRange];
        [self.countText setAttributedText:str];
        
    }
    
    //选择逻辑
    secondIndex--;
//    NSLog(@"%ld",secondIndex);
    
    reportViewModel *model = self.dataArr[tableIndex];
   
    if (secondIndex == -1) {
        
        if (tableIndex != 0) {
            tableIndex --;
//            reportModel = model.objectArray[tableIndex-1];
          reportViewModel *model = self.dataArr[tableIndex];
            NSLog(@"%lu",(unsigned long)model.objectArray.count);
            secondIndex = model.objectArray.count-1;
            if (tableIndex == 0) {
                tableIndex =0;
               model = self.dataArr[tableIndex];
               secondIndex = model.objectArray.count-1;
            }
            [_mytableview reloadData];
        }else{
           
           
        }

    }
    NSLog(@"%ld---%lu--%ld",(long)tableIndex,(unsigned long)model.objectArray.count,(long)secondIndex);
    [_mytableview reloadData];
   
    
    
     
}
-(void)onClickedofferButton:(UIButton *)button
{
  
    
      //title变化方法
                          questionResultViewController *vc = [[questionResultViewController alloc]init];
                          vc.titleArray =self.titleArr;
                          vc.secondArray = self.alreadyArr;
                          vc.detailArray = self.selectedsSelectArray;
                          vc.tagStr = self.tag;
                          [self.navigationController pushViewController:vc animated:YES];
    
}
//-(void)twoBtnClick:(UIButton *)button
//{
//
//    [self.dataDict removeAllObjects];
//    if (button.tag == 0) {
//        /// 返回到上一页
//
//        if (currentIndex>1) {
//            currentIndex--;
//            tableIndex--;
//            //            NSLog(@"%f",value);
//            totalValue -=value;
//            NSLog(@"%f",totalValue);
//            progressView.progress = totalValue;
//            self.countText.text = [NSString stringWithFormat:@"%ld/%lu",(long)currentIndex,(unsigned long)self.dataArr.count];
//            //动画
//            CATransition * animation = [CATransition animation];
//            animation.type = kCATransitionMoveIn;  //动画切换风格
//            animation.subtype = kCATransitionFromLeft; //动画切换方向
//            animation.duration = 0.3f;
//            [_mytableview.layer addAnimation:animation forKey:nil];
//            [_endBtn setImage:IMAGE(@"下一步") forState:UIControlStateNormal];
//            [_mytableview reloadData];
//        }else if (currentIndex == 1) {
//            NSLog(@"现在已经是第一页了");
//            self.countText.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.dataArr.count];
//            [AppDelegate show:@"现在已经是第一页了"];
//
//        }
//    }else{
//
//        /// 跳转到下一页
//        if (currentIndex <(self.dataArr.count)) {
//            tableIndex++;
//            currentIndex++;
//            totalValue +=value;
//            NSLog(@"%f",totalValue);
//            progressView.progress = totalValue;
//            self.countText.text = [NSString stringWithFormat:@"%ld/%lu",(long)currentIndex,(unsigned long)self.dataArr.count];
//            //动画
//            CATransition * animation = [CATransition animation];
//            animation.type = kCATransitionReveal;  //动画切换风格
//            animation.subtype = kCATransitionFromRight; //动画切换方向
//            animation.duration = 0.3f;
//
//
//            [_mytableview.layer addAnimation:animation forKey:nil];
//
//            [_endBtn setImage:IMAGE(@"下一步") forState:UIControlStateNormal];
//            [_mytableview reloadData];
//
//
//        }
//        if(currentIndex == (self.dataArr.count)){
//            //处于最后一页，做提交操作
//            NSLog(@"现在已经是最后一页了");
//            NSInteger index = self.dataArr.count;
//            self.countText.text = [NSString stringWithFormat:@"%ld/%lu",(long)index,(unsigned long)self.dataArr.count];
//            progressView.progress = 1;
//
//            [_endBtn setTitle:@"提交表格" forState:UIControlStateNormal];
//
//            [_endBtn setImage:IMAGE(@"已完成") forState:UIControlStateNormal];
//            //            tableIndex = self.dataArr.count-1;
//
//        }
//
//
//
//
//    }
//    if (currentIndex == 1)
//    {
//        self.navigationItem.hidesBackButton = NO;
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
//        self.navigationItem.leftBarButtonItem = item;
//
//    }else{
//        self.navigationItem.leftBarButtonItem = nil;
//        self.navigationItem.hidesBackButton = YES;
//    }
//
//}
//
//
//
//
//-(void)viewWillAppear:(BOOL)animated
//{
//    self.navigationController.navigationBar.hidden = NO;
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
