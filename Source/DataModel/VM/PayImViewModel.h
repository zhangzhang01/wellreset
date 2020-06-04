//
//  PayImViewModel.h
//  rehab
//
//  Created by yongen zhou on 2017/6/28.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRViewModel.h"
#import "WRObject.h"
@interface PayImViewModel : WRViewModel
@property(nonatomic) NSString * id1;
@property(nonatomic) NSString * id2;
@property(nonatomic) NSString * money1;
@property(nonatomic) NSString * money2;
@property(nonatomic) NSString * moneyTotal1;
@property(nonatomic) NSString * moneyTotal2;
@property(nonatomic) NSString * des1;
@property(nonatomic) NSString * des2;
@property(nonatomic) NSString * once1;
@property(nonatomic) NSString * once2;
@property(nonatomic) NSDictionary * payinfo;
@property(nonatomic) NSMutableArray * orderlist;
@property(nonatomic) NSString * orderId;
@property(nonatomic) WRImOrder* detail;
@property(nonatomic) BOOL ifcan;
@property(nonatomic) NSString * star;
@property(nonatomic) NSString * end;
@property(nonatomic) NSString * status;
-(void)fetchProductlistcompletion:(ViewModeLoadCompleteBlock)block;
-(void)fetchdoOrderWithOrder:(NSString*)Order  completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchdoPayWithorderId:(NSString*)orderId payType:(NSString*)payType completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchOrderDetailWithorderId:(NSString*)orderId  completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchOrderlistcompletion:(ViewModeLoadCompleteBlock)block;
-(void)fetchAlreadyOrdercompletion:(ViewModeLoadCompleteBlock)block;
@end
