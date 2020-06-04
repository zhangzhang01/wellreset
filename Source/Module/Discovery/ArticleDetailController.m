//
//  ArticleDetailController.m
//  rehab
//
//  Created by herson on 6/3/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ArticleDetailController.h"

#import "SVProgressHUD.h"
#import "UMengUtils.h"
#import "Masonry/Masonry.h"


#import "WRFAQViewModel.h"
#import "WRViewModel+Common.h"
#import "IQKeyboardManager.h"
#import "commentViewModel.h"
#import "UserViewModel.h"
#import <YYKit/YYKit.h>
@interface ArticleDetailController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    NSDate *_startDate;
    BOOL IfComment;
}
@property(nonatomic)UIImage *contentImage;
@property (nonatomic, copy) NSString *articleTitle;
@property (nonatomic)UIScrollView *scrollView;
@property (nonatomic)NSMutableArray* commentArr;
@property (nonatomic)UIView*  commentView;
@property (nonnull) UIWebView* webview;
@property (nonatomic)UITextView* realfied;
@property (nonatomic)UILabel* countText;
@property (nonatomic)UIView* realView;
@property (nonatomic)UIButton* send;
@property (nonatomic)commentViewModel* viewModel;
@property (nonatomic)UIImageView* fav ;
@property (nonatomic)CGFloat offsets;
@property (nonatomic)CGFloat offset;
@property (nonatomic)UITextField * now;
@property (nonatomic)NSString* uuid;
@end

@implementation ArticleDetailController

-(instancetype)init
{
    if(self = [super init]){
        //        [self layoutCommentView];
//        [self.view addSubview:commentView];
        self.viewModel = [commentViewModel new];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationHandler:) name:WRReloadFavorNotification object:nil];
//        [IQKeyboardManager sharedManager].enable = NO;
//        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        IfComment = YES;
    }
    
    return self;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
//        [textField resignFirstResponder];
    
    self.realView.hidden  = NO;
    
    self.realfied.keyboardAppearance = UIKeyboardTypeDefault;
