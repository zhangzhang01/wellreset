//
//  WRImagePicker.m
//  rehab
//
//  Created by herson on 2016/10/8.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRImagePicker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <YYKit/YYKit.h>
@interface WRImagePicker ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    __weak UIViewController *_sourceController;
    CGSize _targetSize;
    UIImageView *_imageView;
}
@end

@implementation WRImagePicker

-(instancetype)initWithController:(UIViewController *)sourceController targetSize:(CGSize)targetSize imageView:(UIImageView *)imageView
{
    if (self = [super init]) {
        _sourceController = sourceController;
        _imageView = imageView;
        _targetSize = targetSize;
    }
    return self;
}

#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    CGSize destImageSize = _targetSize;
    UIImage *smallImage = image;
    if (!CGSizeEqualToSize(destImageSize, CGSizeZero)) {
        smallImage = [image imageByResizeToSize:destImageSize];
    }
    NSLog(@"pick photo size %@ %@", NSStringFromCGSize(image.size), NSStringFromCGSize(smallImage.size));
    if (self.completion) {
        self.completion(smallImage);
    }
}

#pragma mark -
-(void)didSelectedImageType:(NSUInteger)type
{
    UIViewController *controller = _sourceController;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    switch (type) {
        case 0://照相机
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        }
            
        case 2://摄像机
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
            break;
        }
            
        case 1://本地相簿
        case 3://本地视频
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {        //判断当前设备的系统是否是ios7.0以上
                    imagePicker.edgesForExtendedLayout = UIRectEdgeNone;
            }
           
            break;
        }
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [controller presentViewController:imagePicker animated:YES completion:nil];
    }];
}

#pragma mark - public 
-(void)show
{
    __weak __typeof(self) weakSelf = self;
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请选择图片来源", nil)
                                                                        message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"照相机", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [weakSelf didSelectedImageType:0];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"本地相册", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [weakSelf didSelectedImageType:1];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:action1];
    [controller addAction:action2];
    [controller addAction:cancelAction];
    if (IPAD_DEVICE) {
//        controller.popoverPresentationController.sourceView = _sourceController.view;
//        controller.popoverPresentationController.sourceRect = _sourceController.view.bounds;
        
        controller.popoverPresentationController.sourceView = _imageView;
        controller.popoverPresentationController.sourceRect = _imageView.bounds;
    }
    [_sourceController presentViewController:controller animated:YES completion:nil];
}
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
        if ([navigationController isKindOfClass:[UIImagePickerController class]])
            {
                    viewController.navigationController.navigationBar.translucent = NO;
                    viewController.edgesForExtendedLayout = UIRectEdgeNone;
                }
}


@end
