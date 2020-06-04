//
//  WrWebViewController.m
//  rehab
//
//  Created by yongen zhou on 2017/8/7.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WrWebViewController.h"
#import "UIWebView+MSJavaScriptBridge.h"
#import "FeedbackController.h"
#import "FriendSendController.h"
#import "ArticleDetailController.h"
#import "WRFAQViewModel.h"
#import <WebKit/WebKit.h>
@interface WrWebViewController ()<UIWebViewDelegate>
@property (nonatomic)  UIWebView *wv;
@property (nonatomic) BOOL isfinish;
@property BOOL pullrefresh;
@end

@implementation WrWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isfinish =NO;
    self.wv = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.view.height)];
    self.wv.delegate = self;
    self.wv.backgroundColor = [UIColor clearColor];
    self.wv.allowsInlineMediaPlayback = YES;
    [self.view addSubview:self.wv];
    
//    [SVProgressHUD show];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (!self.isfinish) {
    [self.wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        [SVProgressHUD show];
    [self loadJs];
    }
    if (self.ifrefresh) {   
        [self refresh];
            }
    
    
    
}
- (void)loadJs
{
    [self.wv ms_registerHandler:@"sendNewMessage" handler:^(id data, MSJSBCallback callback) {
        FriendSendController * feevc= [FriendSendController new];
        feevc.hidesBottomBarWhenPushed = YES;
        feevc.iffriend = YES;
        feevc.crid = [NSString stringWithFormat:@"%@",data];
        [self.navigationController pushViewController:feevc animated:YES];
        
    }];
    
    [self.wv ms_registerHandler:@"naviBack" handler:^(id data, MSJSBCallback callback) {
        
            //判断是否有上一层H5页面
            if (self.wv.canGoBack) {
                //如果有则返回
                [self.wv goBack];
                
            } else {
                BOOL ifback = [data[@"isRefresh"]  boolValue];
                self.callBack = data[@"callBack"];
                self.ifrefresh = ifback;
                [self closeNative];
            }
        
        
        
        
    }];
    
    [self.wv ms_registerHandler:@"openNewPage" handler:^(id data, MSJSBCallback callback) {
        WrWebViewController * feevc= [WrWebViewController new];
        feevc.hidesBottomBarWhenPushed = YES;
        feevc.url = data;
        [self.navigationController pushViewController:feevc animated:YES];
        
    }];
    
    [self.wv ms_registerHandler:@"refreshOnPullpage" handler:^(id data, MSJSBCallback callback) {
        self.pullrefresh = YES;
    }];
    
    [self.wv ms_registerHandler:@"showArticle" handler:^(id data, MSJSBCallback callback) {
        [self.wv ms_callHandler:@"fun"];
        [WRFAQViewModel userGetFavorStateWithArticleId:data completion:^(NSError *error, WRArticle *article) {
            
            UINavigationController* navi  = self.navigationController;                ArticleDetailController* art = [ArticleDetailController new];
            art.hidesBottomBarWhenPushed = YES;
            art.currentNews = article;
            [navi pushViewController:art animated:YES];
            
        }];
    }];
    
}


//js
- (void)refresh
{
    [self.wv reload];
}

//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    int i = 0;
    for (UIViewController* vc in [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects] ) {
        if ([vc isKindOfClass:[WrWebViewController class]]&&vc!=self&&i==0) {
            WrWebViewController* web = vc;
            web.ifrefresh =self.ifrefresh;
            web.callBack = self.callBack;
            [self.navigationController popToViewController:web animated:YES];
            i++;
        }
    }

    if (i==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStart");
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"didStart");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"didFinish");
    self.isfinish = YES;
    [SVProgressHUD dismiss];
    if (self.ifrefresh) {
        [self.wv ms_callHandler:_callBack];
        self.callBack = nil;
    }
    
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    if (app.taburl) {
        WrWebViewController * feevc= [WrWebViewController new];
        feevc.hidesBottomBarWhenPushed = YES;
        feevc.url = app.taburl.mutableCopy;
        [self.navigationController pushViewController:feevc animated:YES];
        app.taburl = nil;
    }
    
    if (webView.isLoading) {
        return;
    }
    
    
    NSString* str = webView.request.URL.absoluteString;
    NSLog(@"%@",str);
    
    NSString *ns = @"document.documentElement.innerHTML";
    str = [webView stringByEvaluatingJavaScriptFromString:ns];
    NSLog(@"%@",str);
}
- (void)dealloc {
    self.wv.delegate = nil;
    [self.wv stopLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFail");
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
