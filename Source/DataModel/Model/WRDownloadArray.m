//
//  WRDownloadArray.m
//  rehab
//
//  Created by yongen zhou on 2017/6/8.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRDownloadArray.h"

@implementation WRDownloadArray
+ (nonnull instancetype)sharedDownloadArray {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [NSMutableArray array];
    });
    return instance;
}
@end
