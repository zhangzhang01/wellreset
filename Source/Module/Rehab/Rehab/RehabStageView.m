//
//  RehabStageView.m
//  rehab
//
//  Created by herson on 2016/11/23.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "RehabStageView.h"

#import "WRMediaPlayer.h"
#import "SDPhotoBrowser.h"
#import "WRToolView.h"
#import "UIImage+WR.h"

#import "RehabObject.h"

#import <YYKit/YYKit.h>

#import "WRViewModel+Common.h"
#import "ShareUserData.h"

@interface RehabStageView ()<UIScrollViewDelegate>
{
    CGRect _playViewSmallFrame;
    WRMediaPlayer *_playerView;
    WRToolView *_toolView;
    NSDate *_startDate;
    UIInterfaceOrientationMask _supportUIInterfaceOrientation;
}
@property(nonatomic, weak) WRTreatRehabStage* stage;
@property(nonatomic) NSArray<WRTreatRehabStage *>* stageSets;

@property(nonatomic) UIScrollView *scrollView, *therbligImageScrollView;
@property(nonatomic) UILabel *titleLabel, *detailLabel, *closeLabel, *topCloseLabel;
@property(nonatomic) YYAnimatedImageView *animatedImageView;
@property(nonatomic) UIButton *favorButton;

@property (assign) BOOL applicationIdleTimerDisabled, isMaxing, isWWAN, isProTreat;
@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation RehabStageView

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [_playerView stop];
    _playerView =nil;
    
    
    
    
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _supportUIInterfaceOrientation;
}


-(instancetype)initWithFrame:(CGRect)frame treatRehabStage:(id)stage stageSets:(NSArray*)stageSets isProTreat:(BOOL)isProTreat isplaying:(BOOL)isplaying;
{
    if (self = [super initWithFrame:frame]) {
         _startDate = [NSDate date];
        _stageSets = stageSets;
        _stage = _stageSets.firstObject;
        _isProTreat = isProTreat;
        _isPlaying = isplaying;
        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        self.backgroundColor = [UIColor darkGrayColor];
        
        self.currentIndex = [stageSets indexOfObject:stage];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:)name:UIDeviceOrientationDidChangeNotification object:nil];
        
        _supportUIInterfaceOrientation = UIInterfaceOrientationMaskAll;
    }
    return self;
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
        if (self.closeEvent) {
            self.closeEvent(self);
            [_playerView stop];
        }
    }
    
    CGFloat topOffsetY = scrollView.contentOffset.y;
    NSLog(@"%f",topOffsetY);
    if (topOffsetY<self.topCloseLabel.top) {
        if (self.closeEvent) {
            self.closeEvent(self);
            [_playerView stop];
        }
    }
}
#pragma mark -
-(IBAction)onClickedPreviousButton:(UIButton*)sender {
    self.currentIndex--;
}

-(IBAction)onClickedNextButton:(UIButton*)sender {
    self.currentIndex++;
}

-(IBAction)onClickedFavorButton:(UIButton*)sender
{
    if (!sender.selected)
    {
        NSString *errorString = nil;
        NSInteger collectionCount = [ShareUserData userData].userPermissions.collection;
        NSLog(@"collectionCount%ld",(long)collectionCount);
        if (collectionCount < 0)
        {
            errorString = NSLocalizedString(@"您当前的等级不能收藏动作", nil);
        }
        else if(collectionCount == 0)
        {
            errorString = NSLocalizedString(@"您收藏的动作个数已达上限", nil);
        }
        if (errorString) {
            [SVProgressHUD showErrorWithStatus:errorString];
            return;
        }
    }
    __weak __typeof(self) weakSelf = self;
    [WRViewModel operationWithType:OperationTypeFavor indexId:self.stage.indexId
                        actionType:(sender.selected?OperationActionTypeDelete:OperationActionTypeAdd)
                       contentType:(self.isProTreat ? OperationContentTypeProTreatStage : OperationContentTypeTreatStage)
                        completion:^(NSError * _Nonnull error) {
                            if (error) {
                                NSLog(@"error.domain%@",error.domain);
                                NSString *errorText = error.domain;
                                [SVProgressHUD showErrorWithStatus:errorText];
                            } else {
                                sender.selected = !sender.selected;
                                weakSelf.stage.favor = sender.selected;
                            }
                        }];
}

