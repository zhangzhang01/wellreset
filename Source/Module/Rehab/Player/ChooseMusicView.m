//
//  ChooseMusicView.m
//  rehab
//
//  Created by yefangyang on 2016/10/25.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "ChooseMusicView.h"
#import "DownloadMusicViewModel.h"
#import "SVProgressHUD.h"


@interface ChooseMusicView ()

@property (nonatomic, strong) DownloadMusicViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIButton *defaultButton;

@end
@implementation ChooseMusicView
- (DownloadMusicViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[DownloadMusicViewModel alloc] init];
    }
    return _viewModel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.dataArray = [NSMutableArray array];
        CGFloat y, cx, cy, offset;
        offset = WRUIOffset;
        UIImage *image = [UIImage imageNamed:@"well_bgmusic_close"];

        UISwitch *control = [[UISwitch alloc] init];
        control.tintColor = [UIColor wr_themeColor];
        self.switchControl = control;
        control.on = YES;
        self.isOn = control.on;
        [self.contentView addSubview:control];
        control.frame = [Utility moveRect:control.frame x:(frame.size.width - control.width)/2 y: 3 * offset];
        
        y = control.bottom + 2 * offset;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, cx, cy)];
        label.text = control.isOn?NSLocalizedString(@"背景音乐已打开", nil):NSLocalizedString(@"背景音乐已关闭", nil);
        label.font = [UIFont wr_textFont];
        label.textColor = [UIColor grayColor];
        [self.contentView addSubview:label];
        [label sizeToFit];
        label.frame = [Utility resizeRect:label.frame cx:label.width height:label.height];
        label.frame = [Utility moveRect:label.frame x:(frame.size.width - label.width)/2 y:-1];
        y = label.bottom + 5 * offset;
        self.switchLabel = label;
    
        CGRect viewFrame = CGRectMake(0, y, frame.size.width, frame.size.height - y - image.size.height - 2 * WRUIOffset);
        
        UIView *view = [[UIView alloc] initWithFrame:viewFrame];
        y = 0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.selected = YES;
        [view addSubview:button];
        button.tag = 0;
        [button setTitle:NSLocalizedString(@"默认背景音乐", nil) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont wr_smallTitleFont];
        [button setTitleColor:[UIColor wr_lightWhite] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor wr_themeColor] forState:UIControlStateSelected];
        [button sizeToFit];
        button.frame = CGRectMake((view.width - button.width)/2, y, button.width, button.height);
        y = button.bottom + WRUIOffset;
        [button addTarget:self action:@selector(onClickedMusicButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        self.defaultButton = button;
        self.selectedButton = button;
        [self.contentView addSubview:view];
        
        self.musicListView = view;
//        self.musicListView.backgroundColor = [UIColor yellowColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:imageView];
        imageView.frame = [Utility moveRect:imageView.frame x:(frame.size.width - image.size.width)/2 y:view.bottom + WRUIOffset];
        self.closeImageView = imageView;
        
        if ([self.viewModel needReload])
        {
            [self createUndownloadView];
        }
        else
        {
            [self completeMusicListView];
        }
    }
    return self;
}

#pragma mark -
- (IBAction)onClickedDownloadButton:(UIButton *)sender
{
    __weak __typeof(self)weakself = self;
    [self.viewModel fetchDownloadDataWithCompletion:^(NSError *error) {
        if (error) {
            
        } else {
            [weakself completeMusicListView];
        }
    }];
}

- (IBAction)onClickedMusicButton:(UIButton *)sender
{
    self.selectedButton.selected = NO;
    self.selectedButton = sender;
    self.selectedButton.selected = YES;
    NSString *fileName;
    if (sender.tag == 0) {
        fileName = @"bg";
    } else {
        WRMusic *music = self.viewModel.musicArray[sender.tag - 1];
//        NSArray *array = [music.fileName componentsSeparatedByString:@"."];
//        if (array.count > 0) {
//            fileName = array[0];
//        }
        fileName = music.fileName;
    }
    if (self.clickedMusicBlock) {
        self.clickedMusicBlock(sender,fileName);
    }
}

#pragma mark - ui
- (void)createUndownloadView
{
    UIView *view = self.defaultButton.superview;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"下载背景音乐包", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont wr_lightFont];
    button.backgroundColor = [UIColor whiteColor];
    button.userInteractionEnabled = YES;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickedDownloadButton:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5.0f;
    button.clipsToBounds = YES;
    [button sizeToFit];
    button.size = CGSizeMake(button.width + 30, button.height * 1.4);
    [view addSubview:button];
    button.frame = [Utility moveRect:button.frame x:(view.width - button.width)/2 y:button.bottom + WRUIOffset];
    self.downloadButton = button;
}

- (void)completeMusicListView
{
    CGFloat x, y;
    x = 0;
    y = self.defaultButton.height + WRUIOffset;
    UIView *view = self.musicListView;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:self.viewModel.musicArray];
    
    self.downloadButton.hidden = YES;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *key = @"backgroundMusicName";
    NSString *musicName = [ud objectForKey:key];
    for (int i = 0; i<self.dataArray.count; i++) {
        WRMusic *music = self.dataArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([musicName isEqualToString:music.fileName]) {
            self.selectedButton.selected = NO;
            button.selected = YES;
            self.selectedButton = button;
        }
        [view addSubview:button];
        button.tag = i + 1;
        [button setTitle:music.name forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont wr_smallTitleFont];
        [button setTitleColor:[UIColor wr_lightWhite] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor wr_themeColor] forState:UIControlStateSelected];
        [button sizeToFit];
        button.frame = CGRectMake((view.width - button.width)/2, y, button.width, button.height);
        y = button.bottom + WRUIOffset;
        [button addTarget:self action:@selector(onClickedMusicButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (UIView *)createAllMusicListViewWithFrame:(CGRect)frame
{
    CGFloat x, y;
    x = 0;
    y = self.defaultButton.bottom + WRUIOffset;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *key = @"backgroundMusicName";
    NSString *musicName = [ud objectForKey:key];
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self.contentView addSubview:view];
    WRMusic *defaultMusic = [[WRMusic alloc] init];
    defaultMusic.name = NSLocalizedString(@"默认背景音乐", nil);
    [self.dataArray addObject:defaultMusic];
    [self.dataArray addObjectsFromArray:self.viewModel.musicArray];
    for (int i = 0; i<self.dataArray.count; i++) {
                WRMusic *music = self.dataArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([musicName isEqualToString:music.fileName]) {
            button.selected = YES;
            self.selectedButton = button;
        }
        if ([musicName isEqualToString:@"bg"] || !musicName) {
            if (i == 0) {
                button.selected = YES;
                self.selectedButton = button;
            }
        }
        [view addSubview:button];

        button.tag = i;
        [button setTitle:music.name forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont wr_lightFont];
        [button setTitleColor:[UIColor wr_lightWhite] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor wr_themeColor] forState:UIControlStateSelected];
        [button sizeToFit];
        button.frame = CGRectMake((view.width - button.width)/2, y, button.width, button.height);
        y = button.bottom + WRUIOffset;
        [button addTarget:self action:@selector(onClickedMusicButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return view;
}

#pragma mark -
-(void)show
{
    self.alpha = 0;
    self.hidden = NO;
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.alpha = 1;
    }];
}


@end
