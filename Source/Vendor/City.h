//
//  City.h
//  Gofind
//
//  Created by yongen zhou on 2016/11/17.
//  Copyright © 2016年 shizaihaoshizaihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject
@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) NSArray *area;
@property (nonatomic, strong) NSString *name;
+ (instancetype)CityWithDict:(NSDictionary *)dict;
@end
