//
//  ChooseMusicController.m
//  rehab
//
//  Created by yefangyang on 2016/10/25.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "ChooseMusicController.h"
#import "SSZipArchive.h"
#import "AFNetworking.h"
#import "DownloadMusicViewModel.h"
#import "SVProgressHUD.h"
#import <YYKit/YYKit.h>

@interface ChooseMusicController ()<SSZipArchiveDelegate>{
    NSURLSessionDownloadTask *_downloadTask;
    NSString *_downString;
}
@property (nonatomic, strong) DownloadMusicViewModel *viewModel;
@property (nonatomic, strong) UIView *unLoadView;
@property (nonatomic, strong) UIView *musicListView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, strong) UILabel *switchLabel;

@end

@implementation ChooseMusicController

- (DownloadMusicViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[DownloadMusicViewModel alloc] init];
    }
    return _viewModel;
}
- (instancetype)init
{
    if (self = [super init]) {
        __weak __typeof(self)weakself = self;
        self.dataArray = [NSArray array];
        self.view.backgroundColor = [UIColor wr_lightWhite];
        CGFloat y, cx, cy, offset;
        offset = WRUIOffset;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_close"]];
        imageView.userInteractionEnabled = YES;
        [imageView bk_whenTapped:^{
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.view addSubview:imageView];
        imageView.frame = [Utility moveRect:imageView.frame x:0 y:0];
        
        UISwitch *control = [[UISwitch alloc] init];
        control.on = self.isOn;
        [control addBlockForControlEvents:UIControlEventValueChanged block:^(id  _Nonnull sender) {
            UISwitch *control = sender;
            control.on = !control.on;
            self.isOn = !self.isOn;
            weakself.switchLabel.text = control.on?NSLocalizedString(@"背景音乐已打开", nil):NSLocalizedString(@"背景音乐已关闭", nil);
        }];
        [self.view addSubview:control];
        control.frame = [Utility moveRect:control.frame x:(self.view.width - control.width)/2 y:imageView.bottom + offset];
        
        y = control.bottom + 2 * offset;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, cx, cy)];
        label.text = control.isOn?NSLocalizedString(@"背景音乐已打开", nil):NSLocalizedString(@"背景音乐已关闭", nil);
        label.font = [UIFont wr_textFont];
        label.textColor = [UIColor grayColor];
        [self.view addSubview:label];
        [label sizeToFit];
        label.frame = [Utility resizeRect:label.frame cx:label.width height:label.height];
        label.frame = [Utility moveRect:label.frame x:(self.view.width - label.width)/2 y:-1];
        y = label.bottom + 5 * offset;
        self.switchLabel = label;
        
        CGRect frame = CGRectMake(0, y, self.view.width, self.view.height);
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *key = @"backgroundMusic";
        NSString *version = [ud objectForKey:key];
        if (!version) {
            UIView *undownloadView = [self createUndownloadViewWithFrame:frame];
            [self.view addSubview:undownloadView];
            self.unLoadView = undownloadView;
        } else {
            __weak __typeof(self)weakself = self;
            [self.viewModel fetchDownloadDataWithCompletion:^(NSError *error) {
                if (error) {
                    
                } else {
                    
                                //todo if(有更新的背景音乐) else
                    
                    [UIView animateWithDuration:1 animations:^{
                        CGRect frame = CGRectMake(0, self.switchLabel.bottom + 5 * offset, weakself.view.width, 0);
                        weakself.musicListView = [weakself createMusicListViewWithFrame:frame];
                        weakself.unLoadView.hidden = YES;
                    }];
                }
            }];

        }
    }
    return self;
}

- (UIView *)createUndownloadViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [[UILabel alloc] init];
    label.text = NSLocalizedString(@"默认背景音乐", nil);
    label.font = [UIFont wr_titleFont];
    [label sizeToFit];
    [view addSubview:label];
    label.frame = [Utility moveRect:label.frame x:(view.width - label.width)/2 y:0];
    
    UIButton *clickedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickedButton setTitle:NSLocalizedString(@"下载背景音乐包", nil) forState:UIControlStateNormal];
    clickedButton.titleLabel.font = [UIFont wr_titleFont];
    clickedButton.backgroundColor = [UIColor greenColor];
    clickedButton.userInteractionEnabled = YES;
    [clickedButton addTarget:self action:@selector(onClickedDownloadButton:) forControlEvents:UIControlEventTouchUpInside];
    clickedButton.layer.cornerRadius = 5.0f;
    clickedButton.clipsToBounds = YES;
    [clickedButton sizeToFit];
    [view addSubview:clickedButton];
    clickedButton.frame = [Utility moveRect:clickedButton.frame x:(view.width - clickedButton.width)/2 y:label.bottom + WRUIOffset];
    view.height = clickedButton.bottom;
    return view;
}

