//
//  PreventPlayerController.m
//  rehab
//
//  Created by herson on 2016/11/22.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "PreventPlayerController.h"
#import "RehabObject.h"
#import "WRMediaPlayer.h"
#import "SDPhotoBrowser.h"
#import "WRToolView.h"
#import "RehabObject.h"

#import <YYKit/YYKit.h>

#import "WRViewModel+Common.h"
#import "NetworkNotifier.h"

@interface PreventPlayerController ()<SDPhotoBrowserDelegate, UIScrollViewDelegate>
{
    WRMediaPlayer *_playerView;
    CGRect _playViewSmallFrame;
    
    BOOL _isManualRotate;
    BOOL _isFullScreenMode;
    UIInterfaceOrientationMask _supportUIInterfaceOrientation;
    
    WRToolView *_toolView;
    UIStatusBarStyle oldStatusBarStyle;
    
    NSDate *_startDate;
}
@property(nonatomic, weak) WRTreatRehabStageVideo* video;
@property(nonatomic) NSArray<WRTreatRehabStageVideo *>* videoSets;
@property (nonatomic, strong) NetworkNotifier *networkNotifier;
@property(nonatomic)UIScrollView *scrollView, *therbligImageScrollView;
@property(nonatomic)UILabel *titleLabel, *detailLabel, *topCloseLabel, *closeLabel;
@property(nonatomic)YYAnimatedImageView *animatedImageView;

@property (assign) BOOL applicationIdleTimerDisabled, isMaxing, isWWAN;
@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation PreventPlayerController
-(void)dealloc {
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForPreventVideoPlayer:_video.name duration:duration];
}

-(instancetype)initWithTreatRehabStageVideo:(id)video stageSets:(NSArray *)stageSets
{
    if (self = [super init]) {
        __weak __typeof(self)weakself = self;
        _startDate = [NSDate date];
        
        _videoSets = stageSets;
        _video = video;
        
        _isManualRotate = NO;
        _isFullScreenMode = NO;
        _supportUIInterfaceOrientation = UIInterfaceOrientationMaskAll;

//        self.networkNotifier = [[NetworkNotifier alloc] initWithController:self];
//        self.networkNotifier.continueBlock = ^(NSInteger index){
//            if (index == 1) {
//                [weakself closeController];
//            }
//        };
        //方向变化通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
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
        toolView.backgroundColor = [[UIColor wr_rehabBlueColor] colorWithAlphaComponent:0.8];
        [self.view addSubview:toolView];
        _toolView = toolView;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - _toolView.height)];
        scrollView.delegate = self;
        [self.view addSubview:scrollView];
        self.scrollView = scrollView;
        
        [toolView.previousButton addTarget:self action:@selector(onClickedPreviousButton:) forControlEvents:UIControlEventTouchUpInside];
        [toolView.nextButton addTarget:self action:@selector(onClickedNextButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.currentIndex = [self.videoSets indexOfObject:self.video];
    }
    
    oldStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = self.applicationIdleTimerDisabled;
    
//    [self.totalTimerLabel pause];
//    NSTimeInterval interval = [self.totalTimerLabel getTimeCounted];
    
    
//    _pauseView = nil;
//    [_playerView stop];
    [_playerView stop];
    _playerView = nil;
//    [self.soundPlayer stop];
//    self.soundPlayer = nil;
    
    
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [_airplayButtonInMPVolumeView removeObserver:self forKeyPath:@"alpha"];
    
    
    
    
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
    return YES;
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.scrollView.frame = [Utility resizeRect:self.scrollView.frame cx:self.view.bounds.size.width height:-1];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_playerView)
    {
        if (self.view.bounds.size.width > self.view.bounds.size.height) {
            _playerView.frame = self.view.bounds;
            [self.scrollView bringSubviewToFront:_playerView];
            self.scrollView.scrollEnabled = NO;
        } else {
            _playerView.frame = _playViewSmallFrame;
            self.scrollView.scrollEnabled = YES;
        }
    }
}

