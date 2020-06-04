//
//  FriendSendController.m
//  rehab
//
//  Created by yongen zhou on 2017/8/9.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "FriendSendController.h"
#import "EMTextView.h"
#import "WRViewModel.h"
#import "SVProgressHUD.h"
#import "ReactiveCocoa.h"
#import "WToast.h"
#import "WRImagePicker.h"
#import "XHImageViewer.h"
#import "UIFont+YYAdd.h"
#import "UIImage+WR.h"
#import "SDLabTagsView.h"
#import "WrWebViewController.h"
#import "FCAlertView.h"
#import "GBTagListView.h"
#import "CommunityIndexControler.h"
#import "FCAlertView.h"
#import "UserBasicInfoController.h"
#define iphone4 (CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size))
#define iphone5 (CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size))
#define iphone6 (CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size))
#define iphone6plus (CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size))
@interface FriendSendController ()<XHImageViewerDelegate,UITextViewDelegate>
{
    NSDate *_startDate;
    NSMutableArray *_imageArray;
    __weak UIImageView *_currentSelectedImageView;
    WRImagePicker *_imagePicker;
    float _TimeNUMX;
    float _TimeNUMY;
}

@property(nonatomic)FCAlertView *alert;
@property(nonatomic)UITextField* contactInfoTextField;
@property(nonatomic)NSArray *imageIdsArray;
@property(nonatomic)NSArray *imageUrlArray;
@property (nonatomic, strong) XHImageViewer *imageViewer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString* uuid;
@property (weak, nonatomic) IBOutlet UIImageView *add;

@property (weak, nonatomic) IBOutlet UILabel *listTitle;
@property (weak, nonatomic) IBOutlet EMTextView *text;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newheight;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imarr;

@property SDLabTagsView* tagview;
@property (weak, nonatomic) IBOutlet GBTagListView *tags;
@property (weak, nonatomic) IBOutlet UIView *imsView;
@property NSMutableArray* imgarr;

@property (nonatomic,strong) UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (nonatomic,copy)   NSString * modelUrl;
@end

@implementation FriendSendController
-  (instancetype)init
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"friendsend"];
    return self;
}


