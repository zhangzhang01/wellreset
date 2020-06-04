//
//  NSDate+WELL.m
//  rehab
//
//  Created by 何寻 on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "NSDate+WELL.h"

@implementation NSDate(WELL)

+(instancetype)dateWithString:(NSString*)dateString
{
    if (dateString == nil) {
        return nil;
    }
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSLocale *locale = [NSLocale currentLocale];
    return  [NSDate dateWithString:dateString format:@"yyyy-MM-dd HH:mm:ss" timeZone:zone locale:locale];
}

@end
