//
//  LaunchView.m
//  rehab
//
//  Created by Matech on 4/27/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "LaunchView.h"
#import "WRNetworkService.h"
#import "JCAlertView.h"
#import "FCAlertView.h"

#define animation_duration 2
@interface LaunchView()

@property(nonatomic)NSMutableArray *imageArray;
@property(nonatomic) UIImageView *imageView;
@property(atomic) BOOL isFetchedApi;
@property(nonatomic) NSInteger currentImageIndex;

@end

@implementation LaunchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _imageArray = [NSMutableArray array];
        UIImage *image;
        const int count = 10;
        for(int index = 1; index <= count; index++) {
            NSString *imageName = [NSString stringWithFormat:@"%d", index];
            image = PNG_IMAGE(imageName);
            [_imageArray addObject:image];
        }
        
        CGRect frame = self.bounds;
        CGFloat cx = image.size.width, cy = image.size.height, x = (frame.size.width - cx)/2, y = (frame.size.height - cy)/2;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

#pragma mark - public
-(void)start
{
    [self splash];
    [self fetchAPI];
}

#pragma mark -
-(void)splash
{
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.currentImageIndex < weakSelf.imageArray.count)
        {
            weakSelf.imageView.image = weakSelf.imageArray[weakSelf.currentImageIndex++];
            [weakSelf splash];
        }
        else
        {
            if(weakSelf.isFetchedApi) {
                [weakSelf finished];
            }
        }
    });
}

-(void)fetchAPI {
    __weak __typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        [[WRNetworkService defaultService] fetchInterfaceWithCompletion:^(NSError *error) {
            do {
                if (error)
                {
                    if (error.code == WRNetworkErrorNeedUpdate)
                    {
                        NSString *updateUrl = error.userInfo[@"download"];
                        if (![Utility IsEmptyString:updateUrl])
                        {
                            NSLog(@"need update %@", updateUrl);
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [weakSelf alertForUpgrade:updateUrl];
                            }];
                            return;
                        }
                    }
                }
                
            } while (NO);
            
            weakSelf.isFetchedApi = YES;
            if (weakSelf.completion) {
                weakSelf.completion();
            }
            if (weakSelf.currentImageIndex == weakSelf.imageArray.count) {
                [weakSelf finished];
            }
        }];
    });
}

-(void)alertForUpgrade:(NSString*)urlString
{
//    [JCAlertView showOneButtonWithTitle:NSLocalizedString(@"提示", nil) Message:NSLocalizedString(@"版本太旧，需要升级至最新版本才能继续使用", nil) ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:NSLocalizedString(@"立即升级", nil) Click:^{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//    }];
    
    FCAlertView *alert = [[FCAlertView alloc] init];
    [alert showAlertInView:nil withTitle:NSLocalizedString(@"提示", nil) withSubtitle:NSLocalizedString(@"版本太旧，需要升级至最新版本才能继续使用", nil) withCustomImage:nil withDoneButtonTitle:nil andButtons:nil];
    [alert addButton:NSLocalizedString(@"立即升级", nil) withActionBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }];
    alert.hideDoneButton = YES;
    alert.colorScheme = [UIColor wr_themeColor];
    
}

-(void)finished
{
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:1 animations:^{
        weakSelf.alpha = 0;
        weakSelf.transform = CGAffineTransformScale(weakSelf.transform, 2, 2);
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
