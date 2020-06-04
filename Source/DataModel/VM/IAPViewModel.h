//
//  IAPViewModel.h
//  rehab
//
//  Created by yefangyang on 2017/1/4.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRViewModel.h"

@interface IAPViewModel : WRViewModel
+(void)testIAPWithsn:(NSString *)sn productId:(NSString *)productId receipt:(NSString *)receipt completion:(void(^)(NSError* error, id resultObject))completion;
+ (void)SureIAPWithurl:(NSString *)url orderId:(NSString *)orderId receipt:(NSString *)receipt completion:(void (^)(NSError *, id))completion;
@end