-(void)textViewDidChange:(UITextView *)textView
{
    self.count.text = [NSString stringWithFormat:@"还可以输入%ld字",200-textView.text.length+1];
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.showInView = self.imsView;
    [self initPickerView];
    _TimeNUMX = [self BackTimeNUMX];
    _TimeNUMY = [self BackTimeNUMY];
    self.text.delegate = self;
  /*  self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20*_TimeNUMX, 20*_TimeNUMY, 80*_TimeNUMX, 90*_TimeNUMY)];
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.modelUrl] placeholderImage:[UIImage imageNamed:@"plus"]];
    UIButton * clickImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(20*_TimeNUMX, 20*_TimeNUMY, 80*_TimeNUMX, 90*_TimeNUMY)];
    [clickImageBtn addTarget:self action:@selector(ClickImage:) forControlEvents:UIControlEventTouchUpInside];
    clickImageBtn.backgroundColor = [UIColor clearColor];
    [self.imsView addSubview:self.photoImageView];
    [self.imsView addSubview:clickImageBtn];
   */
    
    _text . placeholder = @"记录一下您的康复历程吧!";
    _add.layer.cornerRadius = 4;
    _add.layer.borderColor = [UIColor wr_lineColor].CGColor;
    _add.layer.borderWidth = 1;
    _add.layer.masksToBounds =YES;
    
    _text.font = [UIFont systemFontOfSize:13];
    _text.delegate =self;
    NSString *userdefaule =[DEFAULTS objectForKey:@"finderHomeVCcity"];
    if (userdefaule.length>0) {
        _text.text = userdefaule;
    }
    
    
    self.title = @"发表动态";
    UIButton* right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30+4, 15)];
    [right setTitle:@"发送" forState:0];
    [right setTitleColor:[UIColor wr_rehabBlueColor] forState:0];
    [right bk_whenTapped:^{
        
        WRUserInfo *userInfo = [WRUserInfo selfInfo];
        if ([userInfo.name isEqualToString:@""]) {
            _alert = [[FCAlertView alloc] init];
            [_alert showAlertInView:nil withTitle:NSLocalizedString(@"温馨提示", nil) withSubtitle:NSLocalizedString(@"发表动态前需要完善个人信息!", nil) withCustomImage:nil withDoneButtonTitle:NSLocalizedString(@"立即完善", nil) andButtons:nil];
            [_alert addButton:NSLocalizedString(@"取消", nil) withActionBlock:^{
                [_alert dismissAlertView];
            }];
            [_alert doneActionBlock:^{
                UIViewController *viewController = [[UserBasicInfoController alloc] init];
                viewController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }];
            _alert.hideDoneButton = NO;
            _alert.colorScheme = [UIColor wr_themeColor];
        }else
        {
            if (![self.text.text isEqualToString:@""]) {
                if (self.iffriend) {
                    [self NewUploadImage];
                }
                else
                {
                    [self uploadImage];
                }
            }
            else
            {
                [AppDelegate show:@"请输出要发送的内容"];
            }
        }
        
        
       
        
    }];
    right.titleLabel.font = [UIFont systemFontOfSize:WRTitleFont];
    UIBarButtonItem* item  = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
    [self createBackBarButtonItem];
    _imageArray = [NSMutableArray array];
    for (UIImageView* im in self.imarr) {
        im.userInteractionEnabled=YES;
    
        
    [_imageArray addObject:[NSNull null]];
    }
    // Do any additional setup after loading the view.
}
- (void)pickerViewFrameChanged{
    [self updateViewsFrame];
}
- (void)updateViewsFrame{
    
    self.newheight.constant = (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(self.arrSelected.count)/4 +1)+20.0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [WRViewModel getCirclesCompletion:^(NSError * error, NSArray * _Nonnull crArry) {
        if (!error) {
            NSArray* crarry = crArry;
            if ([crarry isKindOfClass:[NSArray class]]) {
                NSMutableDictionary* dict = [NSMutableDictionary dictionary];
                for (NSDictionary* dic in crarry ) {
                    dict[dic[@"circleId"]] = dic[@"name"];
                }
                NSMutableArray* tagsarr = [dict allValues];
                
                
                
                self.tags.canTouch = YES;
                self.tags.signalTagColor=[UIColor whiteColor];
                self.tags.style = 0;
                NSArray* choosearr =[NSArray array];
                if (self.crid&&![self.crid isEqualToString:@"(null)"]) {
                    if (dict[self.crid]!=nil) {
                       choosearr = @[dict[self.crid]];
                    }
                    
                }
                else
                {
                    self.crid= nil;
                }
                [self.tags setTagWithNormalArray:tagsarr selectedArray:choosearr];
                
                [self.tags setDidselectItemBlock:^(NSArray *arr) {
                    NSArray* ids  = [dict allKeysForObject:arr[0]];
                    self.crid = ids[0];
                    
                    
                }];
                

            }
        }
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)uploadImage
{
    
    [WRViewModel getuuidcompletion:^(NSError * _Nonnull error, NSString * _Nonnull uuid) {
        self.uuid = uuid;
        
        
        
        NSUInteger count = 0;
        for(id object in self.getBigImageArray)
        {
            if (![object isEqual:[NSNull null]]) {
                count++;
            }
        }
        if (count == 0) {
            [self request];
            return;
        }
        [SVProgressHUD showProgress:0 status:NSLocalizedString(@"正在上传图片", nil)];
        NSString*parmer=nil;
        NSString *url = [NSString stringWithFormat:[WRNetworkService getFormatURLString: urlUpload],@"feedback"];
        if (self.iffriend) {
            parmer = @{@"uuid":self.uuid};
            url =[WRNetworkService getFormatURLString:Uploadcircles];
        }
        
        __weak __typeof(self) weakSelf = self;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 86400.f;
       // [manager setSecurityPolicy:[WRBaseRequest customSecurityPolicy]];
        [manager POST:url parameters:parmer constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            int index = 0;
            for(id object in self.bigImgDataArray)
            {
                if (![object isEqual:[NSNull null]]) {
                    
                    UIImage *image = [UIImage imageWithData:object];
                    //UIImage转换为NSData
                    
                    NSData*imageData= UIImageJPEGRepresentation(image, 0.01);
                    NSString *fileName = [NSString stringWithFormat:@"%@%i.jpg", @"image", index];
                    [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"images"] fileName:fileName mimeType:@"image/jpeg"];
                    index++;
                }
            }
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
                    weakSelf.imageIdsArray = imageIdArray;
                    flag = YES;
                    
                }while (NO);
                
                if (!flag) {
                    [SVProgressHUD dismiss];
                    [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"上传图片失败", nil) completion:^{
                        [weakSelf uploadImage];
                    }];
                } else {
                    [weakSelf request];
                }
                
            } else {
                [SVProgressHUD dismiss];
                [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"上传图片失败", nil) completion:^{
                    [weakSelf uploadImage];
                }];
            }
            NSLog(@"success %@", json);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD dismiss];
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"上传图片失败", nil) completion:^{
                [weakSelf uploadImage];
            }];
            NSLog(@"failed %@", error.localizedDescription);
            
        }];
        
    }];
    
}