- (IBAction)onClickedDownloadButton:(UIButton *)sender
{
    __weak __typeof(self)weakself = self;
    [self.viewModel fetchDownloadDataWithCompletion:^(NSError *error) {
        if (error) {
            
        } else {
                            NSLog(@"%@",weakself.viewModel.url);
                            _downString = weakself.viewModel.url;
                            [self downFileFromServer];
//            [UIView animateWithDuration:1 animations:^{
//                CGRect frame = CGRectMake(0, self.unLoadView.top, weakself.view.width, 0);
//                weakself.musicListView = [weakself createMusicListViewWithFrame:frame];
//                weakself.unLoadView.hidden = YES;
//            }];
        }
    }];
}

- (IBAction)onClickedMusicButton:(UIButton *)sender
{
    self.selectedButton.selected = NO;
    self.selectedButton = sender;
    self.selectedButton.selected = YES;
}

- (UIView *)createMusicListViewWithFrame:(CGRect)frame
{
    CGFloat x, y;
    x = 0;
    y = 0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:view];
    self.dataArray = self.viewModel.musicArray;
    for (int i = 0; i<self.dataArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:button];
        WRMusic *music = self.dataArray[i];
        button.tag = i;
        [button setTitle:music.name forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont wr_textFont];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor wr_themeColor] forState:UIControlStateSelected];
        [button sizeToFit];
        button.frame = CGRectMake((view.width - button.width)/2, y, button.width, button.height);
        y = button.bottom + WRUIOffset;
        [button addTarget:self action:@selector(onClickedMusicButton:) forControlEvents:UIControlEventTouchUpInside];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, frame.size.width, 0)];
//        [view addSubview:label];
//        WRMusic *music = self.dataArray[i];
//        [label bk_whenTapped:^{
//            [weakself dismissViewControllerAnimated:YES completion:^{
//                if (weakself.ChooseMusicBlock) {
//                    weakself.ChooseMusicBlock();
//                }
//            }];
//
//        }];
//        label.tag = i;
//        label.text = music.name;
//        label.font = [UIFont wr_textFont];
//        [label sizeToFit];
//        label.frame = [Utility moveRect:label.frame x:(view.width - label.width)/2 y:-1];
//        y = label.bottom + WRUIOffset;
    }
    view.height = y;
    return view;
}


- (void)downFileFromServer{
    //远程地址
    NSURL *URL = [NSURL URLWithString:_downString];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //下载Task操作
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // 下载进度
        [SVProgressHUD showProgress:(float)(downloadProgress.completedUnitCount)/downloadProgress.totalUnitCount
                             status:NSLocalizedString(@"正在下载音乐包", nil)];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
//        LRLog(@"imgFilePath = %@",imgFilePath);
//        NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//        NSString *path = [[documentArray lastObject] stringByAppendingPathComponent:@"Preferences"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        [self releaseZipFilesWithUnzipFileAtPath:imgFilePath Destination:docDir];
    }];
    [_downloadTask resume];
}
// 解压
- (void)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath Destination:(NSString *)unzipPath{
    NSError *error;
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil error:&error delegate:self]) {
        NSLog(@"success");
        NSLog(@"unzipPath = %@",unzipPath);
    }else {
        NSLog(@"%@",error);
    }
}
#pragma mark - SSZipArchiveDelegate
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo {
    NSLog(@"将要解压。");
    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"正在解压", nil)];
}
- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath unzippedFilePath:(NSString *)unzippedFilePath{
    NSLog(@"%@ %@",archivePath,unzippedFilePath);
}

- (BOOL)zipArchiveShouldUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo
{
    NSLog(@"%d %d %@",(int)fileIndex,(int)totalFiles,archivePath);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.viewModel.version forKey:@"backgroundMusic"];
    [UIView animateWithDuration:1 animations:^{
        CGRect frame = CGRectMake(0, self.unLoadView.top, self.view.width, 0);
        self.musicListView = [self createMusicListViewWithFrame:frame];
        self.unLoadView.hidden = YES;
    }];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
