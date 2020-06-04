//
//  FeedbackController.m
//  rehab
//
//  Created by Matech on 3/2/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "FeedbackController.h"
#import "WRViewModel.h"
#import "SVProgressHUD.h"
#import "ReactiveCocoa.h"
#import "WToast.h"
#import "WRImagePicker.h"
#import "XHImageViewer.h"
#import "UIFont+YYAdd.h"
#import "UIImage+WR.h"
@interface FeedbackController ()<XHImageViewerDelegate>
{
    NSDate *_startDate;
    NSMutableArray *_imageArray;
    __weak UIImageView *_currentSelectedImageView;
    WRImagePicker *_imagePicker;
}
@property(nonatomic)UITextView* textView;
@property(nonatomic)UITextField* contactInfoTextField;
@property(nonatomic)NSArray *imageIdsArray;
@property (nonatomic, strong) XHImageViewer *imageViewer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString* uuid;

@end

@implementation FeedbackController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForMeWithType:@"complain" duration:duration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    // Do any additional setup after loading the view.    [self createBackBarButtonItem];
//    self.view.backgroundColor = [UIColor blackColor];
    _startDate = [NSDate date];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"意见反馈";
    [WRNetworkService pwiki:@"投诉建议"];
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
    
    if (!self.textView) {
        [self layout];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
-(IBAction)onClickedSubmitButton:(id)sender {
    TextFieldValidatorRule * rule=  [TextFieldValidatorRule  checkIsValidMobileWithFailureString:@"手机号码不正确" forTextField:self.contactInfoTextField];
    if ( !rule.isValid) {
        [AppDelegate show:rule.failureString];
        return;
    }
    [self uploadImage];
}

-(IBAction)onClickedAddImage:(UIImageView*)sender
{
    _currentSelectedImageView = sender;
    if ([[_imageArray objectAtIndex:sender.tag] isEqual:[NSNull null]]) {
        if (!_imagePicker) {
            _imagePicker = [[WRImagePicker alloc] initWithController:self.navigationController targetSize:CGSizeZero imageView:sender];
            __weak __typeof(self) weakSelf = self;
            _imagePicker.completion = ^(UIImage *image) {
                [weakSelf didPickedImage:image];
            };
        }
        [_imagePicker show];
    } else {
        __weak __typeof(self) weakSelf = self;
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"操作", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *repeatAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"查看", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            weakSelf.imageViewer = [[XHImageViewer alloc] init];
            weakSelf.imageViewer.delegate = weakSelf;
            [weakSelf.imageViewer showWithImageViews:@[sender] selectedView:sender];        }];
        UIAlertAction *createNewAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            [_imageArray replaceObjectAtIndex:sender.tag withObject:[NSNull null]];
            _currentSelectedImageView.image = [UIImage imageNamed:@"icon_add"];
;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:repeatAction];
        [controller addAction:createNewAction];
        [controller addAction:cancelAction];
        if (IPAD_DEVICE) {
            controller.popoverPresentationController.sourceView = self.navigationController.view;
            controller.popoverPresentationController.sourceRect = self.navigationController.view.bounds;
        }
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - layout
-(void)layout
{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    scrollView.backgroundColor = [UIColor wr_lightWhite];
    
    self.view.backgroundColor = [UIColor wr_lightWhite];
    UIColor *borderColor = [UIColor wr_lightGray];
    UIColor *textColor = [UIColor grayColor];
    BOOL biPad = [WRUIConfig IsHDApp];
    CGFloat offset;
    if (biPad) {
        offset = 2 * WRUIOffset;
    } else {
        offset = WRUIOffset;
    }
    CGRect bounds = self.view.bounds;
    CGFloat x = offset, y = x;
    CGFloat cx = bounds.size.width - 2*x;
    CGFloat cy;
    
    UILabel *labelTitle = [[UILabel alloc] init];
//    labelTitle.text = NSLocalizedString(@"请留下您的联系方式以便我们能就您的反馈向您及时沟通", nil);
    labelTitle.text = NSLocalizedString(@"联系方式", nil);
    labelTitle.numberOfLines = 0;
    labelTitle.textColor = [UIColor darkGrayColor];
    labelTitle.font = [WRUIConfig IsHDApp] ? [[UIFont wr_titleFont] fontWithBold] : [[UIFont wr_tinyFont] fontWithBold];
    CGSize size = [labelTitle sizeThatFits:CGSizeMake(self.view.width - 20, CGFLOAT_MAX)];
    cy = size.height;
    labelTitle.frame = CGRectMake(x, y, cx, cy);
    [self.scrollView addSubview:labelTitle];
    y = labelTitle.bottom + offset;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    UIView *insetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 44)];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = insetView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightView = insetView;
    textField.placeholder = NSLocalizedString(@"请留下您的联系方式，我们将尽快与您联系", nil);
    textField.layer.borderColor = borderColor.CGColor;
    textField.layer.borderWidth = 1.0f;
    textField.layer.cornerRadius = 4.0f;
    textField.layer.masksToBounds = YES;
    textField.backgroundColor = [UIColor wr_lightGray];
    cy = 44;
    textField.frame = CGRectMake(x, y, cx, cy);
    [self.scrollView addSubview:textField];
    self.contactInfoTextField = textField;
    y = textField.bottom + offset;
    
    UILabel *labelAdvice = [[UILabel alloc] init];
    //    labelTitle.text = NSLocalizedString(@"请留下您的联系方式以便我们能就您的反馈向您及时沟通", nil);
    labelAdvice.text = NSLocalizedString(@"你的建议", nil);
    labelAdvice.numberOfLines = 0;
    labelAdvice.textColor = [UIColor darkGrayColor];
    labelAdvice.font = [WRUIConfig IsHDApp] ? [[UIFont systemFontOfSize:19] fontWithBold] : [[UIFont systemFontOfSize:15] fontWithBold];
    size = [labelAdvice sizeThatFits:CGSizeMake(self.view.width - 20, CGFLOAT_MAX)];
    cy = size.height;
    labelAdvice.frame = CGRectMake(x, y, cx, cy);
    [self.scrollView addSubview:labelAdvice];
    y = labelAdvice.bottom + offset;
    
    UITextView *textView = [[UITextView alloc] init];
    textView.layer.borderColor = borderColor.CGColor;
    textView.layer.borderWidth = 1.0f;
    textView.layer.cornerRadius = 4.0f;
    textView.layer.masksToBounds = YES;
    textView.font = [UIFont wr_textFont];
    textView.backgroundColor = [UIColor wr_lightGray];
    cy = 180;
    textView.frame = CGRectMake(x, y, cx, cy);
    [self.scrollView addSubview:textView];
    self.textView = textView;
    y = textView.bottom + 3;
    
    UILabel *inputCountNotifyLabel = [[UILabel alloc] init];
    inputCountNotifyLabel.textAlignment = NSTextAlignmentRight;
    inputCountNotifyLabel.textColor = textColor;
    inputCountNotifyLabel.font = [WRUIConfig IsHDApp] ? [UIFont wr_tinyFont] : [UIFont wr_smallestFont];
    cy = [WRUIConfig defaultLabelHeight];
    inputCountNotifyLabel.frame = CGRectMake(x, y, cx, cy);
    [self.scrollView addSubview:inputCountNotifyLabel];
    y = inputCountNotifyLabel.bottom + offset;
    
    UILabel* label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.font = [WRUIConfig IsHDApp] ? [UIFont wr_smallTitleFont] : [UIFont wr_lightFont];
    label.text = NSLocalizedString(@"添加照片", nil);
    label.frame = CGRectMake(x, y, cx, cy);
    cy = [WRUIConfig defaultLabelHeight];
    label.frame = CGRectMake(x, y, cx, cy);
    [self.scrollView addSubview:label];
    y = label.bottom + offset;
    
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    [_imageArray removeAllObjects];
    
    UIImage *image = [UIImage imageNamed:@"icon_add"];
    const NSUInteger count = 3;
    const NSUInteger imageSize = [WRUIConfig IsHDApp] ? 120 :60;
    CGFloat yTemp = y;
    __weak __typeof(self) weakSelf = self;
    for(NSUInteger index = 0; index < count; index++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.image = image;
        imageView.frame = CGRectMake(x, y, imageSize, imageSize);
        imageView.tag = index;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView bk_whenTapped:^{
            [weakSelf onClickedAddImage:imageView];
        }];
        [self.scrollView addSubview:imageView];
        x = imageView.right + offset;
        yTemp = imageView.bottom + offset;
        
        [_imageArray addObject:[NSNull null]];
    }
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton addTarget:self action:@selector(onClickedSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.layer.cornerRadius = 5.0f;
    submitButton.clipsToBounds = YES;
    submitButton.backgroundColor = [UIColor wr_rehabBlueColor];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    submitButton.frame = CGRectMake(offset, yTemp, self.view.width - 2 * offset, 44);
    [self.scrollView addSubview:submitButton];
    yTemp = submitButton.bottom + offset;

    UILabel *labelWeChat;
    NSString *wechatId = [WRNetworkService getFormatURLString:urlWechat];
    if (![Utility IsEmptyString:wechatId]) {
        x = textView.left;
        labelWeChat = [[UILabel alloc] init];
        labelWeChat.numberOfLines = 0;
        labelWeChat.textAlignment = NSTextAlignmentCenter;
        labelWeChat.textColor = [UIColor blackColor];
        labelWeChat.userInteractionEnabled = YES;
        labelWeChat.font = [UIFont wr_detailFont];
        
        NSDictionary *dict = @{
                               NSFontAttributeName:labelWeChat.font,
                               NSForegroundColorAttributeName:[UIColor wr_rehabBlueColor]
                               };
        NSString *text = [NSString stringWithFormat:NSLocalizedString(@"可以关注微信号%@(点击复制)来反馈", nil), wechatId];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange range = NSMakeRange(7, wechatId.length);
        [string addAttributes:dict range:range];
        
        labelWeChat.attributedText = string;
        
        CGSize size = [labelWeChat sizeThatFits:CGSizeMake((self.view.width - 2*offset), CGFLOAT_MAX)];
        cx = textView.width;
        cy = size.height;
        y = MAX(yTemp, bounds.size.height - cy - offset);
        labelWeChat.frame = CGRectMake(x, y, cx, cy);
        [self.scrollView addSubview:labelWeChat];
        scrollView.contentSize = CGSizeMake(scrollView.width, labelWeChat.bottom + offset);
        
        [labelWeChat bk_whenTapped:^{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:wechatId];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"复制成功", nil)];
        }];
    }
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"提交", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onClickedSubmitButton:)];
    
    RAC(self.navigationItem.rightBarButtonItem, enabled) = [RACSignal combineLatest:@[self.textView.rac_textSignal]
                                                                             reduce:^(NSString *content) {
                                                                                 return @(content.length >= WRComplainTextMinLength && content.length <= WRComplainTextMaxLength);
                                                                             }];
    
    RAC(inputCountNotifyLabel, text) = [RACSignal combineLatest:@[self.textView.rac_textSignal]
                                         reduce:^(NSString *content) {
                                             if (content.length < WRComplainTextMinLength) {
                                                 return [NSString stringWithFormat:NSLocalizedString(@"", nil), WRComplainTextMinLength];
                                             } else {
                                                 return [NSString stringWithFormat:NSLocalizedString(@"还可以输入%d个字符", nil), WRComplainTextMaxLength - content.length];
                                             }
                                         }];
}