-(void)NewUploadImage
{
    
//    [WRViewModel getuuidcompletion:^(NSError * _Nonnull error, NSString * _Nonnull uuid) {
//        self.uuid = uuid;
//
    
        
        NSUInteger count = 0;
        for(id object in self.getBigImageArray)
        {
            if (![object isEqual:[NSNull null]]) {
                count++;
            }
        }
        if (count == 0) {
            [self NewRequest];
            return;
        }
        [SVProgressHUD showProgress:0 status:NSLocalizedString(@"正在上传图片", nil)];
        NSString*parmer=nil;
        NSString *url = [NSString stringWithFormat:[WRNetworkService getFormatURLString: urlUpload],@"feedback"];
        if (self.iffriend) {
            parmer = @{@"userId":[WRUserInfo selfInfo].userId};
            url =[WRNetworkService getFormatURLString:uploadImg];
        }
        
        
        
        
        __weak __typeof(self) weakSelf = self;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 86400.f;
        [manager setSecurityPolicy:[WRBaseRequest customSecurityPolicy]];
        [manager POST:url parameters:parmer constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            int index = 0;
            for(id object in self.bigImgDataArray)
            {
                if (![object isEqual:[NSNull null]]) {
                    
//                    NSData * imageData = object;
                    UIImage *image = [UIImage imageWithData:object];
                    //UIImage转换为NSData
                    
                     NSData*imageData= UIImageJPEGRepresentation(image, 0.01);
                    NSString *fileName = [NSString stringWithFormat:@"%@%i.jpg", @"image", index];
                    [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"images"] fileName:fileName mimeType:@"image/jpeg"];
                    
//                    NSData*data= UIImageJPEGRepresentation(object, 0.01);
//
//                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//
//                    // 设置时间格式
//                    formatter.dateFormat = @"yyyyMMddHHmmss";
//                    NSString *str = [formatter stringFromDate:[NSDate date]];
//                    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//
//
//
//                    [formData appendPartWithFileData:data name:@"images" fileName:fileName
//                                            mimeType:@"image/png/jpg"];
          
                    index++;
                }
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            [SVProgressHUD showProgress:(float)(uploadProgress.completedUnitCount)/uploadProgress.totalUnitCount
                                 status:NSLocalizedString(@"正在上传图片", nil)];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *json = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            WRJsonParser *parser = [WRJsonParser ParserFromString:json];
            if (parser.isSuccess) {
                
                NSArray*dict = parser.resultObject;
                BOOL flag = NO;
                do{
                    
                    if (dict.count == 0) {
                        break;
                    }
                    
                    NSMutableArray *imageUrlArray = [NSMutableArray array];
//                    NSMutableArray *imageIdArray = [NSMutableArray array];
                    
                    [dict enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *path = obj;
                        if (![Utility IsEmptyString:path]) {
                            [imageUrlArray addObject:path];
                            
                        }
                    }];
                    
                    if (imageUrlArray.count == 0) {
                        break;
                    }
                    weakSelf.imageUrlArray= imageUrlArray;
                    flag = YES;
                    
                }while (NO);
                
                if (!flag) {
                    [SVProgressHUD dismiss];
                    [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"上传图片失败", nil) completion:^{
                        [weakSelf NewUploadImage];
                    }];
                } else {
                    [weakSelf NewRequest];
                }
                
            } else {
                [SVProgressHUD dismiss];
                [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"上传图片失败", nil) completion:^{
                    [weakSelf NewUploadImage];
                }];
            }
            NSLog(@"success %@", json);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD dismiss];
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"上传图片失败", nil) completion:^{
                [weakSelf NewUploadImage];
            }];
            NSLog(@"failed %@", error.localizedDescription);
            
        }];
        
//    }];
    
}

-(void)NewRequest
{
    
    if (self.iffriend) {
        if (![Utility IsEmptyString:self.text.text]) {
            [self.view endEditing:YES];
            //        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"正在提交反馈", nil)];
            [SVProgressHUD show];
            __weak __typeof(self) weakSelf = self;
            NSString *text = self.text.text;
            if (![Utility IsEmptyString:self.contactInfoTextField.text]) {
                text = [NSString stringWithFormat:@"%@ %@", self.contactInfoTextField.text, text];
            }
            NSString *imageIds = @"";
            if (self.imageIdsArray.count > 0) {
                imageIds = [self.imageIdsArray componentsJoinedByString:@"|"];
            }
            
            [SVProgressHUD showWithStatus:@"正在发送..."];
            [WRViewModel uptext:text imageUrls:[self.imageUrlArray JSONString] crid:self.crid completion:^(NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                if(error) {
                    [Utility Alert:error.domain];
                } else {
                    [SVProgressHUD dismiss];
                    weakSelf.text.text = @"";
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"您的动态发表成功。", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"返回", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        for (UIViewController* vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[CommunityIndexControler class]]) {
                                CommunityIndexControler* web = vc;
                                web.reloadcell =YES;
                                
                                [weakSelf.navigationController popToViewController:web animated:YES];
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadCom" object:nil];

                            }
                        }
                        
                        
                        
                        
                    }]];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadCom" object:nil];

                    
                }
            }];
        }
        
    }
    
    
}



