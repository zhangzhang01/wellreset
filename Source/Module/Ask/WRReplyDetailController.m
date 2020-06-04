//
//  WRReplyDetailController.m
//  rehab
//
//  Created by yongen zhou on 2017/4/18.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRReplyDetailController.h"
#import "AskDetailViewModel.h"
#import "IQKeyboardManager.h"
@interface WRReplyDetailController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UIScrollView* _ba ;
}
@property (nonatomic)AskDetailViewModel* viewModel;
@property (nonatomic)NSMutableArray* commentArr;
@property (nonatomic)UIButton* upvote;
@property (nonatomic)UIView*  commentView;
@property (nonatomic)UITextView* realfied;
@property (nonatomic)UILabel* countText;
@property (nonatomic)UIView* realView;
@property (nonatomic)UIButton* send;
@property (nonatomic)CGFloat offsets;
@property (nonatomic)CGFloat offset;
@end

@implementation WRReplyDetailController

-(instancetype)init
{
    if(self = [super init]){
        //        [self layoutCommentView];
        //        [self.view addSubview:commentView];
        self.viewModel = [AskDetailViewModel new];
        
        [IQKeyboardManager sharedManager].enable = NO;
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
   
    _ba = [UIScrollView new];
    _ba.frame = CGRectMake(0, 0, ScreenW, self.view.height-64-48);
    [self.view addSubview:_ba];
    UIView* commentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-48-64, self.view.width, 48)];
    
    if (IPHONE_X) {
         _ba.frame = CGRectMake(0, 0, ScreenW, self.view.height-64-48-40);
        commentView.frame = CGRectMake(0, self.view.height-48-64-40, ScreenW, 48);
    }else{
        
    }
    
    
    
    commentView.backgroundColor = [UIColor whiteColor];
    self.commentView = commentView;
    [self.view addSubview:self.commentView];
    [self layoutCommentView];
//    self.viewModel = [AskDetailViewModel new];
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    //   [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.currentNews.contentUrl]]];
    
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
   
    [self regNotification];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self unregNotification];
    //    UINavigationBar *bar = self.navigationController.navigationBar;
    //    [bar lt_setBackgroundColor:[UIColor wr_rehabBlueColor]];
    //    bar.tintColor = [UIColor whiteColor];
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
-(void)viewDidAppear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self fetup];
    
}
-(void)fetup
{
   [self.viewModel fetchCommentListWithReply:self.model.indexId completion:^(NSError * _Nonnull error) {
       if (self.viewModel.content&&![self.viewModel.content isEqualToString:@""]) {
           switch (self.viewModel.isshow) {
               case 0:
                   self.model.content = self.viewModel.content;
                   break;
               case 1:
                   self.model.content = self.viewModel.content;
                   break;
               case 2:
                   self.model.content = self.viewModel.content1;
                   break;
               case 3:
                   self.model.content = self.viewModel.content2;
                   break;
                   
                   
               default:
                   break;
           }
       }
       if (!_realView) {
           UIView* realview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 113, self.view.width, 113)];
           realview.backgroundColor = [UIColor groupTableViewBackgroundColor];
           realview.hidden =YES;
           self.realView = realview;
           [self.view addSubview:realview];
           
           UITextView* text = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, self.view.width-40, 53)];
           text.backgroundColor = [UIColor whiteColor];
           text.layer.cornerRadius = 4;
           text.layer.masksToBounds  = YES;
           text.textColor = [UIColor wr_titleTextColor];
           self.realfied = text;
           text.delegate =self;
           [realview addSubview:text];
           
           UILabel* count = [UILabel new];
           count.x =20;
           count.y = text.bottom+10;
           count.textColor = [UIColor lightGrayColor];
           count.font = [UIFont systemFontOfSize:13];
           count.text = @"还能填写100字";
           [count sizeToFit];
           self.countText = count;
           [realview addSubview:count];
           
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
           [send addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        
           self.send =send;
           [realview addSubview:send];
       }

       
       [self layOut];
   }];
}