//    self.realfied.returnKeyType = UIReturnKeyDone;
    
   
    
    
    
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
    
    if (textView.text.length>=100) {
        return NO;
    }
    else
    return YES;
}
-(void)layoutCommentView
{
    UIView* textview = [[UIView alloc]initWithFrame:CGRectMake(9, 10, self.view.width-125, 29)];
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
    self.now = field;
    UIImageView* fav = [UIImageView new];
    fav.image = [UIImage imageNamed:@"点赞"];
    fav.size = fav.image.size;
    [fav sizeToFit];
    fav.right = self.view.width-68;
    fav.centerY = textview.centerY;
    [self.commentView addSubview:fav];
    self.fav = fav;
    fav.userInteractionEnabled = YES;
    [fav bk_whenTapped:^{
        [self onClickedFavorControl:nil];
    }];
    
    
    
    UIImageView* share = [UIImageView new];
    share.size = share.image.size;
    share.image = [UIImage imageNamed:@"分享"];
    [share sizeToFit];
    share.right = self.view.width-23;
    share.centerY = textview.centerY;
    [self.commentView addSubview:share];
    share.userInteractionEnabled =YES;
    [share bk_whenTapped:^{
        [self onClickedShareButton:nil];
    }];
    
    
    
}
-(void)notificationHandler:(NSNotification*)notification
{
    if([notification.name isEqualToString:WRReloadFavorNotification] )
    {
        self.fav.image = self.currentNews.favor?[UIImage imageNamed:@"点赞效果"]:[UIImage imageNamed:@"点赞"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ArticleDetailController viewDidLoad");
    
    self.offset =0;
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    _startDate = [NSDate date];
    self.title = @"资讯详情";
    [WRNetworkService pwiki:@"资讯详情"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    if (IPHONE_X) {
        scrollView.frame = CGRectMake(0, 0, ScreenW, SCREEN_HEIGHT-30);
    }else{
        scrollView.frame = self.view.frame;
    }
    scrollView.backgroundColor = [UIColor wr_bgColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.view.width, 10000);
    self.scrollView = scrollView;
    
    

    
    UIWebView *webview = [[UIWebView alloc] init];
    webview.frame = self.scrollView.frame;
    webview.scrollView.scrollEnabled = NO;
    webview.delegate = self;
//    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.scrollView);
//    }];
    self.webview = webview;
    _webview.scrollView.bounces = NO;
    _webview.scrollView.showsHorizontalScrollIndicator = NO;
    
    [_webview sizeToFit];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:webview];
    
    
    
    
    
    
    
    
    self.articleTitle = self.currentNews.title;
//    [[IQKeyboardManager sharedManager] setEnable:NO];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.currentNews.contentUrl]]];
    self.title = NSLocalizedString(@"文章内容", nil);
    //[self initBarItems];
    __weak __typeof(self)weakself = self;
    [WRViewModel operationWithType:OperationTypeProTreatArticle indexId:self.currentNews.uuid actionType:OperationActionTypeAdd contentType:OperationContentTypeUnknown completion:^(NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@", error.domain);
        }
    }];
    
   // __weak __typeof(self)weakself = self;
    [WRFAQViewModel userGetFavorStateWithArticleId:_currentNews.uuid completion:^(NSError *error, WRArticle *article) {
        NSLog(@"currentNews%@",weakself.currentNews.uuid);
        if (!error) {
            weakself.currentNews.favor = article.favor;
            [weakself initBarItems];
        } else {
            NSLog(@"获取收藏状态失败");
        }
    }];

    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
//   [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.currentNews.contentUrl]]];
    
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
       self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self regNotification];
    
    __weak __typeof(self)weakself = self;
    [WRFAQViewModel userGetFavorStateWithArticleId:_currentNews.uuid completion:^(NSError *error, WRArticle *article) {
        NSLog(@"currentNews%@",weakself.currentNews.uuid);
        if (!error) {
            weakself.currentNews.isHiddenComment = article.isHiddenComment;
            IfComment  = !article.isHiddenComment;
            if (IfComment) {
                UIView* commentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-48, self.view.width, 48)];
                if (IPHONE_X) {
                    commentView.frame = CGRectMake(0, self.view.height-48-10, self.view.width, 48);
                }else{
                    commentView.frame = CGRectMake(0, self.view.height-48, self.view.width, 48);
                }
                commentView.backgroundColor = [UIColor whiteColor];
                self.commentView = commentView;
                [self.view addSubview:self.commentView];
                [self layoutCommentView];
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
                
                
            }
            else
            {
                [self initBarItems];
              self.webview.scrollView.scrollEnabled = YES;
                self.scrollView.frame = self.view.frame;
                self.scrollView.contentSize = self.view.size;
              self.webview.frame = self.scrollView.frame;
            }
        } else {
            NSLog(@"获取收藏状态失败");
        }
    }];

    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.articleTitle = self.currentNews.title;
//    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.currentNews.contentUrl]]];
    self.title = NSLocalizedString(@"文章内容", nil);
    [self initBarItems];
    
    [WRViewModel operationWithType:OperationTypeProTreatArticle indexId:self.currentNews.uuid actionType:OperationActionTypeAdd contentType:OperationContentTypeUnknown completion:^(NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@", error.domain);
        }
    }];
    
    __weak __typeof(self)weakself = self;
    [WRFAQViewModel userGetFavorStateWithArticleId:_currentNews.uuid completion:^(NSError *error, WRArticle *article) {
        NSLog(@"currentNews%@",weakself.currentNews.uuid);
        if (!error) {
            weakself.currentNews.favor = article.favor;
            [[NSNotificationCenter defaultCenter] postNotificationName:WRReloadFavorNotification object:nil];
        } else {
            NSLog(@"获取收藏状态失败");
        }
    }];
    
    
    
    
    
}