-(void)request
{
    
    if (self.iffriend) {
        if (![Utility IsEmptyString:self.text.text]) {
            [self.view endEditing:YES];
            //        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"正在提交反馈", nil)];
            [SVProgressHUD show];
            __weak __typeof(self) weakSelf = self;
            NSString *text = self.text.text;
            if (![Utility IsEmptyString:self.contactInfoTextField.text]) {
                text = [NSString stringWithFormat:@"%@ %@", self.contactInfoTextField.text, text];
            }
            NSString *imageIds = @"";
            if (self.imageIdsArray.count > 0) {
                imageIds = [self.imageIdsArray componentsJoinedByString:@"|"];
            }
            [WRViewModel uptext:text uuid:self.uuid crid:self.crid completion:^(NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                if(error) {
                    [Utility Alert:error.domain];
                } else {
                    weakSelf.text.text = @"";
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"您的动态发表成功。", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"返回", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        for (UIViewController* vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[WrWebViewController class]]) {
                                WrWebViewController* web = vc;
                                web.ifrefresh =YES;
                                
                                 [weakSelf.navigationController popToViewController:web animated:YES];
                            }
                        }
                       
                        
                        
                        
                    }]];
                    [weakSelf presentViewController:controller animated:YES completion:nil];
                }
            }];
        }
        
    }
    else
    {
        
        if (![Utility IsEmptyString:self.text.text]) {
            [self.view endEditing:YES];
            //        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"正在提交反馈", nil)];
            [SVProgressHUD show];
            __weak __typeof(self) weakSelf = self;
            NSString *text = self.text.text;
            if (![Utility IsEmptyString:self.contactInfoTextField.text]) {
                text = [NSString stringWithFormat:@"%@ %@", self.contactInfoTextField.text, text];
            }
            NSString *imageIds = @"";
            if (self.imageIdsArray.count > 0) {
                imageIds = [self.imageIdsArray componentsJoinedByString:@"|"];
            }
            [WRViewModel complain:text imageIds:imageIds completion:^(NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                if(error) {
                    [Utility Alert:NSLocalizedString(@"提交失败", nil)];
                } else {
                    weakSelf.text.text = @"";
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"您的宝贵意见已经收到,感谢您的支持", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"返回", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }]];
                    [weakSelf presentViewController:controller animated:YES completion:nil];
                }
            }];
        }
        
    }
    
}


-(void)viewDidLayoutSubviews
{
    CGRect c=self.add.frame;
    c.origin.x=(self.add.frame.size.width+10)*self.imgarr.count+12;
    self.add.frame=c;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"%@",text);
    if ([[textView.text stringByReplacingCharactersInRange:range withString:text] length]>201) {
        return NO;
    }
    else
    {
        self.height.constant = [self.text.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ScreenW-16*2, MAXFLOAT)].height>60?[self.text.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ScreenW-16*2, MAXFLOAT)].height:60;
        [self.view updateConstraints];
        return YES;
    
    }
    
}

- (void)onClickedBackButton:(UIBarButtonItem *)sender
{
    if (![self.text.text isEqualToString:@""]||self.getBigImageArray.count>0) {
        FCAlertView *alert = [[FCAlertView alloc] init];
        [alert showAlertInView:self withTitle:NSLocalizedString(@"提示", nil) withSubtitle:NSLocalizedString(@"要退出此次编辑吗?\n还未发送的内容将保存", nil) withCustomImage:nil withDoneButtonTitle:NSLocalizedString(@"取消", nil) andButtons:nil];
        [alert addButton:NSLocalizedString(@"退出", nil) withActionBlock:^{
            [DEFAULTS setObject:self.text.text forKey:@"finderHomeVCcity"];
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
           
            
            
            
        }];
        alert.colorScheme = [UIColor wr_themeColor];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark 点击出大图方法
- (void)ClickImage:(UIButton *)sender{
    
}



#pragma mark 返回不同型号的机器的倍数值
- (float)BackTimeNUMX {
    float numX = 0.0;
    if (iphone4) {
        numX = 320 / 375.0;
        return numX;
    }
    if (iphone5) {
        numX = 320 / 375.0;
        return numX;
    }
    if (iphone6) {
        return 1.0;
    }
    if (iphone6plus) {
        numX = 414 / 375.0;
        return numX;
    }
    return numX;
}
- (float)BackTimeNUMY {
    float numY = 0.0;
    if (iphone4) {
        numY = 480 / 667.0;
        
        return numY;
    }
    if (iphone5) {
        numY = 568 / 667.0;
        
        return numY;
    }
    if (iphone6) {
        
        return 1.0;
    }
    if (iphone6plus) {
        numY = 736 / 667.0;
        
        return numY;
    }
    return numY;
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
