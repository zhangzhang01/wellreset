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
    if (!obj) {
        obj = dict[@"userId"];
    }
    if (!obj) {
        obj = @"";
    }
    self.userId = obj;
    
    obj = dict[@"weibo"];
    if (!obj) {
        obj = @"";
    }
    self.weiboId = obj;
    
    obj = dict[@"wechat"];
    if (!obj) {
        obj = @"";
    }
    self.weixinId = obj;
    
    obj = dict[@"qq"];
    if (!obj) {
        obj = @"";
    }
    self.QQId = obj;
    
    
    
    
    obj = dict[@"level"];
    if (!obj) {
        obj = dict[@"level"];
    }
    if (!obj) {
        obj = @"0";
    }
    self.level = [obj integerValue];
    
    obj = dict[@"birthday"];
    if (!obj) {
        obj = dict[@"birthDay"];
    }
    if (!obj) {
        obj = @"";
    }
    
    if ([Utility IsEmptyString:[NSString stringWithFormat:@"%@",self.birthDay]]) {
        self.birthDay = obj;
    }
    
  
    
    NSLog(@"init selfInfo");
}

-(void)reset {
    self.userId = @"";
    self.name = @"";
    self.phone = @"";
    self.email = @"";
    self.level =0;
    self.integral =0;
    self.nextLevel =0;
}

-(BOOL)isLogged {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
    NSLog(@"----%@",username);
    return  ![Utility IsEmptyString:self.userId];
    
    
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
    NSArray* rehab = [ud objectForKey:@"rehab"];
    [ud removeObjectForKey:@"noti"];
    if (rehab) {
        [ud removeObjectForKey:@"rahab"];
    }
    if (dict) {
        [ud removeObjectForKey:@"self"];
    }
    [self reset];
    [[ShareUserData userData] clear];
    
}

@end