- (void)sendMessage
{
    if (self.uuid) {
        [self.viewModel fetchAddchidCommentWithWechat:_currentNews.uuid uuid:self.uuid context:self.realfied.text completion:^(NSError * _Nonnull error) {
            
            if (!error) {
                UIAlertView* al = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"发送成功" cancelButtonTitle:@"确认" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                }];
                [self.view endEditing:YES];
                [self fetchList];
                self.realfied.text =@"";
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
    else
    {
    [self.viewModel fetchAddCommentWithWechat:_currentNews.uuid context:self.realfied.text completion:^(NSError * _Nonnull error) {
        
        if (!error) {
           UIAlertView* al = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"发送成功" cancelButtonTitle:@"确认" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
               
           }];
            
            [self fetchList];
            [self.view endEditing:YES];
            self.realfied.text =@"";
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
    self.uuid =nil;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取页面高度（像素）
    if (IfComment) {
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.clientHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    
    //获取内容实际高度（像素）
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').clientHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
    
        webView.frame = CGRectMake(0, 0, self.view.frame.size.width, frame.height);
        [self fetchList];
    }
    
    
    
   
    
}
- (void)fetchList
{
    
    [self.viewModel fetchCommentListWithWechat:_currentNews.uuid completion:^(NSError * _Nonnull error) {
        [self loadViewWithComment:self.viewModel.ListArry];
    }];
    
    
}
-(void)loadViewWithComment:(NSMutableArray*)arry
{
    for (UIView* v in self.scrollView.subviews) {
        if (![v isKindOfClass:[UIWebView class]]) {
            [v removeFromSuperview];
        }
    }
    
    
    CGFloat y = self.webview.height;
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.width, 1)];
    line.backgroundColor = [UIColor wr_lineColor];
    [self.scrollView addSubview:line];
    y+=1;
    UILabel* title = [UILabel new];
    title.text=[NSString stringWithFormat:@"%ld 条评论 ",self.viewModel.totalcount] ;
    title.x = 25;
    title.y = 22+y;
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor wr_titleTextColor];
    [title sizeToFit];
    [self.scrollView addSubview:title];
    
    y += 49;
    line= [[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.width, 1)];
    line.backgroundColor = [UIColor wr_lineColor];
    [self.scrollView addSubview:line];
    
    y+=1;
    self.commentArr = self.viewModel.ListArry;
    
    
    for (WRComment* commet  in self.commentArr ) {
        UIImageView* im = [UIImageView new];
        im.x = 23;
        im.y = 22+y;
        im.width = 32;
        im.height = 32;
        [im setImageWithURL:[NSURL URLWithString:commet.headImg] placeholder:[WRUIConfig defaultHeadImage]] ;
        [im wr_roundFill];
        [self.scrollView addSubview:im];
        
        UILabel* title = [UILabel new];
        title.text = commet.name;
        title.x = 70;
        title.y = 18+y;
        title.font = [UIFont systemFontOfSize:WRDetailFont];
        title.textColor = [UIColor wr_grayBorderColor];
        [title sizeToFit];
        [self.scrollView addSubview:title];
        
        UILabel* time = [UILabel new];
        time.text = commet.date;
        time.font = [UIFont systemFontOfSize:WRDetailFont];
        [time sizeToFit];
        time.textColor = [UIColor colorWithHexString:@"C9C9C9"];
        time.x = 70;
        time.y = 6+title.bottom;
        [self.scrollView addSubview:time];
        int yt= 6+time.bottom;
        if (commet.chid) {
            UIView* bac = [UIView new];
            bac.x = 55;
            bac.y = time.bottom+13;
            bac.width = self.view.width - 55-20;
            bac.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
            [self.scrollView addSubview:bac];
            
            
            UILabel* content = [UILabel new];
            content.text = [NSString stringWithFormat:@"%@：%@",commet.chid.userName,commet.chid.context];
            
            content.font = [UIFont systemFontOfSize:12];
            content.textColor = [UIColor wr_titleTextColor];
            content.x = 14;
            content.y = 13;
            content.width =self.view.width - 55-20-14*2;
            content.numberOfLines = 0;
            
            [content sizeToFit];
            [bac addSubview:content];
            [content setWr_AttributedWithColorRange:NSMakeRange(0, commet.chid.userName.length) Color:[UIColor wr_themeColor] InintTitle:content.text];
            CGSize size2 = [[commet.chid.context stringByAppendingString:commet.chid.userName] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.view.width - 55-20-14*2, MAXFLOAT)];
            bac.height = 14*2+size2.height;
            yt = bac.bottom;
        }
       
        UIImageView* com = [UIImageView new];
        com.x = ScreenW-16-24;
        com.y = 15+y;
        com.width =com.height = 16;
        [com setImage:[UIImage imageNamed:@"回复图标"]];
        [self.scrollView addSubview:com];
        
        
        UILabel* content = [UILabel new];
        content.text = commet.context;
        content.font = [UIFont systemFontOfSize:WRTitleFont];
        content.textColor = [UIColor wr_titleTextColor];
        content.x = 70;
        content.y =  yt+13;
        content.width = self.view.width - 70-20;
        content.numberOfLines = 0;
        [content sizeToFit];
        [self.scrollView addSubview:content];
        
        
        
        
        CGSize size = [content.text sizeWithFont:[UIFont systemFontOfSize:WRTitleFont] constrainedToSize:CGSizeMake(content.width, MAXFLOAT)];
        
        UIButton* btn = [UIButton new];
        
        
        
        
        if (commet.chid) {
            CGSize size2 = [[commet.chid.context stringByAppendingString:commet.chid.userName] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.view.width - 55-20-14*2, MAXFLOAT)];
            y += size.height+ size2.height+16+59+16+48;
        }
        else
        {
            y += size.height+ 43 +16+16+16;
        }
        btn.frame = com.frame;
        [btn bk_whenTapped:^{
            [self.now becomeFirstResponder];
            self.uuid = commet.indexId;

        }];
        [self.scrollView addSubview:btn];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.width, 1)];
        line.backgroundColor = [UIColor wr_lineColor];
        [self.scrollView addSubview:line];
        y+=1;

        
    }
    if (self.viewModel.totalcount>10) {
        UIButton* btn = [UIButton new];
        btn.x=0;
        btn.y =y;
        btn.width=self.view.width;
        btn.height = 88;
        [btn setTitle:@"更多评论" forState:0];
        [btn setTitleColor:[UIColor colorWithHexString:@"607EA6"] forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:WRTitleFont];
        
        y+=88;
    }
   
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, y+49+64);
    
    
    
}





- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
    [self unregNotification];
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    [bar lt_setBackgroundColor:[UIColor wr_rehabBlueColor]];
//    bar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
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
    else if(yOffset>100)
    {
        self.uuid =nil;

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

#pragma mark - event
-(IBAction)onClickedFavorControl:(UIBarButtonItem*)sender {
    if ([self checkUserLogState:self.navigationController]) {
        sender.enabled = NO;
        __weak __typeof(self) weakSelf = self;
        [WRViewModel operationWithType:OperationTypeFavor indexId:self.currentNews.uuid actionType:(self.currentNews.favor?OperationActionTypeDelete:OperationActionTypeAdd) contentType:OperationContentTypeArticle completion:^(NSError * _Nonnull error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"收藏失败", nil)];
            } else {
                weakSelf.currentNews.favor = !weakSelf.currentNews.favor;
                [weakSelf initBarItems];
                [[NSNotificationCenter defaultCenter] postNotificationName:WRReloadFavorNotification object:nil];
            }
        }];
    }     
}

#pragma mark - IBAction
-(IBAction)onClickedShareButton:(id)sender {
    if (self.contentImage) {
        [self shareArticleWithImage:self.contentImage];
    } else {
        [SVProgressHUD showWithStatus:nil];
        __weak __typeof(self) weakSelf = self;
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [SVProgressHUD dismiss];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.currentNews.imageUrl]]];
                if (!image)
                {
                    image = [UIImage imageNamed:@"well_logo"];
                }
                else
                {
                    weakSelf.contentImage = image;
                }
                [weakSelf shareArticleWithImage:image];
            }];
        });
    }
    
}


#pragma mark - private
-(UIBarButtonItem*)createFavorBarButtonItem:(BOOL)flag {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:(flag ? @"well_icon_like_focus" : @"well_icon_like")] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedFavorControl:)];
    return item;
}

#pragma mark -

-(void)initBarItems
{
    if (!IfComment) {
        
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"well_icon_share"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedShareButton:)];
    UIBarButtonItem *favorItem = [self createFavorBarButtonItem:self.currentNews.favor];
    favorItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, -25);
    self.navigationItem.rightBarButtonItems = @[shareItem, favorItem];
    }
}

-(void)shareArticleWithImage:(UIImage*)image
{
    [UMengUtils shareWebWithTitle:self.currentNews.title detail:self.currentNews.subtitle url:self.currentNews.contentUrl image:image viewController:self];
    [UserViewModel fetchSaveShareType:@"article" completion:^(NSError *error, id object) {
        
    }];
}

@end
