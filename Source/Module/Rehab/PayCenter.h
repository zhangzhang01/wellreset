//
//  PayCenter.h
//  rehab
//
//  Created by Matech on 2017/1/6.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayCenter : NSObject

+ (instancetype)defaultCenter;

@property NSString * orderId;


-(void)payForProductWithIdentify:(NSString*)identify;

-(void)test;

- (void)retrycomplete;
@property(nonatomic, copy)void(^completionBlock)();
@end
