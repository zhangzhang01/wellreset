//
//  PreventVideosController.m
//  rehab
//
//  Created by herson on 2016/11/17.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "PreventVideosController.h"



#import "WRScene.h"

#import "PreventPlayerController.h"

#import <YYKit/YYKit.h>
#import "NetworkNotifier.h"
@interface PreventVideosController ()
{
    UIColor *_mostColor;
    WRScene *_scene;
    NSDate *_startDate;
}
@property(nonatomic) UIImageView *bannerImageView;
@property NetworkNotifier * networkNotifier ;


@end

@implementation PreventVideosController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForPreventCategory:_scene.name duration:duration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _startDate = [NSDate date];
    [self createBackBarButtonItem];
//    self.navigationItem.title = _scene.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
}



#pragma mark - getter & setter
-(UIImageView*)bannerImageView {
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] init];
    }
    return _bannerImageView;
}

#pragma mark -
-(UIView*)createItemWithStageVideo:(WRTreatRehabStageVideo*)stageVideo
{
    UIView *container = self.bannerImageView;
    
    CGRect frame = container.bounds;
    CGFloat offset = WRUIOffset, x = offset, y = x, cx = frame.size.width - 2*x, cy;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, frame.size.width, 0)];
    /*
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, offset, offset)];
    pointView.layer.masksToBounds = YES;
    pointView.layer.cornerRadius = pointView.width/2;
    pointView.backgroundColor = _mostColor;//[UIColor colorWithHexString:@"6fd6f6"];
    */
    
    UIImageView *pointView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"well_prevent_oval"]];
    pointView.frame = [Utility moveRect:pointView.frame x:0 y:0];
    
    UILabel *label = [UILabel new];
    label.font = [UIFont wr_titleFont];
    label.numberOfLines = 1;
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    label.text = stageVideo.videoName;
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:(x + pointView.width + offset) y:y];
    [view addSubview:label];
    y = label.bottom + offset;
    
    pointView.frame = CGRectMake(x, label.centerY - pointView.height/2, pointView.width, pointView.height);
    [view addSubview:pointView];
    
    NSString *text = stageVideo.attention;
    if (stageVideo.muscle)
    {
        text = [NSString stringWithFormat:@"%@\n%@\n%@\n", stageVideo.muscle.muscle, stageVideo.muscle.advantages, stageVideo.muscle.disadvantage];
    }
    label = [UILabel new];
    label.font = [UIFont wr_textFont];
    label.numberOfLines = 0;
    label.textColor = [UIColor grayColor];
    label.text = text;
    CGSize tempSize = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = CGRectMake(x, y, cx, tempSize.height);
    [view addSubview:label];
    y = label.bottom + offset;
    
    x = 0;
    cx = view.width;
    UIImage *holderImage = [UIImage imageNamed:@"well_default_video"];
    cy = cx*holderImage.size.height/holderImage.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
    [imageView setImageWithUrlString:stageVideo.thumbnailUrl holderImage:holderImage];
    [view addSubview:imageView];
    
    UIView *maskView = [[UIView alloc] initWithFrame:imageView.bounds];
    maskView.backgroundColor = [_mostColor colorWithAlphaComponent:0.10];
    [imageView addSubview:maskView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"well_icon_video_thumb"]];
    [imageView addSubview:iconImageView];
    iconImageView.center = CGPointMake(imageView.width/2, imageView.height/2);
    
    y = imageView.bottom;
    
    view.frame = [Utility resizeRect:view.frame cx:-1 height:y];
    view.backgroundColor = [UIColor wr_lightWhite];
    return view;
}

-(void)setScene:(WRScene *)scene banner:(UIImage *)bannerImage mostColor:(UIColor*)mostColor
{
    _scene = scene;
    self.navigationItem.title = _scene.name;
    [self.scrollView removeAllSubviews];
    _bannerImageView = nil;
    
    UIView *container = self.scrollView;
    
    CGRect frame = container.bounds;
    CGFloat offset = 2*WRUIOffset, x = 0, y = -64, cx = frame.size.width - 2*x;
    
//    cy = cx*bannerImage.size.height/bannerImage.size.width;
    
    self.bannerImageView.frame = CGRectMake(x, y, cx, 0);
    self.bannerImageView.image = bannerImage;
    [container addSubview:_bannerImageView];
    y = self.bannerImageView.bottom;
    
    _mostColor = mostColor;
    
    NSInteger index = 0;
    __weak __typeof(self) weakSelf = self;
    for(WRTreatRehabStageVideo *video in scene.videos)
    {
        UIView *itemView = [self createItemWithStageVideo:video];
        itemView.userInteractionEnabled = YES;
        [itemView bk_whenTapped:^{
            [weakSelf playWithStage:video];
        }];
        itemView.frame = [Utility moveRect:itemView.frame x:0 y:y];
        [container addSubview:itemView];
        y = itemView.bottom;
        
        if (index == (scene.videos.count - 1)) {
            break;
        }
        
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(itemView.left, y, itemView.width, offset)];
        sectionView.backgroundColor = [UIColor whiteColor];
        [container addSubview:sectionView];
        
        y = sectionView.bottom;
        
        index++;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, MAX(y, self.scrollView.height)+100);
}

-(void)playWithStage:(WRTreatRehabStageVideo*)video
{
    self.networkNotifier = [[NetworkNotifier alloc] initWithController:self];
    __weak __typeof(self)weakself = self;
    
    self.networkNotifier.continueBlock = ^(NSInteger index){
        if (index == 0) {
            
            [UMengUtils careForPreventVideo:video.videoName];
            PreventPlayerController *player = [[PreventPlayerController alloc] initWithTreatRehabStageVideo:video stageSets:_scene.videos];
            [self.navigationController presentViewController:player animated:YES completion:nil];
            
        }
        else
        {
            weakself.networkNotifier =nil;
        }
    };
    
    
}
@end
