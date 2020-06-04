//
//  WRLocationHelper.m
//  rehab
//
//  Created by 何寻 on 3/27/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRLocationHelper.h"
#import <CoreLocation/CoreLocation.h>

@interface WRLocationHelper ()<CLLocationManagerDelegate>
{
    
}
@property(nonatomic)CLLocationManager *locationManager;

@end

@implementation WRLocationHelper

+(instancetype)defaultSerivce {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WRLocationHelper alloc] init];
    });
    return instance;
}

- (void)locate {
    self.currentState = @"";
    self.currentCity = @"";

    // 判断是否开启定位
    if (!self.locationManager) {
        if ([CLLocationManager locationServicesEnabled]) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            [self.locationManager requestWhenInUseAuthorization];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"home_cannot_locate", comment:@"无法进行定位") message:NSLocalizedString(@"home_cannot_locate_message", comment:@"请检查您的设备是否开启定位功能") delegate:self cancelButtonTitle:NSLocalizedString(@"common_confirm",comment:@"确定") otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CoreLocation Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject]; // 最后一个值为最新位置
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    // 根据经纬度反向得出位置城市信息
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Location error: %@", error);
        } else {
            if (placemarks.count == 0){
                NSLog(@"No location and error returned");
            } else {
                CLPlacemark *placeMark = placemarks[0];
                self.currentState = placeMark.administrativeArea;
                self.currentCity = placeMark.locality;
                //获取城市
                if (!self.currentCity) {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    self.currentCity = placeMark.administrativeArea;
                }
                
                NSLog(@"location %@ %@", self.currentState, self.currentCity);
                
                // ? placeMark.locality : placeMark.administrativeArea;
                if (!self.currentCity) {
                    //self.currentCity = NSLocalizedString(@"home_cannot_locate_city", comment:@"无法定位当前城市");
                }
            }
        }
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.completion) {
                weakSelf.completion(error);
            };
        });
    }];
    
    [manager stopUpdatingLocation];
}

@end