- (void)layOut
{
    [_ba removeAllSubviews];
    CGFloat y =0;
    UIView* ask =[self createAskView];
    y+=ask.bottom;
    [_ba addSubview:ask];
    UIView*line = [[UIView alloc]initWithFrame:CGRectMake(0,y , ScreenW, 5)];
    line.y = y;
    line.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [_ba addSubview:line];
    y+=5;
    UIView* reply = [self createReplayView];
    reply.y = y;
    [_ba addSubview:reply];
    y = reply.bottom;
    line = [[UIView alloc]initWithFrame:CGRectMake(0,y , ScreenW, 5)];
    line.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [_ba addSubview:line];
    y+=5;
    UIView* comment = [self createComment];
    comment.y = y;
    y=comment.bottom;
    [_ba addSubview:comment];
    _ba.contentSize = CGSizeMake(ScreenW, y);
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView*)createAskView
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    CGFloat y = 0;
     y += 24;
    UILabel* asklabel = [UILabel new];
    asklabel.text = @"提问";
    asklabel.font = [UIFont boldSystemFontOfSize:15];
    asklabel.textColor = [UIColor colorWithHexString:@"333333"];
    [asklabel sizeToFit];
    asklabel.y = y;
    asklabel.centerX = self.view.centerX;
    [pannel addSubview:asklabel];
    
    UIImageView* left = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"左"]];
    left.right = asklabel.left-10;
    left.centerY = asklabel.centerY;
    [pannel addSubview:left];
    
    UIImageView* right = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"右"]];
    right.left = asklabel.right+10;
    right.centerY = asklabel.centerY;
    [pannel addSubview:right];
    
    UIImageView* head = [UIImageView new];
    head.x = WRUIBigOffset;
    head.y = 46;
    head.width = head.height = 22;
    [head wr_roundFill];
    [head setImageWithURL:[NSURL URLWithString:self.model.headImage] placeholder:[WRUIConfig defaultHeadImage]];
    [pannel addSubview:head];
    
    UILabel* name = [UILabel new];
    name.text = self.model.userName;
    name.font = [UIFont systemFontOfSize:WRDetailFont];
    name.textColor = [UIColor colorWithHexString:@"333333"];
    [name sizeToFit];
    name.x = head.right+12;
    name.centerY = head.centerY;
    [pannel addSubview:name];
    
    UILabel* time = [UILabel new];
    time.text = self.model.askTime;
    time.font = [UIFont systemFontOfSize:WRDetailFont];
    time.textColor = [UIColor colorWithHexString:@"b5b5b5"];
    [time sizeToFit];
    time.right = self.view.width-20;
    time.centerY = head.centerY;
    [pannel addSubview:time];
    
    UIView*line = [[UIView alloc]initWithFrame:CGRectMake(0,head.bottom+10 , ScreenW, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    [pannel addSubview:line];
    
    UILabel* arti = [UILabel new];
    arti.numberOfLines =0;
    arti.text = self.model.question;
    arti.y = line.bottom+12;
    arti.x = WRUIBigOffset;
    arti.font = [UIFont systemFontOfSize:WRDetailFont];
    arti.textColor = [UIColor colorWithHexString:@"333333"];
    arti.width = ScreenW-2*WRUIBigOffset;
    [arti sizeToFit];
    [pannel addSubview:arti];
    
    pannel.height+= arti.bottom+17;
    
    
    
    return pannel;
}
- (UIView*)createReplayView
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    CGFloat y = 0;
    y += 24;
    UILabel* asklabel = [UILabel new];
    asklabel.text = @"专家问答";
    asklabel.font = [UIFont boldSystemFontOfSize:15];
    asklabel.textColor = [UIColor colorWithHexString:@"333333"];
    [asklabel sizeToFit];
    asklabel.y = y;
    asklabel.centerX = self.view.centerX;
    [pannel addSubview:asklabel];
    
    UIImageView* left = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"左"]];
    left.right = asklabel.left-10;
    left.centerY = asklabel.centerY;
    [pannel addSubview:left];
    
    UIImageView* right = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"右"]];
    right.left = asklabel.right+10;
    right.centerY = asklabel.centerY;
    [pannel addSubview:right];
    
    UILabel* arti = [UILabel new];
    arti.numberOfLines =0;
    arti.text = self.model.content;
    arti.y = asklabel.bottom+18;
    arti.x = WRUIBigOffset;
    arti.font = [UIFont systemFontOfSize:WRDetailFont];
    arti.textColor = [UIColor colorWithHexString:@"333333"];
    arti.width = ScreenW-2*WRUIBigOffset;
    [arti sizeToFit];
    [pannel addSubview:arti];
    
    UIButton* btn = [UIButton new];
    btn.y += arti.bottom+15;
    btn.width = 110;
    btn.height = 28;
    btn.centerX = self.view.centerX;
    [btn setImage:[UIImage imageNamed:@"点击默认状态"] forState:0];
    [btn setImage:[UIImage imageNamed:@"点击选中状态"] forState:UIControlStateSelected];
    [btn setTitle:@"对我有用" forState:0];
    [btn setTitleColor:[UIColor colorWithHexString:@"d2d2d2"] forState:0];
    [btn setTitleColor:[UIColor wr_rehabBlueColor] forState:UIControlStateSelected];
    btn.layer.cornerRadius = 14;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor colorWithHexString:@"d2d2d2"].CGColor;
    btn.layer.borderWidth = 1;
    [pannel addSubview:btn];
    [btn bk_whenTapped:^{
        [self.viewModel fetchAddvoteWithReaplyid:self.model.indexId completion:^(NSError * _Nonnull error) {
            btn.selected = YES;
            btn.layer.borderColor = [UIColor wr_rehabBlueColor].CGColor;
            self.viewModel.ifUpvoted= YES;
            [self fetup];
        } ];
    }];
    self.upvote = btn;
    if (self.viewModel.ifUpvoted) {
        btn.selected = YES;
        btn.layer.borderColor = [UIColor wr_rehabBlueColor].CGColor;
    }
    else
    {
        btn.selected = NO;
    }
    
    
    
    pannel.height = btn.bottom+15;
    return pannel;
}
- (UIView*)createComment
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    CGFloat y = 0;
    UILabel* title = [UILabel new];
    title.text=[NSString stringWithFormat:@"评论"] ;
    title.x = 25;
    title.y = 22+y;
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor wr_titleTextColor];
    [title sizeToFit];
    [pannel addSubview:title];
    
    y += 49;
    UIView* line= [[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.width, 1)];
    line.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:line];
    
    y+=1;
    self.commentArr = self.viewModel.ListArry;
    
    
    for (WRAskComment* commet  in self.commentArr ) {
        UIImageView* im = [UIImageView new];
        im.x = 23;
        im.y = 22+y;
        im.width = 32;
        im.height = 32;
        [im setImageWithURL:[NSURL URLWithString:commet.headImg] placeholder:[WRUIConfig defaultHeadImage]] ;
        [im wr_roundFill];
        [pannel addSubview:im];
        
        UILabel* title = [UILabel new];
        title.text = commet.name;
        title.x = 70;
        title.y = 18+y;
        title.font = [UIFont systemFontOfSize:WRDetailFont];
        title.textColor = [UIColor wr_grayBorderColor];
        [title sizeToFit];
        [pannel addSubview:title];
        
        
        UILabel* content = [UILabel new];
        content.text = commet.content;
        content.font = [UIFont systemFontOfSize:WRTitleFont];
        content.textColor = [UIColor wr_titleTextColor];
        content.x = 70;
        content.y = title.bottom+13;
        content.width = self.view.width - 70-20;
        content.numberOfLines = 0;
        [content sizeToFit];
        [pannel addSubview:content];
        
        
        UILabel* time = [UILabel new];
        time.text = commet.createTime;
        time.font = [UIFont systemFontOfSize:WRDetailFont];
        [time sizeToFit];
        time.textColor = [UIColor colorWithHexString:@"C9C9C9"];
        time.right = self.view.width-20;
        time.y = 18+y;
        [pannel addSubview:time];
        
        CGSize size = [content.text sizeWithFont:[UIFont systemFontOfSize:WRTitleFont] constrainedToSize:CGSizeMake(content.width, MAXFLOAT)];
        y += size.height+ 43 +18;
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.width, 1)];
        line.backgroundColor = [UIColor wr_lineColor];
        
        y+=1;
        
        
    }

    pannel.height = y;
    
    return pannel;
 
}


