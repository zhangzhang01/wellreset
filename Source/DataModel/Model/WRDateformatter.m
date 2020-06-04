//
//  WRDateformatter.m
//  rehab
//
//  Created by yongen zhou on 2017/3/18.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRDateformatter.h"

@implementation WRDateformatter
+(instancetype)formatter {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setDateStyle:NSDateFormatterMediumStyle];
        [sharedInstance setTimeStyle:NSDateFormatterShortStyle];
        [sharedInstance setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    });
    return sharedInstance;
}
@end
