//
//  WRMyViewController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/13.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRMyViewController.h"
#import "WRUserInfo.h"
#import "SDPhotoBrowser.h"
#import "UserBasicInfoController.h"
#import "WRSelfInfoPanelView.h"
#import "BindClientViewController.h"
#import "AppDelegate+WR.h"
#import "AboutController.h"
#import "ProtocolController.h"
#import "FeedbackController.h"
#import "WRImagePicker.h"
#import "WRViewModel.h"
#import "WRViewModel+Common.h"
#import "ShareUserData.h"
#import "TrainRecordController.h"
#import "AskIndexController.h"
#import "FavorIndexController.h"
#import "UserViewModel.h"
#import "NotiController.h"
#import "PayController.h"
#import "IAPViewController.h"
#import "ImlistController.h"
#import "PayImViewModel.h"
#import "ChatViewController.h"
#import "AskImIndexController.h"
#import "CommunityIndexControler.h"
#import "firstReportViewController.h"
@interface WRMyViewController ()
{
    BOOL _isUserHead;
     WRImagePicker *_imagePicker;
    NSDate* _startDate;
}
@property (weak, nonatomic) IBOutlet UIImageView *headid;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *chae;
@property (weak, nonatomic) IBOutlet UISwitch *musicSw;
@property (weak, nonatomic) IBOutlet UISwitch *alrmSw;
@property CGFloat Path;
@property(nonatomic)WRUserInfo *userInfo;
@property (weak, nonatomic) IBOutlet UIView *top;
@property (nonatomic, strong) WRSelfInfoPanelView *headImageView;
@property BOOL addbottom;
@property UIButton* buybtn;


@end

@implementation WRMyViewController
-  (instancetype)init
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"my"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alrmSw.transform = CGAffineTransformMakeScale(0.75, 0.75);
    self.musicSw.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [self.tableView.tableHeaderView bk_whenTapped:^{
       
        [UMengUtils careForMeHome];
        UIViewController *viewController = [[UserBasicInfoController alloc] init];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    [self updateSelfInfo];
    [self.headid bk_whenTapped:^{
        
        _isUserHead = YES;
        if (!_imagePicker) {
            __weak __typeof(self) weakSelf = self;
            
            _imagePicker = [[WRImagePicker alloc] initWithController:self.navigationController targetSize:CGSizeMake(320, 320) imageView:(UIImageView *)_headid];
            _imagePicker.completion = ^(UIImage* image) {
                [weakSelf uploadImage:image];
            };
        }
        [_imagePicker show];
        
    }];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.Path= [self filePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.chae.text=[NSString stringWithFormat:@"%.2lfM",self.Path];
        });
        
    });

    
    
    UIImage* image = [UIImage imageNamed:@"通知消息"];
    UIButton*  buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(0, 0, 43.f/2, 32.f/2);
    buttonRight.imageView.contentMode = UIViewContentModeScaleToFill;
    [buttonRight setBackgroundImage:image forState:0];
    [buttonRight addTarget:self action:@selector(onClickedRightBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 57+30)];
    
    // Do any additional setup after loading the view.
}
-(void)onClickedRightBarButtonItem:(UIButton*)sender
{
    NotiController* noti = [NotiController new];
    noti.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noti animated:YES];
}
#pragma mark -
-(void)viewWillAppear:(BOOL)animated
{
    [self updateSelfInfo];
    _startDate = [NSDate new];
    PayImViewModel* pay = [PayImViewModel new];
    [pay fetchAlreadyOrdercompletion:^(NSError * _Nonnull error) {
        [self.buybtn removeFromSuperview];
        self.buybtn = nil;
        for (NSDictionary*dic in pay.orderlist) {
            UIButton* btn = [UIButton new];
            btn.x = 0;
            btn.y = 20;
            [btn setBackgroundImage:[UIImage imageNamed:@"签约服务中图标"] forState:0];
            
            if ([dic[@"type"] integerValue]==2) {
                
                [btn setTitle:@"       签约服务中" forState:0];
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn sizeToFit];
                [btn bk_whenTapped:^{
                    NSDate* enddate= [NSDate dateWithString:dic[@"endDate"]];
                    NSDate* startdate = [NSDate date];
                    NSDateFormatter* format =[NSDateFormatter new];
                    [format setDateFormat:@"YYYY-MM-dd"];
                    long long starin = [startdate timeIntervalSince1970];
                    long long endin = [enddate timeIntervalSince1970];
                    CGFloat day = (endin -  starin)*1.0/60/60/24;
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString  stringWithFormat:@"\n签约服务还剩下%.0lf天\n到期时间%@",day,[format stringFromDate:enddate]] preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }];
                
            }
            else if([dic[@"type"] integerValue]==1)
            {
                [btn setTitle:@"       单次服务中" forState:0];
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn sizeToFit];
                
            }
            self.buybtn = btn;
            
          //  [self.top addSubview:btn];
            
            
        }
    }];
    
}