#pragma mark -
-(void)didPickedImage:(UIImage*)image
{
    _currentSelectedImageView.image = image;
    [_imageArray replaceObjectAtIndex:_currentSelectedImageView.tag withObject:image];
}

-(void)uploadImage
{
    
    [WRViewModel getuuidcompletion:^(NSError * _Nonnull error, NSString * _Nonnull uuid) {
        self.uuid = uuid;
    
    
    
    NSUInteger count = 0;
    for(id object in _imageArray)
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
    
    [manager POST:url parameters:parmer constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int index = 0;
        for(id object in _imageArray)
        {
            if (![object isEqual:[NSNull null]]) {
                UIImage *image = object;
                NSData * imageData = UIImageJPEGRepresentation([image fixOrientation:image], 0.6);
                NSString *fileName = [NSString stringWithFormat:@"%@%zi.jpg", @"image", index];
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image%d", index] fileName:fileName mimeType:@"image/jpeg"];
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

-(void)request
{
    
   
    
    if (self.iffriend) {
        if (![Utility IsEmptyString:self.textView.text]) {
            [self.view endEditing:YES];
            //        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"正在提交反馈", nil)];
            [SVProgressHUD show];
            __weak __typeof(self) weakSelf = self;
            NSString *text = self.textView.text;
            if (![Utility IsEmptyString:self.contactInfoTextField.text]) {
                text = [NSString stringWithFormat:@"%@ %@", self.contactInfoTextField.text, text];
            }
            NSString *imageIds = @"";
            if (self.imageIdsArray.count > 0) {
                imageIds = [self.imageIdsArray componentsJoinedByString:@"|"];
            }
            [WRViewModel uptext:text uuid:self.uuid crid:@"1" completion:^(NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                if(error) {
                    [Utility Alert:NSLocalizedString(@"提交失败", nil)];
                } else {
                    weakSelf.textView.text = @"";
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"您的宝贵意见已经收到,感谢您的支持", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"返回", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }]];
                    [weakSelf presentViewController:controller animated:YES completion:nil];
                }
            }];
        }

    }
    else
    {
    
    if (![Utility IsEmptyString:self.textView.text]) {
        [self.view endEditing:YES];
//        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"正在提交反馈", nil)];
        [SVProgressHUD show];
        __weak __typeof(self) weakSelf = self;
        NSString *text = self.textView.text;
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
                weakSelf.textView.text = @"";
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
@end