#pragma mark - private method
-(void)setCurrentIndex:(NSUInteger)currentIndex {
    
    _currentIndex = currentIndex;
    if (currentIndex<self.stageSets.count) {
        self.stage = self.stageSets[_currentIndex];
    
    
    
    if (_scrollView == nil) {
        CGFloat offset = WRUIOffset,  x, y, cx = 0, cy = 0;
        CGRect frame = self.bounds;
        UIImage *image = [UIImage imageNamed:@"well_icon_left"];
        
        cy = image.size.height + 2*offset;
        y = frame.size.height - cy;
        x = 0;
        cx = frame.size.width - 2*x;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - cy)];
        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:scrollView];
        self.scrollView = scrollView;

        
        WRToolView *toolView = [[WRToolView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        toolView.backgroundColor = [[UIColor wr_themeColor] colorWithAlphaComponent:0.8];
        [self.contentView addSubview:toolView];
        _toolView = toolView;
        
        
        [toolView.previousButton addTarget:self action:@selector(onClickedPreviousButton:) forControlEvents:UIControlEventTouchUpInside];
        [toolView.nextButton addTarget:self action:@selector(onClickedNextButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label;
        label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont wr_titleFont];
        label.text = NSLocalizedString(@"上拉关闭当前页", nil);
        label.alpha = 1;
        [label sizeToFit];
        label.frame = CGRectMake(0, - label.height, scrollView.width, label.height);
        [scrollView addSubview:label];
        self.closeLabel = label;
        
        label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont wr_titleFont];
        label.text = NSLocalizedString(@"下拉关闭当前页", nil);
        label.alpha = 1;
        [label sizeToFit];
        label.frame = CGRectMake(0, - label.height, scrollView.width, label.height);
        [scrollView addSubview:label];
        self.topCloseLabel = label;
    }
    
    NSString *title = self.stage.mtWellVideoInfo.videoName;
    [_toolView.centerButton setTitle:title forState:UIControlStateNormal];
    _toolView.previousButton.hidden = _currentIndex <= 0;
    _toolView.nextButton.hidden = _currentIndex >= (self.stageSets.count - 1);
    
        [_playerView stop];
        [_playerView removeFromSuperview];
        _playerView =nil;
        [self setLayout];
        
    }
}

-(UIView*)createPointView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.width/2;
    return view;
}

