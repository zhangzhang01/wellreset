//
//  WRTeatRehabStageController.m
//  rehab
//
//  Created by herson on 16/4/2.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "WRRehabStageController.h"
#import "RehabObject.h"
#import "WRMediaPlayer.h"
#import "SDPhotoBrowser.h"
#import "WRToolView.h"
#import "RehabObject.h"

#import <YYKit/YYKit.h>

#import "WRViewModel+Common.h"

@interface WRRehabStageController ()<SDPhotoBrowserDelegate>
{
    CGRect _playViewSmallFrame;
    WRMediaPlayer *_playerView;
    BOOL _isManualRotate;
    BOOL _isFullScreenMode;
    UIInterfaceOrientationMask _supportUIInterfaceOrientation;
    
    WRToolView *_toolView;
    UIStatusBarStyle oldStatusBarStyle;
    
    NSDate *_startDate;
}
@property(nonatomic, weak) WRTreatRehabStage* stage;
@property(nonatomic) NSArray<WRTreatRehabStage *>* stageSets;

@property(nonatomic)UIScrollView *scrollView, *therbligImageScrollView;
@property(nonatomic)UILabel *titleLabel, *detailLabel;
@property(nonatomic)YYAnimatedImageView *animatedImageView;

@property (assign) BOOL applicationIdleTimerDisabled, isMaxing, isWWAN, isProTreat;
@property (nonatomic, assign) NSUInteger currentIndex;
@end

@implementation WRRehabStageController

-(void)dealloc {
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForStage:self.stage.mtWellVideoInfo.videoName duration:duration];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
}

-(instancetype)initWithTreatRehabStage:(id)stage stageSets:(NSArray *)stageSets isProTreat:(BOOL)isProTreat
{
    if (self = [super init]) {
        _startDate = [NSDate date];
        
        _stageSets = stageSets;
        _stage = _stageSets.firstObject;
        _isProTreat = isProTreat;
        
        _isManualRotate = NO;
        _isFullScreenMode = NO;
        _supportUIInterfaceOrientation = UIInterfaceOrientationMaskAll;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    [self createFavorBarButtonItem:NO];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.applicationIdleTimerDisabled = [UIApplication sharedApplication].isIdleTimerDisabled;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    if (!self.scrollView) {
        CGFloat offset = WRUIOffset,  x, y, cx = 0, cy = 0;
        CGRect frame = self.view.bounds;
        UIImage *image = [UIImage imageNamed:@"well_icon_left"];
        
        cy = image.size.height + 2*offset;
        y = frame.size.height - cy;
        x = 0;
        cx = frame.size.width - 2*x;
        
        WRToolView *toolView = [[WRToolView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        toolView.backgroundColor = [[UIColor wr_themeColor] colorWithAlphaComponent:0.8];
        [self.view addSubview:toolView];
        _toolView = toolView;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - _toolView.height)];
        [self.view addSubview:scrollView];
        self.scrollView = scrollView;
        
        [toolView.previousButton addTarget:self action:@selector(onClickedPreviousButton:) forControlEvents:UIControlEventTouchUpInside];
        [toolView.nextButton addTarget:self action:@selector(onClickedNextButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.currentIndex = [self.stageSets indexOfObject:self.stage];
    }
    
    oldStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = self.applicationIdleTimerDisabled;
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = oldStatusBarStyle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _supportUIInterfaceOrientation;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate
{
    NSLog(@"shouldAutorotate");
    return YES;
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.scrollView.frame = [Utility resizeRect:self.scrollView.frame cx:self.view.bounds.size.width height:-1];
}


#pragma mark - getter & setter
-(YYAnimatedImageView *)animatedImageView {
    if (!_animatedImageView) {
        _animatedImageView = [[YYAnimatedImageView alloc] init];
    //    [self.scrollView addSubview:self.animatedImageView];
    }
    return _animatedImageView;
}

#pragma mark - SDPhotoBrowserDelegate
-(UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return [UIImage imageNamed:@"well_default"];
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    WRTreatRehabStageVideoTherbligImage *therbligImage = self.stage.mtWellVideoInfo.images[index];
    return [NSURL URLWithString:therbligImage.imageUrl];
}

-(NSString *)photoBrowser:(SDPhotoBrowser *)browser detailForIndex:(NSInteger)index {
    WRTreatRehabStageVideoTherbligImage *therbligImage = self.stage.mtWellVideoInfo.images[index];
    return therbligImage.detail;
}

#pragma mark - IBActions
-(IBAction)gestureTapEvent:(UITapGestureRecognizer*)tapGesture {
    UIImageView *imageView = (UIImageView*)tapGesture.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = imageView.superview;
    browser.imageCount = self.stage.mtWellVideoInfo.images.count;
    browser.currentImageIndex = imageView.tag;
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
    
    WRTreatRehabStageVideoTherbligImage *therbligImage = self.stage.mtWellVideoInfo.images[imageView.tag];
    [UMengUtils careForStageVideoImage:therbligImage.name];
}

-(IBAction)onClickedArrowButton:(UIButton*)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onClickedPlayerResizeButton:(UIButton*)sender {
    //[self switchInterfaceOrientationAnimated:YES];
    //UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    /*
    BOOL shouldFullScreen = !sender.selected;
    [UIApplication sharedApplication].statusBarHidden = shouldFullScreen;
    [_playerView setViewScaleTyle:shouldFullScreen];
     */
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = (orientation == UIDeviceOrientationPortrait) ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}



-(IBAction)onClickedPreviousButton:(UIButton*)sender {
    self.currentIndex--;
}

-(IBAction)onClickedNextButton:(UIButton*)sender {
    self.currentIndex++;
}

-(IBAction)onClickedFavorBarButton:(UIBarButtonItem*)sender
{
    if ([self checkUserLogState:self.navigationController]) {
        sender.enabled = NO;
        __weak __typeof(self) weakSelf = self;
        [WRViewModel operationWithType:OperationTypeFavor indexId:self.stage.indexId
                            actionType:OperationActionTypeAdd
                           contentType:(self.isProTreat ? OperationContentTypeProTreatStage : OperationContentTypeTreatStage)
                            completion:^(NSError * _Nonnull error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"收藏失败", nil)];
            } else {
                [weakSelf createFavorBarButtonItem:NO];
            }
        }];
    }
}

#pragma mark - private method
-(void)createFavorBarButtonItem:(BOOL)flag {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:(flag ? @"well_icon_like_focus" : @"well_icon_like")] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedFavorBarButton:)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)setCurrentIndex:(NSUInteger)currentIndex {
    
    _currentIndex = currentIndex;
    self.stage = self.stageSets[_currentIndex];
    
    NSString *title = self.stage.mtWellVideoInfo.videoName;
    [_toolView.centerButton setTitle:title forState:UIControlStateNormal];
    _toolView.previousButton.hidden = _currentIndex <= 0;
    _toolView.nextButton.hidden = _currentIndex >= (self.stageSets.count - 1);
    
    [self layoutWithStage:self.stage];
}

