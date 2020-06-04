//
//  AdvertiseViewController.m
//  rehab
//
//  Created by yefangyang on 2016/12/9.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "AdvertiseViewController.h"

#import "AdvertiseView.h"

@interface AdvertiseViewController ()

@property (nonatomic, copy) NSString *imageUrl;

@end

@implementation AdvertiseViewController

- (instancetype)initWithImageUrl:(NSString *)imageUrl
{
    if (self = [super init]) {
        self.imageUrl = imageUrl;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.advertiseView];
}

- (AdvertiseView *)advertiseView
{
    if (_advertiseView == nil) {
        _advertiseView = [[AdvertiseView alloc]initWithFrame:self.view.bounds imageUrl:self.imageUrl];
    }
    return _advertiseView;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
