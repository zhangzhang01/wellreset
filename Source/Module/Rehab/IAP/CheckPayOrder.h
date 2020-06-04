//
//  CheckPayOrder.h
//  rehab
//
//  Created by yefangyang on 2017/1/9.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckPayOrder : NSObject
+ (void)checkPayOrder;

+ (void)addPayOrder:(NSDictionary *)order;
+ (void)removePayOrder:(NSDictionary *)order;
@end
