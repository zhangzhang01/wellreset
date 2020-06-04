//
//  PayImViewModel.m
//  rehab
//
//  Created by yongen zhou on 2017/6/28.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "PayImViewModel.h"
#import "WRObject.h"
@implementation PayImViewModel
-(void)fetchProductlistcompletion:(ViewModeLoadCompleteBlock)block;
{
    NSString *formatString = [WRNetworkService getFormatURLString:getProductList];
//    NSString *strUrl = [NSString stringWithFormat:@"%@", formatString];
    [WRBaseRequest request:formatString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        do {
            if(error)
            {
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            NSMutableArray* resultarry = parser.resultObject;
            NSDictionary* extra = parser.extraObject;
            self.once2 = extra[@"count"];
            self.once1 = extra[@"oncecount"];
            int i =0;
            for (NSDictionary*dic in resultarry) {
                if (i==0) {
                    self.id1 =  dic[@"id"];
                    self.money1 = dic[@"money"];
                    self.moneyTotal1 = dic[@"totalMoney"];
                    self.des1= dic[@"description"];
                    
                }
                else
                {
                    self.id2 =  dic[@"id"];
                    self.money2 = dic[@"money"];
                    self.moneyTotal2 = dic[@"totalMoney"];
                    self.des2= dic[@"description"];
                }
                i++;
            }
            
            
        
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];

}
-(void)fetchdoOrderWithOrder:(NSString*)Order  completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatString = [WRNetworkService getFormatURLString:doOrder];
    NSString *strUrl = [NSString stringWithFormat:formatString,Order];
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        do {
            if(error)
            {
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            self.orderId = parser.resultObject[@"id"];
            
           
            
            
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];

}
-(void)fetchdoPayWithorderId:(NSString*)orderId payType:(NSString*)payType completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatString = [WRNetworkService getFormatURLString:doPay];
    NSString *strUrl = [NSString stringWithFormat:formatString,orderId,payType];
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        do {
            if(error)
            {
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            self.payinfo = parser.resultObject;
            
            
            
            
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];
}

-(void)fetchOrderDetailWithorderId:(NSString*)orderId  completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatString = [WRNetworkService getFormatURLString:getOrderDetail];
    NSString *strUrl = [NSString stringWithFormat:formatString,orderId];
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        do {
            if(error)
            {
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            WRImOrder* detail = [[WRImOrder alloc]initWithDictionary:parser.resultObject];
            
            self.detail = detail;
            
            
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];
}
-(void)fetchOrderlistcompletion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatString = [WRNetworkService getFormatURLString:getOrderList];
//    NSString *strUrl = [NSString stringWithFormat:formatString,orderId];
    [WRBaseRequest request:formatString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        do {
            if(error)
            {
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            self.orderlist = [NSMutableArray array];
            for (NSDictionary*dic in parser.resultObject) {
                WRImOrder* detail = [[WRImOrder alloc]initWithDictionary:dic];
                [self.orderlist addObject:detail];
            }
            
            
//            self.detail = detail;
            
            
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];
}

-(void)fetchAlreadyOrdercompletion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatString = [WRNetworkService getFormatURLString:getAlreadyOrderProducts];
    //    NSString *strUrl = [NSString stringWithFormat:formatString,orderId];
    [WRBaseRequest request:formatString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        do {
            if(error)
            {
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            self.orderlist = [NSMutableArray array];
            for (NSDictionary*dic in parser.resultObject) {
                
                [self.orderlist addObject:dic];
            }
            
            self.status = [NSString stringWithFormat:@"%@",parser.extraObject[@"flag"]];
            //            self.detail = detail;
            
            
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];

}

@end

