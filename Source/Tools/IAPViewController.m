//
//  IAPViewController.m
//  rehab
//
//  Created by yefangyang on 2016/12/28.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "IAPViewController.h"
#import "SVProgressHUD.h"
#import "IAPManager.h"
#import "PayCenter.h"

enum{
    IAPProduct02,
}buyCoinsTag;

//在内购项目中创的商品单号
#define ProductID_IAP02 @"well.rehab.health02"

@interface IAPViewController ()/** 所有的产品 */{
    CGFloat progress;
}
@property (nonatomic,strong) UIProgressView *pro ;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, copy) NSString *currentProId;
@property (nonatomic, assign) NSInteger buyType;

@end

@implementation IAPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    //    [self buy:IAP0p20];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 50);
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"6元" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
    
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    retryButton.frame = CGRectMake(100, 200, 100, 50);
    retryButton.backgroundColor = [UIColor greenColor];
    [retryButton setTitle:@"重试" forState:UIControlStateNormal];
    [retryButton addTarget:self action:@selector(trybtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:retryButton];
    
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = @"iapreceipt";
//    NSString *str = [ud objectForKey:key];
//    NSLog(@"iapreceipt%@",str);
}

- (void)setUpSubView
{
    //实例化一个进度条，有两种样式，一种是UIProgressViewStyleBar一种是UIProgressViewStyleDefault，然并卵-->>几乎无区别
    UIProgressView *pro=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
    pro.frame=CGRectMake(30, 100, [UIScreen mainScreen].bounds.size.width - 60, 50);
    //设置进度条颜色
    pro.trackTintColor=[UIColor blackColor];
    //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
    //pro.progress=0.7;
    //设置进度条上进度的颜色
    pro.progressTintColor=[UIColor redColor];
    //设置进度条的背景图片
    // pro.trackImage=[UIImage imageNamed:@"1"];
    //设置进度条上进度的背景图片 IOS7后好像没有效果了)
    //  pro.progressImage=[UIImage imageNamed:@"1.png"];
    //设置进度值并动画显示
    //  [pro setProgress:0.7 animated:YES];
    
    //由于pro的高度不变 使用放大的原理让其改变
    pro.transform = CGAffineTransformMakeScale(1.0f, 10.0f);
    //自己设置的一个值 和进度条作比较 其实为了实现动画进度
    progress= 0.7;
    [self.view addSubview:pro];
    self.pro =pro;
    
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(progressChanged:)
                                   userInfo:nil
                                    repeats:YES];
}
-(void)progressChanged:(NSTimer *)timer
{
    _pro.progress += 0.005;
    if (_pro.progress >= progress) {
        [timer invalidate];
    }
}


- (void)trybtnClick:(UIButton *)button
{
    [[PayCenter defaultCenter] retrycomplete];
}

- (void)btnClick:(UIButton *)button
{
    [[PayCenter defaultCenter] test];
//    [[IAPManager sharedInstance] test];
}



@end
