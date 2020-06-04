//
//  AdvertiseView.h
//  rehab
//
//  Created by yefangyang on 2016/12/9.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertiseView : UIView

@property (nonatomic, copy) NSString *imageUrl;
- (instancetype) initWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl;
-(void)startplayAdvertisingView:(void (^)(AdvertiseView *))advertisingview;

@end