#pragma mark - orientation changed



-(void)layoutWithStage:(WRTreatRehabStage*)stage {
    self.title = stage.mtWellVideoInfo.videoName;
    
    BOOL iPad = [WRUIConfig IsHDApp];
    UIColor *lineColor = [UIColor wr_lineColor];
    
    UIFont *subTitleFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_labelFont];
    UIFont *textFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_smallFont];
    
    UIScrollView *scrollView = self.scrollView;
    UIView *container = self.scrollView, *lineView;;
    
    CGRect frame = scrollView.bounds;
    CGFloat offset = WRUIOffset, x = 0, y , cx = 0, cy = 0;
    y = x + 20;
    CGSize size;

    [container.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != _playerView) {
            [obj removeFromSuperview];
        }
    }];

    {
        y = 0;
        x = 0;
        cx = frame.size.width - 2*x;
        cy = 9*cx/16;
/*
        if(![Utility IsEmptyString:stage.mtWellVideoInfo.gifUrl])
        {
            self.animatedImageView.frame = CGRectMake(x, y, cx, cy);
            _playViewSmallFrame =CGRectMake(x, y, cx, cy);
            y = self.animatedImageView.bottom;
            //下载gif
            __weak __typeof(self) weakSelf = self;
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:stage.mtWellVideoInfo.gifUrl]];
                if (data) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        weakSelf.animatedImageView.image = [YYImage imageWithData:data];
                    }];
                } else {
                    NSLog(@"-------Error:download gif %@", stage.mtWellVideoInfo.gifUrl);
                }
            });
        }
        
*/
        
        CGRect controlFrame = CGRectMake(scrollView.left, 0, scrollView.frame.size.width, scrollView.height - 0);
        scrollView.frame = controlFrame;
        
        BOOL isFullScreen = (self.view.bounds.size.width > self.view.bounds.size.height);
        if (!_playerView) {
            _playerView = [[WRMediaPlayer alloc]init];
            [self.scrollView addSubview:_playerView];
        }
        _playerView.frame = isFullScreen ? self.view.bounds : _playViewSmallFrame;
        //self.closeImageView.hidden = isFullScreen;
        _playerView.backButton.hidden = YES;
        _playerView.disableOnTouch = YES;
        

        if (_playerView)
        {
            
            [_playerView stop];
            
            [_playerView hideControls];
            
            if (![Utility IsEmptyString:stage.mtWellVideoInfo.videoUrl])
            {
                [_playerView setContent:[NSURL URLWithString:stage.mtWellVideoInfo.videoUrl] autoStart:NO];
            }
            
        }
        
        
        
        
        
    }
    
    x = offset;
    cx = scrollView.frame.size.width - 2*x;
    y += 2*offset;
    UILabel *label;
    /*
    UILabel *label;
    label = [[UILabel alloc] init];
    label.textColor = [UIColor wr_themeColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.frame = CGRectMake(x, y, cx, 0);
    label.font = iPad ? [UIFont wr_bigTitleFont] : [UIFont wr_titleFont];
    label.text = stage.mtWellVideoInfo.videoName;
    CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = [Utility resizeRect:label.frame cx:-1 height:size.height];
    [scrollView addSubview:label];
    self.titleLabel = label;
    y = label.bottom + 2*offset;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, container.width, WRUILineHeight)];
    lineView.backgroundColor = lineColor;
    [container addSubview:lineView];
    y = lineView.bottom + offset;
    */
    
    x = offset;
    CGFloat pointX = x;
    if (stage.mtWellVideoInfo.attributes.count  > 0) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.textColor = [UIColor lightGrayColor];
        label.text = NSLocalizedString(@"要点", nil);
        label.font = subTitleFont;
        [label sizeToFit];
        label.frame = [Utility moveRect:label.frame x:x y:y];
        [container addSubview:label];
        y = label.bottom + offset;
        
        for(NSUInteger index = 0; index < stage.mtWellVideoInfo.attributes.count; index++)
        {
            x = offset;
            
            WRObject *obj = stage.mtWellVideoInfo.attributes[index];
            label = [[UILabel alloc] init];
            label.textColor = [UIColor wr_themeColor];
            label.text = NSLocalizedString(@" ● ", nil);
            label.font = textFont;
            [label sizeToFit];
            label.frame = [Utility moveRect:label.frame x:x y:y];
            [container addSubview:label];
            
            x = label.right + 3;
            pointX = x;
            label = [[UILabel alloc] init];
            label.textColor = [UIColor darkGrayColor];
            label.text = obj.detail;
            label.font = textFont;
            label.numberOfLines = 0;
            size = [label sizeThatFits:CGSizeMake(frame.size.width - offset - x, CGFLOAT_MAX)];
            label.frame = CGRectMake(x, y, size.width, size.height);
            [container addSubview:label];
            
            y = label.bottom + offset;
        }
    }
    
    if (![Utility IsEmptyString:stage.mtWellVideoInfo.notice]) {
        x = offset;
        label = [[UILabel alloc] init];
        label.textColor = [UIColor wr_purpleColor];
        label.text = NSLocalizedString(@" ● ", nil);
        label.font = textFont;
        [label sizeToFit];
        label.frame = [Utility moveRect:label.frame x:x y:y];
        [container addSubview:label];
        
        x = label.right + 3;
        cx = frame.size.width - offset - x;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.textColor = [UIColor darkGrayColor];
        label.text = stage.mtWellVideoInfo.notice;
        label.font = textFont;
        size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y, size.width, size.height);
        [container addSubview:label];
        y = label.bottom + offset;
    }
    
    y += offset;
    NSString *text = stage.mtWellVideoInfo.attention;
    if (![Utility IsEmptyString:text]) {

        cx = frame.size.width - offset - x;
        x = offset;
        
        label = [[UILabel alloc] init];
        label.textColor = [UIColor orangeColor];
        label.text = NSLocalizedString(@" ● ", nil);
        label.font = textFont;
        [label sizeToFit];
        label.frame = [Utility moveRect:label.frame x:x y:y];
        [container addSubview:label];
        
        x = label.right + 3;
        label = [[UILabel alloc] init];
        label.textColor = [UIColor wr_themeColor];
        label.text = text;
        label.font = textFont;
        label.numberOfLines = 0;
        size = [label sizeThatFits:CGSizeMake(frame.size.width - offset - x, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y, size.width, size.height);
        [container addSubview:label];
        
        y = label.bottom + offset;
    }
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, container.width, WRUISectionLineHeight)];
    lineView.backgroundColor = lineColor;
    [container addSubview:lineView];
    y = lineView.bottom + 2*offset;
    
    if (stage.mtWellVideoInfo.images.count > 0) {
        x = offset;
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.textColor = [UIColor wr_themeColor];
        label.text = NSLocalizedString(@"细节分解图", nil);
        label.font = subTitleFont;
        [label sizeToFit];
        label.frame = [Utility moveRect:label.frame x:x y:y];
        [container addSubview:label];
        y = label.bottom + 2*offset;
        
        NSString *nodeName = NSLocalizedString(@"注意", nil);
        UIImage *placeHolderImage = [UIImage imageNamed:@"well_default_video"];
        
        CGFloat yMax = 0, dx = 0;
        UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, container.width, 0)];
        contentScrollView.pagingEnabled = YES;
        contentScrollView.showsVerticalScrollIndicator = NO;
        
        for(NSUInteger index = 0; index < stage.mtWellVideoInfo.images.count; index++)
        {
            x = offset;
            y = x;
            
            UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.width*0.75, 0)];
            
            WRTreatRehabStageVideoTherbligImage *obj = stage.mtWellVideoInfo.images[index];
     
            text = [NSString stringWithFormat:@"%@: %@", nodeName, obj.detail];;
            label = [[UILabel alloc] init];
            label.textColor = [UIColor darkGrayColor];
            label.text = text;
            label.font = textFont;
            label.numberOfLines = 0;
            size = [label sizeThatFits:CGSizeMake(subView.width - offset - x, CGFLOAT_MAX)];
            label.frame = CGRectMake(x, y, size.width, size.height);
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, nodeName.length)];
            label.attributedText = attrString;
            [subView addSubview:label];
            
            y = label.bottom + offset;
            
            cx = subView.width - 2*x;
            cy = cx*placeHolderImage.size.height/placeHolderImage.size.width;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
            imageView.tag = index;
            imageView.backgroundColor = [UIColor whiteColor];
            [imageView setImageWithUrlString:obj.imageUrl holder:@"well_default_video"];
            imageView.layer.borderColor = [UIColor wr_themeColor].CGColor;
            imageView.layer.borderWidth = 0.0f;
            [subView addSubview:imageView];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapEvent:)];
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            [imageView addGestureRecognizer:singleTap];
            [imageView setUserInteractionEnabled:YES];

            y = imageView.bottom + offset;
            yMax = MAX(yMax, y);
            
            subView.frame = CGRectMake(dx, 0, subView.width, yMax);
            [contentScrollView addSubview:subView];
        
            dx += subView.width + offset;
        }
        [contentScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = [Utility resizeRect:obj.frame cx:-1 height:yMax];
        }];
        
        [contentScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.subviews.count > 1) {
                UIImageView *imageView = obj.subviews[1];
                imageView.frame = [Utility moveRect:imageView.frame x:-1 y:(obj.height - imageView.height - offset)];
            }
        }];
        contentScrollView.frame = [Utility resizeRect:contentScrollView.frame cx:-1 height:yMax];
        contentScrollView.contentSize = CGSizeMake(dx, yMax);
        if (dx > contentScrollView.width) {
            contentScrollView.showsVerticalScrollIndicator = YES;
        }
        [scrollView addSubview:contentScrollView];
        y = contentScrollView.bottom + offset;
    }
    scrollView.contentSize = CGSizeMake(scrollView.width, y);
    

    NSString *title = [NSString stringWithFormat:@"%d/%d", (int)(_currentIndex + 1), (int)self.stageSets.count];
    [_toolView.centerButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Public
-(void)switchInterfaceOrientationAnimated:(BOOL)flag
{
    if(YES)
    {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
            int val = UIInterfaceOrientationIsPortrait(orientation)?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
    else
    {
        _isManualRotate = YES;
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if(UIInterfaceOrientationIsLandscape(orientation))
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        }
        else
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        }
    }
}

@end
