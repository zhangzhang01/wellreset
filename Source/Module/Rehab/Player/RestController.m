//
//  RestController.m
//  rehab
//
//  Created by yongen zhou on 2017/8/15.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "RestController.h"
#import "MBCircularProgressBarView.h"
@interface RestController ()
{
    NSTimer *_timer;
    UIInterfaceOrientationMask _supportUIInterfaceOrientation;
}
@property MBCircularProgressBarView* progressBarView;
@property(nonatomic)NSInteger currentTotalTime, currentTimeValue;
@property UIButton* probtn;
@property UILabel* stitle;
@property UILabel* dtitle;
@property UIImageView* im;
@property CGFloat yh;
@end

@implementation RestController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:)name:UIDeviceOrientationDidChangeNotification object:nil];
    
    _supportUIInterfaceOrientation = UIInterfaceOrientationMaskAll;
       // Do any additional setup after loading the view.
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _supportUIInterfaceOrientation;
}




-(void)viewWillAppear:(BOOL)animated
{
    [self setLayout];
    self.currentTimeValue = 0;
    self.currentTotalTime = 10;
    if (_timer == nil&&!self.Ifpause) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerProc) userInfo:nil repeats:YES];
        [_timer fire];
    }
}
- (void)layout
{
    [self.view removeAllSubviews];
    NSLog(@"-----%lf",self.view.width);
    UILabel* title = [UILabel new];
    title.text = @"接下来锻炼的动作";
    title.y = 63;
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UIColor wr_titleTextColor];
    [title sizeToFit];
    title.centerX = self.view.centerX;
    [self.view addSubview:title];
    self.stitle = title;
    
    UILabel* dtitle = [UILabel new];
    dtitle.text = self.nextStr;
    dtitle.y = title.bottom+63;
    dtitle.font = [UIFont boldSystemFontOfSize:15];
    dtitle.textColor = [UIColor wr_titleTextColor];
    [dtitle sizeToFit];
    dtitle.centerX = self.view.centerX;
    [self.view addSubview:dtitle];
    self.dtitle = dtitle;
    
    UIImageView* im = [UIImageView new];
    [im setImageURL:[NSURL URLWithString:self.nextIm]];
    im.width = 218;
    im.height = 124;
    im.y = dtitle.bottom+17;
    im.centerX = self.view.centerX;
    [self.view addSubview:im];
    self.im = im;
    
    
    CGFloat cx = 100;
    CGFloat cy = cx;
    MBCircularProgressBarView *bar = [[MBCircularProgressBarView alloc] initWithFrame:CGRectMake(0, 0, cx, cy)];
    bar.backgroundColor = [UIColor clearColor];
    bar.progressAngle = 100;
    bar.progressLineWidth = 3;
    bar.progressStrokeColor = [UIColor orangeColor];
    bar.progressColor = bar.progressStrokeColor;
    bar.showValueString = NO;
    [bar setEmptyLineColor:[UIColor wr_lightGray]];
    if (!self.Ifpause) {
        [self.view addSubview:bar];
    }
    
    CGFloat y = self.view.height - self.yh;
    bar.center = CGPointMake(self.view.width/2, y + cy/2);
    self.progressBarView = bar;
    
    CGFloat offset = 15;
    CGFloat x ;
    UIImage *image = [UIImage imageNamed:@"rehab_player_previous"];
    cx = 72, cy = 73;
    x = bar.left - cx - 2*offset;
    y = bar.centerY - cy/2;
    UIImage *disableImage = [UIImage imageNamed:@"rehab_player_previous_disable"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
   // [button setImage:image forState:UIControlStateNormal];
   // [button setImage:disableImage forState:UIControlStateDisabled];
    
    button.frame = CGRectMake(x, y, cx, cy);
  //  [self.view addSubview:button];
//    self.previousButton = button;
    
    image = [UIImage imageNamed:@"暂停按钮"];
    disableImage = [UIImage imageNamed:@"rehab_player_next_disable"];
    x = bar.right + 2*offset;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
   // [button setImage:image forState:UIControlStateNormal];
  //  [button setImage:disableImage forState:UIControlStateDisabled];
    button.frame = CGRectMake(x, y, cx, cy);
   
 //   [self.view addSubview:button];
//    self.nextButton = button;
    
    
    button.layer.cornerRadius = button.width/2;
    button.hidden = NO;
    [self.view addSubview:button];
    button.center = self.progressBarView.center;
    button.backgroundColor = [UIColor wr_rehabBlueColor];
    [button setTitle:@"10" forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    [button setImage:image forState:0];
//    if (self.Ifpause) {
        [button bk_addEventHandler:^(UIButton* sender) {
            [self dismissViewControllerAnimated:YES completion:^{
                [_timer invalidate];
                _timer = nil;
                self.completionBlock();
            }];
        } forControlEvents:UIControlEventTouchUpInside];
        self.probtn = button;
//    }
    
    
    UIView *view = [[UIView alloc] initWithFrame:button.frame];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.width/2;
    view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:view belowSubview:button];
    
    UILabel* ttitle = [UILabel new];
    ttitle.text = @"跳过休息";
    if (self.Ifpause) {
        ttitle.text = @"继续锻炼";
    }
    ttitle.y = view.bottom+27;
    ttitle.font = [UIFont systemFontOfSize:16];
    ttitle.textColor = [UIColor wr_detailTextColor];
    [ttitle sizeToFit];
    ttitle.centerX = self.view.centerX;
    [self.view addSubview:ttitle];
    ttitle.userInteractionEnabled = YES;
    [ttitle bk_whenTapped:^{
        [self dismissViewControllerAnimated:YES completion:^{
            [_timer invalidate];
            _timer = nil;
            self.completionBlock();
        }];
    }];
    
    
    
    
}

