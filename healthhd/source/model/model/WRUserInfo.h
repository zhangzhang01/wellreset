//
//  WRUserInfo.h
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "WRObject.h"

@interface WRUserInfo : NSObject

@property(nonatomic, assign) NSUInteger age, height, sex, weight, notificationFlag;
@property(nonatomic, copy) NSString *userId, *token, *name, *headImageUrl, *phone, *email, *diseaseHistory, *province, *city, *birthDay;
@property(nonatomic, copy) NSString *weixinId, *QQId, *weiboId;

+(instancetype)selfInfo;
-(void)fromDict:(NSDictionary*)dict;
-(BOOL)isLogged;
-(void)save;
-(void)restore;
-(void)clear;

@end