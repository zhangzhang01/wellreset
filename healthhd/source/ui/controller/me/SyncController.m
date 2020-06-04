//
//  SyncController.m
//  rehab
//
//  Created by Matech on 3/2/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "SyncController.h"

#if !IPAD
#import <HealthKit/HealthKit.h>
#endif

#import "WRApp.h"
#import "WToast.h"

@interface SyncController ()
{
    NSDate *_startDate;
}
@property NSUInteger syncCount;

@end

@implementation SyncController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForMeWithType:@"sync" duration:duration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    
    _startDate = [NSDate date];
    [self defaultStyle];
    
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    UIColor *endColor = [Utility ColorFromHexCode:@"209ee7"], *startColor = [Utility ColorFromHexCode:@"42d9e8"];
    layer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1.0, 1.0);
    layer.frame = self.view.bounds;
    
    UIImage *image = [UIImage imageNamed:@"well_health_icon"];
    CGRect frame = self.view.bounds;
    CGFloat offset = WRUIOffset,  x = offset, y = x, cx = frame.size.width - 2*x, cy = image.size.height + 2*offset;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
    label.text = NSLocalizedString(@"HKDesc", nil);
    label.font = [UIFont wr_textFont];
    label.textColor = [UIColor lightGrayColor];
    label.numberOfLines = 0;
    [label sizeToFit];
    [self.view addSubview:label];
    y = CGRectGetMaxY(label.frame) + offset;
    
    UIControl *control = [[UIButton alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
    [control.layer addSublayer:layer];
    
    [control addTarget:self action:@selector(onClickedSync:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [control wr_roundBorderWithColor:[UIColor whiteColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(offset, offset, imageView.frame.size.width, imageView.frame.size.height);
    [imageView wr_roundBorderWithColor:[UIColor whiteColor]];
    [control addSubview:imageView];
    x = CGRectGetMaxX(imageView.frame) + offset;
    
    cx = control.frame.size.width - x - offset;
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, cx, control.frame.size.height)];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"同步iPhone健康数据", nil);
    [control addSubview:label];
    
    [WRNetworkService pwiki:@"同步数据"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickedSync:(id)sender {
#if IPAD
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"设备不支持", nil)];
#else
    if (![HKHealthStore isHealthDataAvailable]) {
        [Utility alertWithViewController:self title:NSLocalizedString(@"您的设备不支持同步健康数据", nil)];
        return;
    }
    
    NSUInteger days = 0;
    NSDate *lastSyncDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"syncDate"];
    if (lastSyncDate == nil) {
        days = 10;
    } else {
        NSDate *nowDate = [NSDate date];
        if (nowDate.year == lastSyncDate.year && nowDate.month == lastSyncDate.month && nowDate.day == lastSyncDate.day) {
            [WToast showWithText:NSLocalizedString(@"您每天只需同步一次健康数据", nil)];
        } else {
            days = 1;
        }
    }
    
    if (days > 0) {
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        
        NSArray *typeArray = @[HKQuantityTypeIdentifierStepCount, HKQuantityTypeIdentifierDistanceWalkingRunning];
        NSMutableSet *readObjectTypes = [NSMutableSet set];
        for (NSString *name in typeArray) {
            [readObjectTypes addObject:[HKObjectType quantityTypeForIdentifier:name]];
        }
        
        __weak __typeof(self) weakSelf = self;
        [healthStore requestAuthorizationToShareTypes:nil readTypes:readObjectTypes completion:^(BOOL success, NSError *error) {
            if (success == YES)  {
                weakSelf.syncCount = readObjectTypes.count;
                //授权成功
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在读取您的健康数据", nil)];
                });
                
                NSDate *now = [NSDate date];
                NSDate *beginDate = [now dateByAddingDays:-days];
                
                NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:beginDate endDate:now options:HKQueryOptionStrictStartDate];
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
                
                NSMutableArray *submitData = [NSMutableArray array];
                for (NSString *name in typeArray) {
                    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:name];
                    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                        if(!error && results) {
                            
                            NSUInteger count = 0;
                            double meters = 0;
                            NSUInteger sampleIndex = 0;
                            
                            NSString *typeString = @"step";
                            NSUInteger type = 0;
                            if ([query.sampleType.identifier isEqualToString:HKQuantityTypeIdentifierDistanceWalkingRunning]) {
                                type = 1;
                                typeString = @"walk";
                            }
                            for (NSInteger index = 0; index < days; index++) {
                                NSDate *curDate = [beginDate dateByAddingDays:index];
                                for (;sampleIndex < results.count; sampleIndex++) {
                                    HKQuantitySample *samples = results[sampleIndex];
                                    if (samples.startDate.day == curDate.day) {
                                        if (type == 0) {
                                            int v = (int)[samples.quantity doubleValueForUnit:[HKUnit countUnit]];
                                            count += v;
                                        } else if(type == 1) {
                                            meters += [samples.quantity doubleValueForUnit:[HKUnit meterUnit]];
                                        }
                                    }
                                    else {
                                        WRSyncData *object = [[WRSyncData alloc] init];
                                        object.type = typeString;
                                        object.userId = [WRUserInfo selfInfo].userId;
                                        object.time = [curDate stringWithFormat:@"yyyy-MM-dd"];
                                        object.deviceType = DeviceTypeiPhone;
                                        if (type == 0) {
                                            NSLog(@"%@ step count %d", curDate.description, (int)count);
                                            object.value = [@(count) stringValue];
                                            count = 0;
                                        } else if(type == 1) {
                                            NSLog(@"%@ meters count %.2f", curDate.description, meters);
                                            meters = 0;
                                            object.value = [@(meters) stringValue];
                                        }
                                        [submitData addObject:[object convertDictionary]];
                                        break;
                                    }
                                }
                            }
                            
                            if (submitData.count > 0) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [weakSelf postData:submitData];
                                });
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD dismiss];
                                    [Utility showToast:NSLocalizedString(@"无可用数据上传", nil) position:ToastPositionBottom];
                                });
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD dismiss];
                            });
                        }
                    }];
                    [healthStore executeQuery:sampleQuery];
                }
            } else {
                NSLog(@"%@", error.localizedDescription);
                //授权失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility alertWithViewController:self title:NSLocalizedString(@"同步数据授权失败", nil)];
                });
            }
        }];
    }
#endif
}

-(void)postData:(NSArray*)data {
    NSString *json = [data jsonStringEncoded];
    if (json) {
        NSDictionary *params = @{@"data":json};
        NSString *url = [WRNetworkService getFormatURLString:urlUserSyncData];
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在上传数据到服务器", nil)];
        __weak __typeof(self) weakSelf = self;
        [WRBaseRequest post:url params:params result:^(id responseObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                [Utility retryAlertWithViewController:weakSelf title:NSLocalizedString(@"上传失败,请检查网络状况后重试", nil) completion:^{
                    [weakSelf postData:data];
                }];
            } else {
                weakSelf.syncCount--;
                if (weakSelf.syncCount == 0) {
                    //[Utility Alert:NSLocalizedString(@"同步数据成功", nil)];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"syncDate"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}

@end
