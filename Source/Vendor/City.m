//
//  City.m
//  Gofind
//
//  Created by yongen zhou on 2016/11/17.
//  Copyright © 2016年 shizaihaoshizaihao. All rights reserved.
//

#import "City.h"

@implementation City
+ (instancetype)CityWithDict:(NSDictionary *)dict
{
    City *p = [[self alloc] init];
    
//    [p mj_setKeyValues:dict];
    
    return p;
}
+ (NSDictionary *)objectClassInArray{
    return @{
             @"area":@"Area"
             };
}
@end