#pragma mark - getter & setter
-(YYAnimatedImageView *)animatedImageView {
    if (!_animatedImageView) {
        _animatedImageView = [[YYAnimatedImageView alloc] init];
        [self.scrollView addSubview:self.animatedImageView];
    }
    return _animatedImageView;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alpha = 0;
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.height;
    if (offsetY > self.closeLabel.top ) {
        self.closeLabel.text = NSLocalizedString(@"上拉关闭当前页", nil);
        CGFloat offset = offsetY - self.closeLabel.top;
        CGFloat value = offset/(self.closeLabel.height + 40);
        if (value > 1) {
            value = 1;
        }
        alpha = value;
    }
    self.closeLabel.alpha = alpha;
    
    if (offsetY > (self.closeLabel.bottom + 40)) {
        self.closeLabel.text = NSLocalizedString(@"释放关闭当前页", nil);
    }
    
    CGFloat topOffsetY = scrollView.contentOffset.y;
    if (topOffsetY < self.topCloseLabel.bottom) {
        self.topCloseLabel.text = NSLocalizedString(@"下拉关闭当前页", nil);
        CGFloat offset = - topOffsetY ;        NSLog(@"%f",offset);
        CGFloat value = offset/(self.topCloseLabel.height + 40);
        if (value > 1) {
            value = 1;
        }
        alpha = value;
    }
    self.topCloseLabel.alpha = alpha;
    
    if (topOffsetY < (self.topCloseLabel.top)) {
        self.topCloseLabel.text = NSLocalizedString(@"释放关闭当前页", nil);
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.height;
    if (offsetY > (self.closeLabel.bottom + 40)) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    CGFloat topOffsetY = scrollView.contentOffset.y;
    NSLog(@"%f",topOffsetY);
    if (topOffsetY<self.topCloseLabel.top) {
        [self closeController];
    }
}

#pragma mark - SDPhotoBrowserDelegate
-(UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return [UIImage imageNamed:@"well_default"];
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    WRTreatRehabStageVideoTherbligImage *therbligImage = self.video.images[index];
    return [NSURL URLWithString:therbligImage.imageUrl];
}

-(NSString *)photoBrowser:(SDPhotoBrowser *)browser detailForIndex:(NSInteger)index {
    WRTreatRehabStageVideoTherbligImage *therbligImage = self.video.images[index];
    return therbligImage.detail;
}

#pragma mark - IBActions
-(IBAction)gestureTapEvent:(UITapGestureRecognizer*)tapGesture {
    [UMengUtils careForPreventVideoThumb:_video.videoName];
    UIImageView *imageView = (UIImageView*)tapGesture.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = imageView.superview;
    browser.imageCount = self.video.images.count;
    browser.currentImageIndex = imageView.tag;
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
    
    WRTreatRehabStageVideoTherbligImage *therbligImage = self.video.images[imageView.tag];
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

-(IBAction)onClickedPlayerBackButton:(UIButton*)sender {
    if (CGRectEqualToRect(_playerView.frame, _playViewSmallFrame)) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [_playerView.resizeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    /*
     if (_playerView.isFullScreen) {
     BOOL shouldFullScreen = NO;
     [UIApplication sharedApplication].statusBarHidden = shouldFullScreen;
     [_playerView setViewScaleTyle:shouldFullScreen];
     } else {
     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
     }
     */
}

-(IBAction)onClickedPreviousButton:(UIButton*)sender {
    self.currentIndex--;
}

-(IBAction)onClickedNextButton:(UIButton*)sender {
    self.currentIndex++;
}

#pragma mark - private method
- (void)closeController
{
     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)setCurrentIndex:(NSUInteger)currentIndex {
    if (currentIndex<self.videoSets.count) {
    _currentIndex = currentIndex;
    self.video = self.videoSets[_currentIndex];
    
    NSString *title = self.video.videoName;
    [_toolView.centerButton setTitle:title forState:UIControlStateNormal];
    _toolView.previousButton.hidden = _currentIndex <= 0;
    _toolView.nextButton.hidden = _currentIndex >= (self.videoSets.count - 1);
    
    [self layoutWithStage:self.video];
    }
}

#pragma mark - orientation changed
- (void)orientationChange:(id)sender
{
    @synchronized (self) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight ||orientation == UIDeviceOrientationLandscapeLeft)
        {
            self.isMaxing = YES;
            [UIApplication sharedApplication].statusBarHidden = YES;
            _playerView.frame = [UIScreen mainScreen].bounds;
            _playerView.resizeButton.selected = YES;
            
        }
        else if (orientation == UIDeviceOrientationPortrait)
        {
            [UIApplication sharedApplication].statusBarHidden = NO;
            _playerView.frame = _playViewSmallFrame;
            _playerView.resizeButton.selected = NO;
        }
        else if (orientation == UIDeviceOrientationUnknown)
        {
            if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
            {
                [UIApplication sharedApplication].statusBarHidden = NO;
                _playerView.frame = _playViewSmallFrame;
                _playerView.resizeButton.selected = NO;
            }
        }
        else if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationPortraitUpsideDown) {
            return;
        }
    }
}

