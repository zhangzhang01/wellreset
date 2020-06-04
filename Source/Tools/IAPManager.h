//
//  IAPManager.h
//  rehab
//
//  Created by yefangyang on 2016/12/28.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPManager : NSObject
+ (instancetype)sharedInstance;
- (void)payBtnPressed:(NSString *)product_id;
-(void)test;
@end