-(void)layoutWithStage:(WRTreatRehabStage*)stage {
    
    BOOL iPad = [WRUIConfig IsHDApp];
    UIColor *lineColor = [UIColor grayColor];
    
    UIScrollView *scrollView = self.scrollView;
    UIView *container = self.scrollView, *lineView;;
    container.tag =102;
    CGRect frame = scrollView.bounds;
    CGFloat offset = WRUIOffset, x = 0, y = 20, cx = 0, cy = 0;
    CGSize size;
    
    __weak __typeof(self) weakSelf = self;
    [container.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != _playerView && obj != weakSelf.closeLabel && obj != weakSelf.topCloseLabel)
        {
            [obj removeFromSuperview];
        }
    }];
    
    {
        y = 20;
        x = 0;
        cx = frame.size.width - 2*x;
        cy = 9*cx/16;
        
 /*       if(![Utility IsEmptyString:stage.mtWellVideoInfo.gifUrl])
        {
            self.animatedImageView.frame = CGRectMake(x, y, cx, cy);
            y = self.animatedImageView.bottom;
            //下载gif
            __weak __typeof(self) weakSelf = self;
            
            NSData *imageData = [[YYImageCache sharedCache] getImageDataForKey:stage.mtWellVideoInfo.gifUrl];
            if (imageData == nil) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:stage.mtWellVideoInfo.gifUrl]];
                    if (data) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            weakSelf.animatedImageView.image = [YYImage imageWithData:data];
                        }];
                        [[YYImageCache sharedCache] setImage:nil imageData:data forKey:stage.mtWellVideoInfo.gifUrl withType:YYImageCacheTypeDisk];
                    } else {
                        NSLog(@"-------Error:download gif %@", stage.mtWellVideoInfo.gifUrl);
                    }
                });
            }
            else
            {
                weakSelf.animatedImageView.image = [YYImage imageWithData:imageData];
            }
  }*/
        
        
        
        
        BOOL isFullScreen = NO;
        if (!_playerView) {
            _playerView = [[WRMediaPlayer alloc]init];
            [self.scrollView addSubview:_playerView];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_down"]];
            if (IPHONE_X) {
              imageView.top = _playerView.top + offset+20;
            }else{
                imageView.top = _playerView.top + offset;
            }
            
            imageView.centerX = ScreenW*1.0/2;
            imageView.tag = 1001;
            imageView.userInteractionEnabled = YES;
            [self.contentView addSubview:imageView];
            [imageView bk_whenTapped:^{
                if (weakSelf.closeEvent) {
                    weakSelf.closeEvent(weakSelf);
                    [_playerView stop];
                }
            }];
            [_playerView stop];
            
            [_playerView hideControls];
            
            if (![Utility IsEmptyString:stage.mtWellVideoInfo.videoUrl])
            {
                NSLog(@"=-=-=-%@",stage.mtWellVideoInfo.videoUrl);
                if (!self.isPlaying) {
                    if ([stage.mtWellVideoInfo.videoUrl containsString:@"http://"]) {
                        [_playerView setContent:[NSURL URLWithString:stage.mtWellVideoInfo.videoUrl] autoStart:NO];
                    }else{
                        NSArray *array = [stage.mtWellVideoInfo.videoUrl componentsSeparatedByString:@"Documents/"];
                        //获取沙盒路径 拼接信息生成文件
                        NSString *localPath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        NSString *newPath = [NSString stringWithFormat:@"%@/%@",localPath2,array[1]];
                        [_playerView setContent:[NSURL fileURLWithPath: newPath] autoStart:NO];
                    }
                    
                    
                    
                
                [_playerView start];
                }
            }
        }
        if (self.isPlaying) {
            cy = 0;
        }
        _playerView.frame =  CGRectMake(x, y, cx, cy);
        
        //self.closeImageView.hidden = isFullScreen;
        _playerView.backButton.hidden = YES;
        _playerView.disableOnTouch = YES;
        y = _playerView.bottom;
        
        if (_playerView)
        {
            
           
            
        }
        
        
        
  
  
        
        CGRect controlFrame = CGRectMake(scrollView.left, 0, scrollView.frame.size.width, scrollView.height - 0);
        
        scrollView.frame = controlFrame;
    }
    
    x = offset;
    cx = scrollView.frame.size.width - 2*x;
    y += 2*offset;
    UILabel *label;
    
    label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.frame = CGRectMake(x, y, cx, 0);
    label.font = iPad ? [UIFont wr_bigTitleFont] : [UIFont wr_titleFont];
    label.text = stage.mtWellVideoInfo.videoName;
    size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = [Utility resizeRect:label.frame cx:-1 height:size.height];
    [scrollView addSubview:label];
    self.titleLabel = label;
    y = label.bottom + offset;
    
    UIButton *favorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [favorButton setImage:[UIImage imageNamed:@"well_icon_like_focus"] forState:UIControlStateSelected];
    [favorButton setImage:[UIImage imageNamed:@"well_icon_like"] forState:UIControlStateNormal];
    [favorButton sizeToFit];
    favorButton.left = self.width - offset - favorButton.width;
    favorButton.centerY = self.titleLabel.centerY;
    self.titleLabel.width = cx - favorButton.width - offset;
    [scrollView addSubview:favorButton];
    favorButton.selected = self.stage.favor;
    [favorButton addTarget:self action:@selector(onClickedFavorButton:) forControlEvents:UIControlEventTouchUpInside];
    self.favorButton = favorButton;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, WRUILineHeight)];
    lineView.backgroundColor = lineColor;
    [container addSubview:lineView];
    y = lineView.bottom + offset;
    
    if (stage.mtWellVideoInfo.attributes.count  > 0)
    {
        NSMutableArray *titlesArray = [NSMutableArray array];
        [stage.mtWellVideoInfo.attributes enumerateObjectsUsingBlock:^(WRObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titlesArray addObject:obj.detail];
        }];
        UIView *panel = [self createNotesPanelWithTitle:NSLocalizedString(@"要点", nil) notes:titlesArray maxWidth:container.frame.size.width];
        panel.top = y;
        [container addSubview:panel];
        y = panel.bottom + offset;
    }
    
    if (![Utility IsEmptyString:stage.mtWellVideoInfo.notice])
    {
        UIView *panel = [self createNotesPanelWithTitle:NSLocalizedString(@"说明", nil) notes:@[stage.mtWellVideoInfo.notice] maxWidth:container.width];
        panel.top = y;
        [container addSubview:panel];
        y = panel.bottom + offset;
    }
    
    y += offset;
    NSString *text = stage.mtWellVideoInfo.attention;
    if (![Utility IsEmptyString:text])
    {
        UIView *panel = [self createNotesPanelWithTitle:NSLocalizedString(@"注意", nil) notes:@[text] maxWidth:container.width];
        panel.top = y;
        [container addSubview:panel];
        y = panel.bottom + offset;
    }
    
    if (stage.mtWellVideoInfo.images.count > 0) {
        NSMutableArray *titlesArray = [NSMutableArray array];
        NSMutableArray *imagesArray = [NSMutableArray array];
        [stage.mtWellVideoInfo.images enumerateObjectsUsingBlock:^(WRTreatRehabStageVideoTherbligImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titlesArray addObject:obj.detail];
            [imagesArray addObject:obj.imageUrl];
        }];
        UIView *panel = [self createImageViewsWithTitle:NSLocalizedString(@"细节分解图", nil) detail:nil images:imagesArray titles:titlesArray maxWidth:container.width];
        panel.top = y;
        [container addSubview:panel];
        y = panel.bottom + offset;
    }
    
    if (stage.mtWellVideoInfo.muscle) {
        UIView *panel = [self createImageViewsWithTitle:NSLocalizedString(@"肌肉图", nil) detail:stage.mtWellVideoInfo.muscle.muscle images:stage.mtWellVideoInfo.muscle.images titles:nil maxWidth:container.width];
        panel.top = y;
        [container addSubview:panel];
        y = panel.bottom + offset;
    }
    scrollView.contentSize = CGSizeMake(scrollView.width, y);
    self.closeLabel.top = y + 20;
    self.topCloseLabel.bottom = -20;
    
    NSString *title = [NSString stringWithFormat:@"%d/%d", (int)(_currentIndex + 1), (int)self.stageSets.count];
    [_toolView.centerButton setTitle:title forState:UIControlStateNormal];
}



