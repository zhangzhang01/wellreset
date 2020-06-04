//
//  WRBaseViewController.m
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "WRBaseViewController.h"

#import "Masonry/Masonry.h"
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#define DECLARE_STYLE -(BOOL)shouldAutorotate {\
return YES;\
}\
\
-(UIInterfaceOrientationMask)supportedInterfaceOrientations {\
    return UIInterfaceOrientationMaskPortrait;\
}\
\
-(UIStatusBarStyle)preferredStatusBarStyle {\
    return UIStatusBarStyleLightContent;\
}\

@interface WRViewController ()

@end

@implementation WRViewController

-(instancetype)init {
    if(self = [super init]){
        self.view.backgroundColor = [UIColor wr_bgColor];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


DECLARE_STYLE

#pragma mark -
-(CGRect)getClientFrame {
    return self.view.bounds;
}
@end

@implementation WRNavigationController
DECLARE_STYLE
@end


@implementation WRBaseNavigationController
DECLARE_STYLE
@end

@implementation WRTableViewController
DECLARE_STYLE

-(void)defaultStyle {
    self.view.backgroundColor = [UIColor wr_bgColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end

#pragma mark - WRTextViewController
@implementation WRTextViewController

DECLARE_STYLE

-(void)viewDidLoad {
    [super viewDidLoad];
    UITextView *textView = [[UITextView alloc] init];
    textView.editable = NO;
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.offset(WRUIOffset);
    }];
    self.textView = textView;
}
@end

#pragma mark - WRWebViewController
@implementation WRWebViewController

DECLARE_STYLE

-(void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webview = [[UIWebView alloc] init];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.webView = webview;
}
@end

@implementation WRScrollViewController

-(instancetype)init {
    if(self = [super init]){
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        scrollView.backgroundColor = [UIColor wr_bgColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        self.view = scrollView;
        self.scrollView = scrollView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

DECLARE_STYLE

@end


@implementation WRInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat offset = WRUIOffset;
    UITextView *textView = [[UITextView alloc] init];
    [textView wr_roundBorder];
    textView.font = [UIFont wr_textFont];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).with.insets(UIEdgeInsetsMake(64 + offset, offset, 0, offset));
        make.height.mas_equalTo(200);
    }];
    self.textView = textView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onClickedCancelButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onClickedSubmitButton:)];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

DECLARE_STYLE

#pragma mark - IBActions
-(IBAction)onClickedCancelButton:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onClickedSubmitButton:(id)sender {
    if (self.completion) {
        self.completion();
    }
    [self.view endEditing:YES];
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

@end

