//
//  Province.m
//  Gofind
//
//  Created by shizaihao on 2016/11/17.
//  Copyright © 2016年 shizaihaoshizaihao. All rights reserved.
//

#import "Province.h"

@implementation Province
+ (instancetype)provinceWithDict:(NSDictionary *)dict
{
    Province *p = [[self alloc] init];
//    [p mj_setKeyValues:dict];
    return p;
}

+ (NSDictionary *)objectClassInArray{
    return @{
             @"city":@"City"
             };
}

@end
