//
//  WRUserInfo.m
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "WRUserInfo.h"
#import "ShareUserData.h"

@implementation WRUserInfo

+(instancetype)selfInfo {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)fromDict:(NSDictionary *)dict {
    [self fromDictionary:dict];
    id obj = dict[@"uuid"];
    if (obj) {
        self.userId = obj;
    }
    obj = dict[@"weibo"];
    if (obj) {
        self.weiboId = obj;
    }
    obj = dict[@"wechat"];
    if (obj) {
        self.weixinId = obj;
    }
    obj = dict[@"qq"];
    if (obj) {
        self.QQId = obj;
    }
    
    obj = dict[@"birthday"];
    if (obj) {
        if ([Utility IsEmptyString:self.birthDay]) {
            self.birthDay = obj;
        }
    }
    if (obj) {
        self.QQId = obj;
    }
    NSLog(@"init selfInfo");
}

-(void)reset {
    self.userId = @"";
    self.name = @"";
    self.phone = @"";
    self.email = @"";
}

-(BOOL)isLogged {
    return ![Utility IsEmptyString:self.userId];
}

-(void)save {
    NSDictionary *dict = [self convertDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"self"];
    NSLog(@"save selfInfo");
}

-(void)restore {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [ud objectForKey:@"self"];
    if (dict) {
        [self fromDict:dict];
        NSLog(@"restore self info");
    }
}

-(void)clear {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [ud objectForKey:@"self"];
    if (dict) {
        [ud removeObjectForKey:@"self"];
    }
    [self reset];
    [[ShareUserData userData] clear];
}

@end