-(void)updateSelfInfo {
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    UIImage *defaultHeadImage = [WRUIConfig defaultHeadImage];
    if ([selfInfo isLogged]) {
        if (![Utility IsEmptyString:selfInfo.headImageUrl]) {
            [self.headid setImageWithUrlString:selfInfo.headImageUrl holder:@"well_default_head"];
        } else {
            self.headid.image = defaultHeadImage;
        }
        
        NSString *name = selfInfo.name;
        if ([Utility IsEmptyString:name]) {
            name = NSLocalizedString(@"请到个人资料填写昵称", nil);
        }
        self.name.text = name;
    } else {
        self.headid.image = defaultHeadImage;
        self.name.text = NSLocalizedString(@"", nil);
    }

    
    
}

-(NSString *)getCachesPath{
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    NSString *filePath = [cachesDir stringByAppendingPathComponent:@"com.sphtest.www"];
    
    return filePath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)headBtn:(UIButton *)sender {
    
    
    switch (sender.tag) {
        case 101:
        {
            TrainRecordController* tr = [TrainRecordController new];
            tr.hidesBottomBarWhenPushed=YES;
            //锚点
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"wddz"] attributes:nil counter:duration];
            
            
            
            [self.navigationController pushViewController:tr animated:YES];
        }
            break;
        case 102:
        {
            AskIndexController* tr = [AskIndexController new];
            //锚点
            tr.index =1;
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"wdtw"] attributes:nil counter:duration];
            tr.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:tr animated:YES];
        }
            break;
        case 103:
        {
            FavorIndexController* tr = [FavorIndexController new];
            tr.hidesBottomBarWhenPushed=YES;
            //锚点
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"wdsc"] attributes:nil counter:duration];
            [self.navigationController pushViewController:tr animated:YES];
        }
            break;
        case 104:
        {
            
            
            CommunityIndexControler * index = [CommunityIndexControler new];
            index.isSelf = YES;
            index.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:index animated:YES];