-(void)layoutWithOrginStage:(WRTreatRehabStage*)stage {
    
    BOOL iPad = [WRUIConfig IsHDApp];
    UIColor *lineColor = [UIColor grayColor];
    
    UIScrollView *scrollView = self.scrollView;
    UIImage *image = [UIImage imageNamed:@"well_icon_left"];
    CGFloat offset = WRUIOffset, x = 0, y = 20, cx = 0, cy = 0;


   

    UIView *container = self.scrollView, *lineView;;
    container.tag =101;
    CGRect frame = scrollView.bounds;
    CGSize size;
    
    __weak __typeof(self) weakSelf = self;
    [container.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != _playerView && obj != weakSelf.closeLabel && obj != weakSelf.topCloseLabel)
        {
            [obj removeFromSuperview];
        }
    }];
    
    {
        y = 20;
        x = 34;
        cx = self.width*1.0/667*347;
        cy = 9*cx/16;
        
        /*       if(![Utility IsEmptyString:stage.mtWellVideoInfo.gifUrl])
         {
         self.animatedImageView.frame = CGRectMake(x, y, cx, cy);
         y = self.animatedImageView.bottom;
         //下载gif
         __weak __typeof(self) weakSelf = self;
         
         NSData *imageData = [[YYImageCache sharedCache] getImageDataForKey:stage.mtWellVideoInfo.gifUrl];
         if (imageData == nil) {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:stage.mtWellVideoInfo.gifUrl]];
         if (data) {
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         weakSelf.animatedImageView.image = [YYImage imageWithData:data];
         }];
         [[YYImageCache sharedCache] setImage:nil imageData:data forKey:stage.mtWellVideoInfo.gifUrl withType:YYImageCacheTypeDisk];
         } else {
         NSLog(@"-------Error:download gif %@", stage.mtWellVideoInfo.gifUrl);
         }
         });
         }
         else
         {
         weakSelf.animatedImageView.image = [YYImage imageWithData:imageData];
         }
         }*/
        
        
        
        
        BOOL isFullScreen = NO;
        if (!_playerView) {
            _playerView = [[WRMediaPlayer alloc]init];
            [self.scrollView addSubview:_playerView];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_down"]];
            
            imageView.top = _playerView.top + offset;
            imageView.centerX = self.width*1.0/2;
            imageView.tag = 1001;
            imageView.userInteractionEnabled = YES;
            [self.contentView addSubview:imageView];
            [imageView bk_whenTapped:^{
                if (weakSelf.closeEvent) {
                    weakSelf.closeEvent(weakSelf);
                    [_playerView stop];
                }
            }];
            [_playerView stop];
            
            [_playerView hideControls];
            
            if (![Utility IsEmptyString:stage.mtWellVideoInfo.videoUrl])
            {
                if (!self.isPlaying) {
                [_playerView setContent:[NSURL URLWithString:stage.mtWellVideoInfo.videoUrl] autoStart:NO];
                
                [_playerView start];
                }
            }
        }
        if (self.isPlaying) {
            cy = 0;
        }
        UIView* v = [self viewWithTag:1001];
        v.centerX = self.width*1.0/2;
        _playerView.frame =  CGRectMake(x, y, cx, cy);
        //self.closeImageView.hidden = isFullScreen;
        _playerView.backButton.hidden = YES;
        _playerView.disableOnTouch = YES;
        y = _playerView.bottom;
        
        if (_playerView)
        {
            
//            [_playerView stop];
//            
//            [_playerView hideControls];
//            
//            if (![Utility IsEmptyString:stage.mtWellVideoInfo.videoUrl])
//            {
//                [_playerView setContent:[NSURL URLWithString:stage.mtWellVideoInfo.videoUrl] autoStart:NO];
//                [_playerView start];
//            }
            
        }
        
        
        
        
        
        
        CGRect controlFrame = CGRectMake(scrollView.left, 0, scrollView.frame.size.width, scrollView.height - 0);
        
        scrollView.frame = controlFrame;
    }
    
    x = 20+_playerView.right;
    cx = scrollView.frame.size.width - _playerView.right;
    y = 17;
    UILabel *label;
    
    label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.frame = CGRectMake(x, y, cx, 0);
    label.font = iPad ? [UIFont wr_bigTitleFont] : [UIFont wr_titleFont];
    label.text = stage.mtWellVideoInfo.videoName;
    size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = [Utility resizeRect:label.frame cx:-1 height:size.height];
    [scrollView addSubview:label];
    self.titleLabel = label;
    y = label.bottom + 17;
    
    UIButton *favorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [favorButton setImage:[UIImage imageNamed:@"well_icon_like_focus"] forState:UIControlStateSelected];
    [favorButton setImage:[UIImage imageNamed:@"well_icon_like"] forState:UIControlStateNormal];
    [favorButton sizeToFit];
    favorButton.left = self.width - offset - favorButton.width;
    favorButton.centerY = self.titleLabel.centerY;
    self.titleLabel.width = cx - favorButton.width - offset;
    [scrollView addSubview:favorButton];
    favorButton.selected = self.stage.favor;
    [favorButton addTarget:self action:@selector(onClickedFavorButton:) forControlEvents:UIControlEventTouchUpInside];
    self.favorButton = favorButton;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, WRUILineHeight)];
    lineView.backgroundColor = lineColor;
    [container addSubview:lineView];
    y = lineView.bottom + offset;
    
    if (stage.mtWellVideoInfo.attributes.count  > 0)
    {
        NSMutableArray *titlesArray = [NSMutableArray array];
        [stage.mtWellVideoInfo.attributes enumerateObjectsUsingBlock:^(WRObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titlesArray addObject:obj.detail];
        }];
        UIView *panel = [self createNotesPanelWithTitle:NSLocalizedString(@"要点", nil) notes:titlesArray maxWidth:cx - offset*2];
        panel.top = y;
        panel.x =x;
        [container addSubview:panel];
        y = panel.bottom + offset;
    }
    
    y = y>_playerView.bottom+17 ? y: _playerView.bottom+17;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.width, WRUILineHeight)];
    lineView.backgroundColor = lineColor;
    [container addSubview:lineView];
    y = lineView.bottom + offset;
    CGFloat savey = y;
    if (![Utility IsEmptyString:stage.mtWellVideoInfo.notice])
    {
        UIView *panel = [self createNotesPanelWithTitle:NSLocalizedString(@"说明", nil) notes:@[stage.mtWellVideoInfo.notice] maxWidth:container.width*1.0/2];
        panel.top = savey;
        [container addSubview:panel];
        
        x = container.width*1.0/2;
        y = panel.bottom + offset;
    }
    
    
    NSString *text = stage.mtWellVideoInfo.attention;
    if (![Utility IsEmptyString:text])
    {
        UIView *panel = [self createNotesPanelWithTitle:NSLocalizedString(@"注意", nil) notes:@[text] maxWidth:container.width*1.0/2];
        panel.top = savey;
        panel.x = x;
        [container addSubview:panel];
        y = y> panel.bottom + offset?y:panel.bottom + offset;
    }
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.width, 5)];
    lineView.backgroundColor = lineColor;
    [container addSubview:lineView];
    y = lineView.bottom +offset;
    
    
    if (stage.mtWellVideoInfo.images.count > 0) {
        NSMutableArray *titlesArray = [NSMutableArray array];
        NSMutableArray *imagesArray = [NSMutableArray array];
        [stage.mtWellVideoInfo.images enumerateObjectsUsingBlock:^(WRTreatRehabStageVideoTherbligImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titlesArray addObject:obj.detail];
            [imagesArray addObject:obj.imageUrl];
        }];
        UIView *panel = [self createImageViewsWithTitle:NSLocalizedString(@"细节分解图", nil) detail:nil images:imagesArray titles:titlesArray maxWidth:container.width];
        panel.top = y;
        [container addSubview:panel];
        y = panel.bottom + offset;
    }
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.width, 5)];
    lineView.backgroundColor = lineColor;
    [container addSubview:lineView];
    y = lineView.bottom +offset;
    
    
    if (stage.mtWellVideoInfo.muscle) {
        UIView *panel = [self createImageViewsWithTitle:NSLocalizedString(@"肌肉图", nil) detail:stage.mtWellVideoInfo.muscle.muscle images:stage.mtWellVideoInfo.muscle.images titles:nil maxWidth:container.width];
        panel.top = y;
        [container addSubview:panel];
        y = panel.bottom + offset;
    }
    scrollView.contentSize = CGSizeMake(scrollView.width, y);
    self.closeLabel.top = y + 20;
    self.topCloseLabel.bottom = -20;
    
    NSString *title = [NSString stringWithFormat:@"%d/%d", (int)(_currentIndex + 1), (int)self.stageSets.count];
    [_toolView.centerButton setTitle:title forState:UIControlStateNormal];
}




