//
//  FormatterUtils.m
//  rehab
//
//  Created by herson on 8/31/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "FormatterUtils.h"

@implementation FormatterUtils

+(NSString *)stringForCount:(NSInteger )num
{
    if (num >= 100000) {
        return [NSString stringWithFormat:@"%d%@", (int)num/10000, NSLocalizedString(@"万", nil)];
    }
    else{
        return [@(num) stringValue];
    }
}

@end