-(void)timerProc
{
    self.currentTimeValue++;
    if (self.currentTimeValue>=self.currentTotalTime)
    {
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            [_timer invalidate];
            _timer = nil;
            self.completionBlock();
        }];
    }
    [self updateControls];
    
}

-(void)updateControls
{
    [self.probtn setTitle:[NSString stringWithFormat:@"%ld", self.currentTotalTime-self.currentTimeValue] forState:0] ;
    
   
    
    if (self.currentTimeValue == 0) {
        self.progressBarView.value = 0;
    } else {
        [self.progressBarView setValue:(self.currentTimeValue*100)/self.currentTotalTime animateWithDuration:self.currentTimeValue/100];
    }
}
#pragma mark -

//通过通知监听屏幕旋转


static UIInterfaceOrientation lastType = UIInterfaceOrientationPortrait;

- (void)OrientationDidChange:(UIInterfaceOrientation)fromInterfaceOrientation
{
    lastType = fromInterfaceOrientation;
    
    [self setLayout];
}
-(void)setLayout
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    lastType = orientation;
    NSLog(@"-----%lf",self.view.width);
    if ((lastType == UIInterfaceOrientationLandscapeLeft) || (lastType == UIInterfaceOrientationLandscapeRight))
    {
        
        self.yh = 75+106;
        
        
    }
    
    
    
    if ((lastType == UIInterfaceOrientationPortrait) || (lastType == UIInterfaceOrientationPortraitUpsideDown))
    {
        
        
        self.yh = 272;
        
    }
    [self layout];
    
    if ((lastType == UIInterfaceOrientationLandscapeLeft) || (lastType == UIInterfaceOrientationLandscapeRight))
    {
        
        self.im.width = 85;
        self.im.height =49;
        self.im.y = self.stitle.bottom+42;
        self.im.layer.borderColor = [UIColor wr_themeColor].CGColor;
        self.im.layer.borderWidth = 1;
        
        self.im.x = (YYScreenSize().height-326)*1.0/2;
        
        self.dtitle.x = self.im.right;
        self.dtitle.width = 240;
        self.dtitle.height = 49;
        self.dtitle.layer.borderColor = [UIColor wr_themeColor].CGColor;
        self.dtitle.layer.borderWidth = 1;
        self.dtitle.textAlignment = NSTextAlignmentCenter;
        self.dtitle.y = self.stitle.bottom+42;
        
        
        
    }
    
    
    
    if ((lastType == UIInterfaceOrientationPortrait) || (lastType == UIInterfaceOrientationPortraitUpsideDown))
    {
        
        _dtitle.y = self.stitle.bottom+63;
        
        _dtitle.centerX = self.view.centerX;
        
        
        _im.width = 218;
        _im.height = 124;
        _im.y = _dtitle.bottom+17;
        _im.centerX = self.view.centerX;
        self.dtitle.layer.borderColor = [UIColor clearColor].CGColor;

        self.im.layer.borderColor = [UIColor clearColor].CGColor;
        
        
        
    }

}


@end
