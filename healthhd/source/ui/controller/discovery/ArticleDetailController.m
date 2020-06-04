//
//  ArticleDetailController.m
//  rehab
//
//  Created by 何寻 on 6/3/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ArticleDetailController.h"
#import "WRViewModel.h"
#import "SVProgressHUD.h"
#import "UMengUtils.h"

@interface ArticleDetailController ()
{
    NSDate *_startDate;
}
@property(nonatomic)UIImage *contentImage;
@end

@implementation ArticleDetailController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForArticleCategory:self.currentNews.title duration:duration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    _startDate = [NSDate date];
    [WRNetworkService pwiki:@"资讯详情"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
#pragma mark - event
-(IBAction)onClickedFavorControl:(UIBarButtonItem*)sender {
    sender.enabled = NO;
    __weak __typeof(self) weakSelf = self;
    [WRViewModel operationWithType:WROperationTypeFavor indexId:self.currentNews.uuid flag:!self.currentNews.favor contentType:WRContentTypeArticle completion:^(NSError * _Nonnull error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"收藏失败", nil)];
        } else {
            weakSelf.currentNews.favor = !weakSelf.currentNews.favor;
            [weakSelf initBarItems];
        }
    }];
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
-(void)setCurrentNews:(WRArticle *)currentNews {
    _currentNews = currentNews;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentNews.contentUrl]]];
    self.title = currentNews.title;
    
    [self initBarItems];
    
    [WRViewModel operationWithType:@"wechat" indexId:currentNews.uuid flag:YES contentType:@"" completion:^(NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@", error.domain);
        }
    }];
}

-(void)initBarItems
{
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"well_icon_share"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedShareButton:)];
    UIBarButtonItem *favorItem = [self createFavorBarButtonItem:self.currentNews.favor];
    favorItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, -25);
    self.navigationItem.rightBarButtonItems = @[shareItem, favorItem];
}

-(void)shareArticleWithImage:(UIImage*)image
{
    [UMengUtils shareWebWithTitle:self.currentNews.title detail:self.currentNews.subtitle url:self.currentNews.contentUrl image:image viewController:self];
}

@end