#pragma mark - 
- (void)sendMessage
{
    
    [self.viewModel fetchAddCommentWithReply:self.model.indexId context:self.realfied.text completion:^(NSError * _Nonnull error) {
        if (!error) {
            UIAlertView* al = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"发送成功" cancelButtonTitle:@"确认" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
            }];
            [self.view endEditing:YES];
            [self fetup];
            [self.view endEditing:YES];
            self.realView.hidden =YES;
            [al show];
        }
        else
        {
            UIAlertView* al = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:error.domain cancelButtonTitle:@"确认" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
            }];
            
            [al show];
            
        }
        
    }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //        [textField resignFirstResponder];
    
    self.realView.hidden  = NO;
    
    self.realfied.keyboardAppearance = UIKeyboardTypeDefault;
    self.realfied.returnKeyType = UIReturnKeyDone;
    
    
    
    
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.realView.hidden =YES;
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
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self.view endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    if (textView.text.length>=100) {
        return NO;
    }
    else
        return YES;
}
-(void)layoutCommentView
{
    UIView* textview = [[UIView alloc]initWithFrame:CGRectMake(9, 10, self.view.width-20, 29)];
    textview.backgroundColor = [[UIColor colorWithHexString:@"bfbfbf"]colorWithAlphaComponent:0.2];
    [self.commentView addSubview:textview];
    
    UIImageView* pen = [[UIImageView alloc]initWithFrame:CGRectMake(7, 6, 18, 18)];
    [pen setImage:[UIImage imageNamed:@"写评论"]];
    [textview addSubview:pen];
    
    
    
    
    UITextField* field = [[UITextField alloc]initWithFrame:CGRectMake(6+pen.right, 0, self.view.width-155, 29)];
    field.delegate =self;
    field.placeholder = @"说点什么吧...";
    field.tag =1001;
    field.font = [UIFont systemFontOfSize:13];
    [textview addSubview:field];
    field.inputAccessoryView = [[UIView alloc] init];
       
    
    
}
- (void)regNotification

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}
- (void)unregNotification

{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

#pragma mark - notification handler

- (void)keyboardWillChangeFrame:(NSNotification *)notification

{
    
    NSDictionary *info = [notification userInfo];
    
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    NSLog(@"yreal==%lf",yOffset);
    if (yOffset !=self.offset&&yOffset != self.offsets) {
        NSLog(@"可以real==%lf",yOffset);
        if (fabs(yOffset)<100) {
            self.offsets =yOffset;
        }
        if (fabs(yOffset)>100) {
            self.offset = yOffset;
        }
        
        
        
        
        
        //            self.uuid =nil;
    }
    else
    {
        yOffset=0;
    }
    
    NSLog(@"offset %lf",yOffset);
    if (yOffset<0) {
        [self.realfied becomeFirstResponder];
    }
    
    CGRect inputFieldRect = self.realView.frame;
    NSLog(@"y==%lf",yOffset);
    NSLog(@"iny = %lf",self.realView.y);
    
    
    inputFieldRect.origin.y += yOffset;
    
    
    
    
    NSLog(@"oiny = %lf",inputFieldRect.origin.y);
    
    
    
    
    [UIView animateWithDuration:duration animations:^{
        
        self.realView.frame = inputFieldRect;
        
        
        
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