#pragma mark - ui helper
-(UIView*)createNotesPanelWithTitle:(NSString*)title notes:(NSArray<NSString*>*)notes maxWidth:(CGFloat)maxWidth
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 0)];
    UILabel *label;
    
    CGFloat offset = WRUIOffset, x = offset, y = 0, cx = container.width - 2*x, cy = 0;
    CGSize size;
    CGFloat pointYOffset = 3, pointXOffset = 5;
    
    BOOL iPad = [WRUIConfig IsHDApp];
    
    UIFont *subTitleFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_smallFont];
    UIFont *textFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_smallFont];
    UIColor *subTitleColor = [UIColor lightGrayColor];
    UIColor *textColor = [UIColor whiteColor];
    UIColor *lineColor = [UIColor grayColor];
    
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
    if (_scrollView.tag == 102) {
        [container addSubview:lineView];
    }
    
    y = lineView.bottom;
    container.height = y;
    
    return container;
}

-(UIView*)createImageViewsWithTitle:(NSString*)title detail:(NSString*)detail images:(NSArray<NSString*>*)images titles:(NSArray<NSString*>*)titles maxWidth:(CGFloat)maxWidth
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 0)];
    UILabel *label;
    
    UIColor *titleColor = [UIColor lightGrayColor], *subTitleColor = [UIColor whiteColor], *detailColor = [UIColor whiteColor];
    UIFont *titleFont = [UIFont wr_textFont], *subTitleFont = [UIFont wr_textFont], *detailFont = [UIFont wr_textFont];
    
    CGFloat offset = WRUIOffset, x = offset, y = 0, cx = container.width - 2*x, cy;
    CGSize size;
    x = offset;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
    label.textColor = titleColor;
    label.text = title;
    label.font = titleFont;
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:x y:y];
    [container addSubview:label];
    y = label.bottom;
    
    if (![Utility IsEmptyString:detail]) {
        y += offset;
        label = [[UILabel alloc] init];
        label.textColor = detailColor;
        label.text = detail;
        label.font = detailFont;
        label.numberOfLines = 0;
        size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y, size.width, size.height);
        [container addSubview:label];
        y = label.bottom;
    }
    
    UIImage *placeHolderImage = [UIImage imageNamed:@"well_default_video"];
    
    CGFloat yMax = 0, dx = 0;
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, container.width, 0)];
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsVerticalScrollIndicator = NO;
    
    for(NSUInteger index = 0; index < images.count; index++)
    {
        NSString *imageUrl = images[index];
        NSString *subTitle = nil;
        if (titles) {
            subTitle = titles[index];
        }
        
        x = offset;
        y = x;
        
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, container.width*0.88, 0)];
        if (_scrollView.tag == 101) {
            subView.frame = CGRectMake(0, 0, container.width*0.35, 0);
        }
        if (title)
        {
            label = [[UILabel alloc] init];
            label.textColor = subTitleColor;
            label.text = subTitle;
            label.font = subTitleFont;
            label.numberOfLines = 0;
            size = [label sizeThatFits:CGSizeMake(subView.width - offset - x, CGFLOAT_MAX)];
            label.frame = CGRectMake(x, y, size.width, size.height);
            
            label.text = subTitle;
            [subView addSubview:label];
            
            y = label.bottom + offset;
        }
        
        cx = subView.width - 2*x;
        cy = [placeHolderImage scaleHeightForWidth:cx];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        imageView.tag = index;
        imageView.backgroundColor = [UIColor whiteColor];
        [imageView setImageWithUrlString:imageUrl holder:@"well_default_video"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5.f;
        [subView addSubview:imageView];
        
        /*
         UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapEvent:)];
         singleTap.numberOfTapsRequired = 1;
         singleTap.numberOfTouchesRequired = 1;
         [imageView addGestureRecognizer:singleTap];
         [imageView setUserInteractionEnabled:YES];
         */
        
        y = imageView.bottom + offset;
        yMax = MAX(yMax, y);
        
        subView.frame = CGRectMake(dx, 0, subView.width, yMax);
        [contentScrollView addSubview:subView];
        
        dx += subView.width + offset;
    }
    [contentScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = [Utility resizeRect:obj.frame cx:-1 height:yMax];
    }];
    if (titles) {
        [contentScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.subviews.count > 1) {
                UIImageView *imageView = obj.subviews[1];
                imageView.frame = [Utility moveRect:imageView.frame x:-1 y:(obj.height - imageView.height - offset)];
            }
        }];
    }
    
    contentScrollView.frame = [Utility resizeRect:contentScrollView.frame cx:-1 height:yMax];
    contentScrollView.contentSize = CGSizeMake(dx, yMax);
    if (dx > contentScrollView.width) {
        contentScrollView.showsHorizontalScrollIndicator = NO;
    }
    [container addSubview:contentScrollView];
    y = contentScrollView.bottom + offset;
    
    x = offset;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, container.width - 2*x, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    if (_scrollView.tag==102) {
       [container addSubview:lineView];
    }
    
    y = lineView.bottom;
    container.height = y;
    
    return container;
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
    if ((lastType == UIInterfaceOrientationLandscapeLeft) || (lastType == UIInterfaceOrientationLandscapeRight))
    {

        if (self.width<self.height) {
            self.frame = self.window.bounds;
        }
    }
    else
    {
        if (self.width>self.height) {
            self.frame = self.window.bounds;
        }
    }
    
    UIImage *image = [UIImage imageNamed:@"well_icon_left"];
    CGFloat offset = WRUIOffset;
    CGFloat cy = image.size.height + 2*offset;
    self.scrollView.frame = CGRectMake(0, 0, self.width, self.height - cy);
    
    
    
    
    CGFloat   x, y, cx = 0;
    CGRect frame = self.bounds;
   
    
    cy = image.size.height + 2*offset;
    y = frame.size.height - cy;
    x = 0;
    cx = frame.size.width - 2*x;
    
    
    _toolView.frame = CGRectMake(x, y, cx, cy);
    
   
    
    
    
    
    self.closeLabel.frame = CGRectMake(0, - self.closeLabel.height, _scrollView.width, self.closeLabel.height);

    
    
    self.topCloseLabel .frame = CGRectMake(0, - self.topCloseLabel.height, _scrollView.width, self.topCloseLabel.height);

     NSString *title = self.stage.mtWellVideoInfo.videoName;
     [_toolView.centerButton setTitle:title forState:UIControlStateNormal];
     _toolView.previousButton.hidden = _currentIndex <= 0;
     _toolView.nextButton.hidden = _currentIndex >= (self.stageSets.count - 1);


    if ((lastType == UIInterfaceOrientationLandscapeLeft) || (lastType == UIInterfaceOrientationLandscapeRight))
    {
        
        [_toolView layoutw];
        
        
        self.scrollView.frame = CGRectMake(0, 0, self.width, self.height);
        [self layoutWithOrginStage:self.stage];
        
    }
    
    
    
    if ((lastType == UIInterfaceOrientationPortrait) || (lastType == UIInterfaceOrientationPortraitUpsideDown))
    {
        
        [_toolView layout];
        [self layoutWithStage:self.stage];
        
    }
   
    
   
    
}


@end
