//
//  CommutiDetailController.m
//  rehab
//
//  Created by yongen zhou on 2018/8/8.
//  Copyright © 2018年 WELL. All rights reserved.
//

#import "CommutiDetailController.h"
#import "YSWFrendCell.h"
#import "WRcommentCell.h"
#import "ComulitModel.h"
#import <Masonry/Masonry.h>
#import "IQKeyboardManager.h"
#import "UINavigationBar+Awesome.h"
#import "FCAlertView.h"
#import "UserBasicInfoController.h"
@interface CommutiDetailController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property UITableView* mytableview;
@property NSMutableArray* comArr;
@property ComulitModel* viewModel;
@property UIView* commentView;
@property UITextView* realfied;
@property (nonatomic)UIButton* send;
@property (nonatomic)UILabel* countText;
@property CGFloat keyBoardHeight;
@property (nonatomic)CGFloat offsets;
@property (nonatomic)CGFloat offset;
@property NSString* type;
@property NSString* selectUuid;
@property NSInteger com;
@property NSInteger index;
@property(nonatomic)FCAlertView *alert;
@property UISegmentedControl*changesegu;

@end

@implementation CommutiDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectUuid = @"";
    self.title = @"动态详情";
    _mytableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    if (IPHONE_X) {
        _mytableview.height = self.view.height-64-54-30;
    }else{
       _mytableview.height = self.view.height-64-54;
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zanReloadCell) name:@"zanReloadCell" object:nil];
    [self.view addSubview:_mytableview];
    [self.mytableview registerNib:[UINib nibWithNibName:NSStringFromClass([YSWFrendCell class]) bundle:nil] forCellReuseIdentifier:@"Friend"];
    [self.mytableview registerNib:[UINib nibWithNibName:NSStringFromClass([WRcommentCell class]) bundle:nil] forCellReuseIdentifier:@"Comment"];
    [self createBackBarButtonItem];
    _com = 0;
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    self.mytableview.estimatedRowHeight = 37.0;
    self.mytableview.rowHeight = UITableViewAutomaticDimension;
    self.viewModel = [ComulitModel new];
    self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mytableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mytableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    [self regNotification];
    [IQKeyboardManager sharedManager].enable = NO;
    self.type = @"";
    self.index = 0;
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [IQKeyboardManager sharedManager].enable = YES;
    [self unregNotification];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self regNotification];
    [self layout];
    
    
}
-(void)zanReloadCell
{
    [self layout];
}

