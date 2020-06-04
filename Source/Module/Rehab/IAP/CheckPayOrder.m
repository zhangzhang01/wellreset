//
//  CheckPayOrder.m
//  rehab
//
//  Created by yefangyang on 2017/1/9.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "CheckPayOrder.h"
#import "IAPViewModel.h"

@implementation CheckPayOrder
+ (void)checkPayOrder{
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:PayOrderInfoKey];
    if (array) {
        NSMutableArray *payOrderArray = [[NSMutableArray alloc] initWithArray:array];
        
        if ([[WRUserInfo selfInfo] isLogged]) {
            for (NSDictionary *payInfo in payOrderArray) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                id obj = [payInfo objectForKey:@"transid"];
                if(obj != nil) {
                    [dic setObject:obj forKey:@"transid"];
                } else {
                    [dic setObject:@"" forKey:@"transid"];
                }
                obj = [payInfo objectForKey:@"receipt"];
                if(obj != nil) {
                    [dic setObject:obj forKey:@"receipt"];
                } else {
                    [dic setObject:@"" forKey:@"receipt"];
                    
                }
                obj = [payInfo objectForKey:@"productId"];
                if(obj != nil) {
                    [dic setObject:obj forKey:@"productId"];
                } else {
                    [dic setObject:@"" forKey:@"productId"];
                }
                
                [IAPViewModel testIAPWithsn:dic[@"transid"] productId:dic[@"receipt"] receipt:dic[@"productId"] completion:^(NSError *error, id resultObject) {
                    if (error) {
                        
                    } else {
                        [CheckPayOrder removePayOrder:payInfo];
                    }
                }];
            }
        }
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc] init] forKey:PayOrderInfoKey];
    }
}

+ (void)addPayOrder:(NSDictionary *)order{
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:PayOrderInfoKey];
    if (array) {
        NSMutableArray *payOrderArray = [[NSMutableArray alloc] initWithArray:array];
        [payOrderArray addObject:order];
        [[NSUserDefaults standardUserDefaults] setObject:payOrderArray forKey:PayOrderInfoKey];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc] init] forKey:PayOrderInfoKey];
    }
}
+ (void)removePayOrder:(NSDictionary *)order{
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:PayOrderInfoKey];
    if (array) {
        NSMutableArray *payOrderArray = [[NSMutableArray alloc] initWithArray:array];
        [payOrderArray removeObject:order];
        [[NSUserDefaults standardUserDefaults] setObject:payOrderArray forKey:PayOrderInfoKey];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc] init] forKey:PayOrderInfoKey];
    }
}


@end
