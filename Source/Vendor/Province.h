//
//  Province.h
//  Gofind
//
//  Created by shizaihao on 2016/11/17.
//  Copyright © 2016年 shizaihaoshizaihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject
@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) NSArray *city;
@property (nonatomic, strong) NSString *name;
+ (instancetype)provinceWithDict:(NSDictionary *)dict;

@end