- (void)layout
{
    [self.viewModel getCommentlistSort:self.type ariticleId:self.article.uuid Completion:^(NSError * error) {
        self.comArr = self.viewModel.CommentArr;
//        [self.mytableview reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
        [self.mytableview reloadData];
        
    }];
    
    UIView* bottom = [UIView new];
    bottom.backgroundColor = [UIColor whiteColor];
    if (IPHONE_X) {
       bottom.frame = CGRectMake(0, YYScreenSize().height-WRNavBarHeight-WRStatusBarHeight-54-30, ScreenW, 54);
    }else{
       bottom.frame = CGRectMake(0, YYScreenSize().height-WRNavBarHeight-WRStatusBarHeight-54, ScreenW, 54);
    }
    
    [self.view addSubview:bottom];
    UIButton* btn1 = [UIButton new];
    btn1.frame = CGRectMake(0, 0, ScreenW*1.0/2, 54);
    if (self.article.isupvote) {
        [btn1 setImage:[UIImage imageNamed:@"点赞效果-1"] forState:0];
    }
    else
    {
        [btn1 setImage:[UIImage imageNamed:@"点赞-1"] forState:0];
    }
    [btn1 setTitle:[NSString stringWithFormat:@"%ld",self.article.upvote] forState:0];
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn1 setTitleColor:  [UIColor colorWithHexString:@"959595"] forState:0];
    [btn1 bk_whenTapped:^{
        if (!self.article.isupvote) {
            [btn1 setImage:[UIImage imageNamed:@"点赞效果-1"] forState:0];
            [btn1 setTitle:[NSString stringWithFormat:@"%ld",self.article.upvote+1] forState:0];
            [self.viewModel upvoteArticle:self.article.uuid Completion:^(NSError * error) {
                [AppDelegate show:@"点赞成功"];
            }];
            
        }
    }];
    
    UIButton* btn2 = [UIButton new];
    btn2.frame = CGRectMake(ScreenW*1.0/2, 0, ScreenW*1.0/2, 54);
    [btn2 setImage:[UIImage imageNamed:@"评论shejiao"] forState:0];
    [btn2 setTitle:[NSString stringWithFormat:@"%ld",self.article.cnt+_com] forState:0];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn2 setTitleColor:  [UIColor colorWithHexString:@"959595"] forState:0];
    [btn2 bk_whenTapped:^{
        self.selectUuid = @"";
        [self commentTO:@""];
        
    }];
    
    [bottom addSubview:btn1];
    [bottom addSubview:btn2];
}
- (void)commentTO:(NSString*)uuid
{
    NSString *commentUUid = uuid;
    if (!self.commentView) {
        self.commentView = [UIView new];
        self.commentView.frame = CGRectMake(0, YYScreenSize().height-113-64, ScreenW, 113);
        self.commentView.backgroundColor = [UIColor whiteColor];
        self.commentView.hidden = YES;
        [self.view addSubview:self.commentView];
        
        UITextView* text = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, self.view.width-40, 53)];
        text.backgroundColor = [UIColor whiteColor];
        text.layer.cornerRadius = 4;
        text.layer.masksToBounds  = YES;
        text.textColor = [UIColor wr_titleTextColor];
        self.realfied = text;
        text.delegate =self;
        [self.commentView addSubview:text];
        
        UILabel* count = [UILabel new];
        count.x =20;
        count.y = text.bottom+10;
        count.textColor = [UIColor lightGrayColor];
        count.font = [UIFont systemFontOfSize:13];
        count.text = @"还能填写100字";
        [count sizeToFit];
        self.countText = count;
        [self.commentView addSubview:count];
        
        UIButton* send = [UIButton new];
        send.backgroundColor = [UIColor lightGrayColor];
        send.width = 56;
        send.height = 29;
        send.right = self.view.width -20;
        send.y = text.bottom+10;
        [send setTitle:@"发送" forState:0];
        [send setTitleColor:[UIColor wr_titleTextColor] forState:0];
        send.titleLabel.font = [UIFont systemFontOfSize:13];
        send.layer.cornerRadius =4;
        send.layer.masksToBounds =YES;
        
        self.send =send;
        [self.commentView addSubview:send];
    }
     self.commentView.frame = CGRectMake(0, YYScreenSize().height-113-64, ScreenW, 113);
    [self.send bk_whenTapped:^{
        
        
      WRUserInfo *userInfo = [WRUserInfo selfInfo];
        if ([userInfo.name isEqualToString:@""]) {
            _alert = [[FCAlertView alloc] init];
            [_alert showAlertInView:nil withTitle:NSLocalizedString(@"温馨提示", nil) withSubtitle:NSLocalizedString(@"发表动态前需要完善个人信息!", nil) withCustomImage:nil withDoneButtonTitle:NSLocalizedString(@"立即完善", nil) andButtons:nil];
            [_alert addButton:NSLocalizedString(@"取消", nil) withActionBlock:^{
                [_alert dismissAlertView];
            }];
            [_alert doneActionBlock:^{
                UIViewController *viewController = [[UserBasicInfoController alloc] init];
                viewController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }];
            _alert.hideDoneButton = NO;
            _alert.colorScheme = [UIColor wr_themeColor];
        }else
        {
            [self sendMessage:self.selectUuid];
        }
        
        
    }];
    self.commentView.hidden = NO;
    [self.realfied becomeFirstResponder];
    self.realfied.keyboardAppearance = UIKeyboardTypeDefault;
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    self.countText.text = [NSString stringWithFormat:@"还能填写%ld字",100- textView.text.length];
    if (textView.text.length>0) {
        self.send.backgroundColor = [UIColor wr_themeColor];
        self.send.enabled =YES;
    }
    else
    {
        self.send.backgroundColor = [UIColor lightGrayColor];
        self.send.enabled = NO;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (textView.text.length>=100) {
        return NO;
    }
    else
        return YES;
}
- (void)sendMessage:(NSString*)uuid
{
    
    NSString *str =  [self.realfied.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    [self.viewModel sendCommentArticleId:self.article.uuid parentId:uuid text:str Completion:^(NSError * error) {
        if(!error)
        {
        [AppDelegate show:@"评论成功"];
        self.realfied.text =@"";
            [self.view endEditing:YES];
            
            
           
            
            self.com++;
            
            [self layout];
        }else
        {
            [AppDelegate show:error.domain];
            self.realfied.text =@"";
            [self.view endEditing:YES];
            
            
        
        }
        
        
    }];
}


- (void)regNotification

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)unregNotification