-(void)layoutWithRotation
{
    //[_playerView resetLayout:_isFullScreenMode isDone:NO];
    if( _isFullScreenMode )
    {
        CGRect rcScreen = [UIScreen mainScreen].bounds;
        if(rcScreen.size.width < rcScreen.size.height)
        {
            rcScreen = CGRectMake(0, 0, rcScreen.size.height, rcScreen.size.width);
        }
        _playerView.frame = CGRectMake(0, 0, rcScreen.size.width, rcScreen.size.height);
    }
    else
    {
        _playerView.frame = _playViewSmallFrame;
    }
    //[_playerView resetLayout:_isFullScreenMode isDone:YES];
}

-(void)layoutWithStage:(WRTreatRehabStageVideo*)stage {
    self.title = stage.videoName;
    
    BOOL iPad = [WRUIConfig IsHDApp];
    UIColor *lineColor = [UIColor wr_lineColor];
    
    UIFont *subTitleFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_labelFont];
    UIFont *textFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_smallFont];
    
    UIScrollView *scrollView = self.scrollView;
    UIView *container = self.scrollView, *lineView;;
    
    CGRect frame = scrollView.bounds;
    CGFloat offset = WRUIOffset, x = 0, y , cx = 0, cy = 0;
//    y = x + 20;
    CGSize size;
    
    [container.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != _playerView && obj != _animatedImageView) {
            [obj removeFromSuperview];
        }
    }];
    
    {
        y = 20;
        x = 0;
        cx = frame.size.width - 2*x;
        cy = 9*cx/16;
        
        if (!_playerView) {
            WRMediaPlayer *player = [[WRMediaPlayer alloc] initWithFrame:CGRectMake(x, y, cx, cy) style:WRMediaPlayerStyleDefault];
            //player.hideControls = YES;
            player.backgroundColor = [UIColor blackColor];
            [player.resizeButton addTarget:self action:@selector(onClickedPlayerResizeButton:) forControlEvents:UIControlEventTouchUpInside];
            [player.backButton addTarget:self action:@selector(onClickedPlayerBackButton:) forControlEvents:UIControlEventTouchUpInside];
            [container addSubview:player];
            _playViewSmallFrame = player.frame;
            _playerView = player;
        }
        CGRect controlFrame = CGRectMake(scrollView.left, 0, scrollView.frame.size.width, scrollView.height - 0);
        scrollView.frame = controlFrame;
    }
    y = _playerView.bottom;
    
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
    
    if (stage.attributes.count  > 0) {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
//        label.textColor = [UIColor lightGrayColor];
//        label.text = NSLocalizedString(@"要点", nil);
//        label.font = subTitleFont;
//        [label sizeToFit];
//        label.frame = [Utility moveRect:label.frame x:x y:y];
//        [container addSubview:label];
//        y = label.bottom + offset;
//        for(NSUInteger index = 0; index < stage.attributes.count; index++)
//        {
//            x = offset;
//            
//            WRObject *obj = stage.attributes[index];
//            label = [[UILabel alloc] init];
//            label.textColor = [UIColor wr_themeColor];
//            label.text = NSLocalizedString(@" ● ", nil);
//            label.font = textFont;
//            [label sizeToFit];
//            label.frame = [Utility moveRect:label.frame x:x y:y];
//            [container addSubview:label];
//            x = label.right + 3;
//            label = [[UILabel alloc] init];
//            label.textColor = [UIColor darkGrayColor];
//            label.text = obj.detail;
//            label.font = textFont;
//            label.numberOfLines = 0;
//            size = [label sizeThatFits:CGSizeMake(frame.size.width - offset - x, CGFLOAT_MAX)];
//            label.frame = CGRectMake(x, y, size.width, size.height);
//            [container addSubview:label];
//            y = label.bottom + offset;
//        }
        
  
            NSMutableArray *titlesArray = [NSMutableArray array];
            [stage.attributes enumerateObjectsUsingBlock:^(WRObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [titlesArray addObject:obj.detail];
            }];
            UIView *panel = [self createNotesPanelWithTitle:NSLocalizedString(@"要点", nil) notes:titlesArray maxWidth:container.width];
            panel.top = y;
            [container addSubview:panel];
            y = panel.bottom + offset;
     
        
        if (![Utility IsEmptyString:stage.notice])
        {
            UIView *panel = [self createNotesPanelWithTitle:NSLocalizedString(@"说明", nil) notes:@[stage.notice] maxWidth:container.width];
            panel.top = y;
            [container addSubview:panel];
            y = panel.bottom + offset;
        }
        
        y += offset;
        NSString *text = stage.attention;
        if (![Utility IsEmptyString:text])
        {
            UIView *panel = [self createNotesPanelWithTitle:NSLocalizedString(@"注意", nil) notes:@[text] maxWidth:container.width];
            panel.top = y;
            [container addSubview:panel];
            y = panel.bottom + offset;
        }

    }
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, container.width, WRUISectionLineHeight)];
    lineView.backgroundColor = lineColor;
    [container addSubview:lineView];
    y = lineView.bottom + 2*offset;
    
    if (stage.images.count > 0) {
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
        
        for(NSUInteger index = 0; index < stage.images.count; index++)
        {
            x = offset;
            y = x;
            
            UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentScrollView.width*0.75, 0)];
            
            WRTreatRehabStageVideoTherbligImage *obj = stage.images[index];
            
            NSString *text = [NSString stringWithFormat:@"%@: %@", nodeName, obj.detail];;
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
    
    label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont wr_titleFont];
    label.text = NSLocalizedString(@"上拉关闭当前页", nil);
    label.alpha = 1;
    [label sizeToFit];
    label.frame = CGRectMake(0, y + label.height, scrollView.width, label.height);
    [scrollView addSubview:label];
    self.closeLabel = label;
    
    label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont wr_titleFont];
    label.text = NSLocalizedString(@"下拉关闭当前页", nil);
    label.alpha = 1;
    [label sizeToFit];
    label.frame = CGRectMake(0, - label.height, scrollView.width, label.height);
    [scrollView addSubview:label];
    self.topCloseLabel = label;
    
    
    [_playerView stop];
    if (_playerView) {
        [self.view bringSubviewToFront:_playerView];
        if (![Utility IsEmptyString:stage.videoUrl]) {
            [_playerView setContent:[NSURL URLWithString:stage.videoUrl] autoStart:NO];
        }
    }
    
    NSString *title = [NSString stringWithFormat:@"%d/%d", (int)(_currentIndex + 1), (int)self.videoSets.count];
    [_toolView.centerButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Public
-(UIView*)createNotesPanelWithTitle:(NSString*)title notes:(NSArray<NSString*>*)notes maxWidth:(CGFloat)maxWidth
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 0)];
    UILabel *label;
    
    CGFloat offset = WRUIOffset, x = offset, y = 0, cx = container.width - 2*x, cy;
    CGSize size;
    CGFloat pointYOffset = 3, pointXOffset = 5;
    
    BOOL iPad = [WRUIConfig IsHDApp];
    
    UIFont *subTitleFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_smallFont];
    UIFont *textFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_smallFont];
    UIColor *subTitleColor = [UIColor lightGrayColor];
    UIColor *textColor = [UIColor lightGrayColor];
    UIColor *lineColor = [UIColor lightGrayColor];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
    label.textColor = subTitleColor;
    label.text = title;
    label.font = subTitleFont;
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:x y:y];
    [container addSubview:label];
    y = label.bottom + offset;
    
    for(NSString *text in notes)
    {
        UIView *point = [self createPointView];
        [container addSubview:point];
        point.left = offset;
        point.top = y + pointYOffset;
        
        x = point.right + pointXOffset;
        label = [[UILabel alloc] init];
        label.textColor = textColor;
        label.text = text;
        label.font = textFont;
        label.numberOfLines = 0;
        size = [label sizeThatFits:CGSizeMake(container.width - x - offset, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y, size.width, size.height);
        [container addSubview:label];
        y = label.bottom + offset;
    }
    x = offset;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, container.width - 2*x, 1)];
    lineView.backgroundColor = lineColor;
    [container addSubview:lineView];
    y = lineView.bottom;
    container.height = y;
    
    return container;
}

-(UIView*)createPointView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
    view.backgroundColor = [UIColor lightGrayColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.width/2;
    return view;
}

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