//            PayImViewModel* pay = [PayImViewModel new];
//             [pay fetchAlreadyOrdercompletion:^(NSError * _Nonnull error) {
//                 NSInteger n = [pay.status integerValue];
//                 if (n==1) {
//                     [AppDelegate show:@"咨询服务正在维护"];
//
//                 }
//                 else if (n==2)
//                 {
//                     ChatViewController *chatController = nil;
//                     chatController = [[ChatViewController alloc] initWithConversationChatter:@"rudy123" conversationType:0];
//                     //                chatController.hideBottom = YES;
//                     chatController.hideBottom = YES;
//
//                     chatController.hidesBottomBarWhenPushed =YES;
//
//                     [self.navigationController pushViewController:chatController animated:YES];
//                     [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
//                 }
//                 else if (n==3)
//                 {
//                     ChatViewController *chatController = nil;
//                     chatController = [[ChatViewController alloc] initWithConversationChatter:@"rudy123" conversationType:0];
//
//                     chatController.hidesBottomBarWhenPushed =YES;
//
//                     [self.navigationController pushViewController:chatController animated:YES];
//                     [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
//                 }
//                 AskImIndexController* askim = [AskImIndexController new];
//                 askim.hidesBottomBarWhenPushed = YES;
//                 [self.navigationController pushViewController:askim animated:YES];
//
//             }];
            
            
            
        }
            break;
        case 105:
        {
             AskImIndexController* askim = [AskImIndexController new];
             askim.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:askim animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)update {
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    UIImage *defaultHeadImage = [WRUIConfig defaultHeadImage];
    if ([selfInfo isLogged]) {
        if (![Utility IsEmptyString:selfInfo.headImageUrl]) {
            [self.headid setImageWithUrlString:selfInfo.headImageUrl holder:@"well_default_head"];
        } else {
            self.headid.image = defaultHeadImage;
        }
        
        NSString *name = selfInfo.name;
        if ([Utility IsEmptyString:name]) {
            name = NSLocalizedString(@"请到个人资料填写昵称", nil);
        }
        self.name.text = name;
    } else {
        self.headid.image = defaultHeadImage;
        self.name.text = NSLocalizedString(@"立即登录", nil);
    }
    //self.logOffButton.hidden = ![selfInfo isLogged];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1&&indexPath.row==0) {
        UIViewController *viewController = [BindClientViewController new];
        viewController.hidesBottomBarWhenPushed=YES;

        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    if (indexPath.section==1&&indexPath.row==1) {
        UIViewController *viewController = [ImlistController new];
        viewController.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    }

    if (indexPath.section==1&&indexPath.row==2) {
        UIViewController *viewController = [PayController new];
        viewController.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    else if(indexPath.section==1&& indexPath.row==3)
    {
        NSString *title = NSLocalizedString(@"诚邀您体验WELL健康", nil);
        NSString *detail = NSLocalizedString(@"专业运动康复", nil);
        NSString *targetUrlString = [WRNetworkService getFormatURLString:urlShareApp];
        /*
         NSString *shareLogoUrl = [WRNetworkService getFormatURLString:urlShareLogo];
         [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:shareLogoUrl];
         [UMSocialData defaultData].extConfig.title = NSLocalizedString(@"诚邀您体验WELL健康", nil);
         [UMSocialData defaultData].extConfig.qqData.url = @"http://www.well-health.cn/m";
         [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
         [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.well.health";
         [UMSocialSnsService presentSnsIconSheetView:self
         appKey:UMAppKey
         shareText:NSLocalizedString(@"专业运动康复", nil)
         shareImage:nil
         shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ]
         delegate:nil];
         */
        [UMengUtils shareWebWithTitle:title detail:detail url:targetUrlString image:[UIImage imageNamed:@"logo"] viewController:self];
        [UserViewModel fetchSaveShareType:@"app" completion:^(NSError *error, id object) {
            
        }];
        

    }
    else if(indexPath.section==1&&indexPath.row==4)
    {
        [self evaluate];
        
    }else if(indexPath.section==2&&indexPath.row==0)
    {
        [self action:nil];
    }
    else if(indexPath.section==2&&indexPath.row==1)
    {
        
        UIViewController *viewController = [AboutController new];
        viewController.hidesBottomBarWhenPushed=YES;

        [self.navigationController pushViewController:viewController animated:YES];
     
        
        

    }
    else if(indexPath.section==2&&indexPath.row==2)
    {
        
        UIViewController *viewController = [ProtocolController new];
        viewController.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if(indexPath.section==2&&indexPath.row==3)
    {
        
        UIViewController *viewController = [FeedbackController new];
        viewController.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}
- (void)evaluate{
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/well-jian-kang-yun-dong-chu/id%@?mt=8", WRAppId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
-( float )filePath
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
- (void)action:(id)sender
{
    
    if ([self.chae.text isEqualToString:@"0.00M"]) {
        [AppDelegate show:@"您的app已经很干净啦！"];
    }else{
        NSString*message=[NSString stringWithFormat:@"缓存大小为%@，确定要清理缓存吗？",self.chae.text];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message   delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确认" ,nil];
        //alert.delegate=self;
        [alert show];
    }
   
    
    
  
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0);
{
    
    if (buttonIndex==1)
    {
        //彻底清除缓存第一种方法
        
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                       , ^{
                           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                           NSLog(@"%@", cachPath);
                           
                           NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                           NSLog ( @"cachpath = %@" , cachPath);
                           for (NSString *p in files) {
                               NSError *error;
                               NSString *path = [cachPath stringByAppendingPathComponent:p];
                               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               }
                           }
                           [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    }
    
    
}
-(void)clearCacheSuccess
{
    [AppDelegate show:@"清除完成"];
    self.chae.text=[NSString stringWithFormat:@"%.2lfM",[self filePath]];
    
    
}



-(void)uploadImage:(UIImage*)image {
    
    NSString *title = _isUserHead ? NSLocalizedString(@"修改头像失败", nil) : NSLocalizedString(@"上传图片失败", nil);
    __weak __typeof(self) weakSelf = self;
    void (^failedBlock)(NSError *) = ^ (NSError *error) {
        [Utility retryAlertWithViewController:weakSelf.navigationController title:title completion:^{
            [weakSelf uploadImage:image];
        }];
        if (error) {
            NSLog(@"failed %@", error.localizedDescription);
        }
    };
    
    [SVProgressHUD showProgress:0 status:NSLocalizedString(@"正在上传图片", nil)];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *type = _isUserHead ? @"userHead" : @"userDisease";
    NSString *url = [NSString stringWithFormat:[WRNetworkService getFormatURLString: urlUpload],type];
    NSLog(@"url %@",url);
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData * imageData = UIImagePNGRepresentation(image);
        NSString *fileName = [NSString stringWithFormat:@"%@%zi.png", @"image", 0];
        [formData appendPartWithFileData:imageData name:@"self" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [SVProgressHUD showProgress:(float)(uploadProgress.completedUnitCount)/uploadProgress.totalUnitCount
                             status:NSLocalizedString(@"正在上传图片", nil)];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *json = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        WRJsonParser *parser = [WRJsonParser ParserFromString:json];
        if (parser.isSuccess) {
            NSDictionary *dict = parser.resultObject;
            
            BOOL flag = NO;
            do{
                NSArray *array = dict[@"fileList"];
                if (array.count == 0) {
                    break;
                }
                
                NSMutableArray *imageUrlArray = [NSMutableArray array];
                NSMutableArray *imageIdArray = [NSMutableArray array];
                
                [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *path = obj[@"fileUrl"];
                    NSString *imageId = obj[@"fileId"];
                    if (![Utility IsEmptyString:path]) {
                        [imageUrlArray addObject:path];
                        [imageIdArray addObject:imageId];
                    }
                }];
                
                if (imageUrlArray.count == 0) {
                    break;
                }
                flag = YES;
                if (_isUserHead) {
                    NSString *imageUrl = imageUrlArray.firstObject;
                    NSString *fileId = imageIdArray.firstObject;
                    NSLog(@"%@ %@", imageUrl, fileId);
                    
                    [WRViewModel modifySelfBasicInfo:@{@"imageId":fileId} completion:^(NSError * _Nonnull error) {
                        [SVProgressHUD dismiss];
                        if (error) {
                            failedBlock(error);
                        } else {
                            [WRUserInfo selfInfo].headImageUrl = imageUrl;
                            [[WRUserInfo selfInfo] save];
                            [weakSelf updateSelfInfo];
                            [[NSNotificationCenter defaultCenter] postNotificationName:WRUpdateSelfInfoNotification object:nil];
                        }
                    }];
                } else {
                    NSString *idString = [imageIdArray componentsJoinedByString:@"|"];
                    [WRViewModel operationWithType:OperationTypeUserDiseasePhoto indexId:idString actionType:OperationActionTypeAdd contentType:OperationContentTypeUnknown completion:^(NSError * _Nonnull error) {
                        [SVProgressHUD dismiss];
                        if (error) {
                            failedBlock(error);
                        } else {
                            NSMutableArray *photoArray = [ShareUserData userData].diseasePhotoArray;
                            [photoArray addObjectsFromArray:imageUrlArray];
                            [weakSelf.tableView reloadData];
                        }
                    }];
                }
            }while (NO);
            
            if (!flag) {
                [SVProgressHUD dismiss];
                failedBlock(nil);
            }
            
        } else {
            [SVProgressHUD dismiss];
            failedBlock(nil);
        }
        NSLog(@"success %@", json);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        failedBlock(error);
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section==1&&indexPath.row==1) {
        
        return 0;
       
    }
    else if (indexPath.section==0)
    {
        return 93;
    }
    else
    {
        return 44;
    }
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