{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification

{
    
    
    NSDictionary *info = [notification userInfo];
    
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset;
    if (IPHONE_X) {
     yOffset =endKeyboardRect.origin.y - beginKeyboardRect.origin.y - 12;
    }else{
        
       yOffset =endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    }
//    NSLog(@"yreal==%lf",yOffset);
    if (yOffset !=self.offset&&yOffset != self.offsets) {
//        NSLog(@"可以real==%lf",yOffset);
        if (fabs(yOffset)<100) {
            self.offsets =yOffset;
        }
        if (fabs(yOffset)>100) {
            self.offset = yOffset;
        }
    }
    else
    {
        yOffset=0;
    }
    
//    NSLog(@"offset %lf",yOffset);
    
    
    CGRect inputFieldRect = self.commentView.frame;
//    NSLog(@"y==%lf",yOffset);
//    NSLog(@"iny = %lf",self.commentView.y);
    
    
    inputFieldRect.origin.y += yOffset;
    
  
//    NSLog(@"oiny = %lf",inputFieldRect.origin.y);
    
    [UIView animateWithDuration:duration animations:^{
        
        self.commentView.frame = inputFieldRect;
        
        self.commentView.hidden = NO;
        
    }];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    
        
     //   self.commentView.y = YYScreenSize().height-113-64;
        
        self.commentView.hidden =YES;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    else
    {
        return _comArr.count+1;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        
        if (indexPath.row==1) {
            UITableViewCell* cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 46)];
            [cell addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(46);
                make.top.left.right.bottom.mas_equalTo(0);
            }];
            CGFloat imageSize = 20;
            CGFloat xOffset = -3;
            
            
            UIScrollView *iconScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 11,120, 20)];
            iconScrollView.backgroundColor = [UIColor clearColor];
            iconScrollView.showsVerticalScrollIndicator = NO;
            iconScrollView.showsHorizontalScrollIndicator = NO;
            [view addSubview:iconScrollView];
            CGFloat y = 0;
            CGFloat x = 0;
            for(NSUInteger index = 0; index < self.article.upvotes.count; index++)
            {
                NSString* image = self.article.upvotes[index];
                if ((x +imageSize) > (iconScrollView.width - xOffset)) {
                    break;
                }
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageSize, imageSize)];
                imageView.layer.cornerRadius = imageView.width/2;
                imageView.layer.masksToBounds = YES;
                imageView.layer.borderWidth = 2;
                imageView.layer.borderColor = [UIColor whiteColor].CGColor;
                [imageView setImageWithUrlString:image holderImage:[WRUIConfig defaultHeadImage]];
                [iconScrollView addSubview:imageView];
                iconScrollView.height = 20;
                x = imageView.right + xOffset;
            }
            iconScrollView.contentSize = CGSizeMake(x, imageSize);
            iconScrollView.width = x>120?120:x;
            
            UIImage *image = [[UIImage imageNamed:@"点赞效果-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:image];
            arrowImageView.tintColor = [UIColor grayColor];
            arrowImageView.frame = CGRectMake(iconScrollView.width-6+15, imageSize-6, 12, 12);
            [view addSubview:arrowImageView];

            UILabel* la = [UILabel new];
            la.text = [NSString stringWithFormat:@"%ld人点赞",(long)self.article.upvote];
            la.font = [UIFont systemFontOfSize:13];
            la.textColor = [UIColor lightGrayColor];
            [la sizeToFit];
            la.x = 30+iconScrollView.width;
            la.centerY = iconScrollView.centerY;
            [view addSubview:la];
            return cell;
            
        }else
        {
            YSWFrendCell* cell = [self.mytableview dequeueReusableCellWithIdentifier:@"Friend"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lineheight.constant=0;
            [cell loadcellWith:self.article];
            [cell.zan setHidden:YES];
            [cell.ping setHidden:YES];
            return cell;
        }
            
            
            
    }
    else
    {
        if (indexPath.row==0) {
            UITableViewCell* cell = [[UITableViewCell alloc]init];
            UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 56)];
            [cell addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(56);
                make.top.left.right.bottom.mas_equalTo(0);
            }];
            
            UILabel* pinglunla = [UILabel new];
            pinglunla.text = @"评论内容";
            pinglunla.textColor = [UIColor wr_titleTextColor];
            pinglunla.font =[UIFont systemFontOfSize:15];
            [view addSubview:pinglunla];
            [pinglunla sizeToFit];
            pinglunla.x = 16;
            pinglunla.centerY = 56*1.0/2;
            
            UISegmentedControl* segu = [[UISegmentedControl alloc]initWithItems:@[@"最新",@"热门"]];
            segu.width = 94;
            segu.height = 30;
            [segu sizeToFit];
            segu.centerY = 56*1.0/2;
            segu.right = ScreenW-22;
            segu.tintColor = [UIColor colorWithHexString:@"959595"];
            NSDictionary *dic = @{
                                  //1.设置字体样式:例如黑体,和字体大小
                                  NSFontAttributeName:[UIFont systemFontOfSize:13],
                                  //2.字体颜色
                                  };
            
            [segu setTitleTextAttributes:dic forState:UIControlStateNormal];
            self.changesegu = segu;
            [segu setSelectedSegmentIndex:self.index];
            [segu addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
            [view addSubview:segu];
            
            UIView* line = [UIView new];
            line.frame = CGRectMake(0, view.height-1, ScreenW, 1);
            line.backgroundColor = [UIColor wr_lineColor];
            [view addSubview:line];
            
            return cell;
        }
        
        else
        {
        WRcommentCell* cell = [self.mytableview dequeueReusableCellWithIdentifier:@"Comment"];
        WRCOMcomment* com = self.comArr[indexPath.row-1];
        [cell loadwith:com];
            cell.resp.tag = indexPath.row-1;
            [cell.resp addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
            
//        [cell.resp bk_whenTapped:^{
//            [self commentTO:com.uuid];
//        }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        }
    }
    
}
-(void)comment:(UIButton *)button
{
    WRCOMcomment* com = self.comArr[button.tag];
    
    self.selectUuid = com.uuid;
    NSLog(@"=-=-=-=-==%@",com.uuid);
    NSLog(@"=-=-=-=-==%@",self.selectUuid);
     [self commentTO:@""];
    
}
// 允许长按菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            return YES;
        }
    }
    
    return NO;
}
// 点击指定的cell 出现Menu菜单
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            return  YES;
            NSLog(@"-----1");
        }else{
            return NO;
        }
    }else{
       return NO;
    }
    
    
    
}
// 执行复制操作
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            if (action == @selector(copy:)) {
                YSWFrendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; // 粘贴板
                [pasteBoard setString:cell.content.text];
            }
        }
    }
    
    
}
-(void)selected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            self.type = @"";
            self.index = 0;
            [self layout];
            break;
        case 1:
            self.type = @"hot";
            self.index = 1;
            [self layout];
            break;
        
            
        default:
            NSLog(@"3");
            break;
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section==1&&indexPath.row!=0) {
        WRCOMcomment* com = self.comArr[indexPath.row-1];
        if ([com.userId isEqualToString:[WRUserInfo selfInfo].userId]) {
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRCOMcomment* com = self.comArr[indexPath.row-1];
    [self.viewModel deletComentId:com.uuid Completion:^(NSError * error) {
        if (error) {
            [AppDelegate show:error.domain];
        }
        else
        {
        [AppDelegate show:@"删除成功"];
            self.com--;
            [self layout];
            
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
      if (section == 0) {
          return 10;
      }else{
          
          return 0.01;
      }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *bottlev = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        bottlev.backgroundColor = kGray;
        return bottlev;
    }else{
        
        return nil;
    }
   
    
}
@end
