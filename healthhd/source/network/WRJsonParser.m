//
//  WRJsonParser.m
//  rehab
//
//  Created by Matech on 3/3/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRJsonParser.h"

@implementation WRJsonParser

+(instancetype)ParserFromString:(NSString *)value
{
    return [[WRJsonParser alloc] initWithString:value];
}

+(instancetype)ParserFromDictionary:(NSDictionary *)dict {
    return [[WRJsonParser alloc] initWithDictionary:dict];
}


- (instancetype)initWithDictionary:(NSDictionary*)dict {
    if(self = [super init])
    {
        _isSuccess = NO;
        _errorCode = -1;
        _errorString = NSLocalizedString(@"未知错误", nil);
        
        NSDictionary *dictionary = dict;
        if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
        {
            NSInteger status = [(NSString*)[dictionary objectForKey:@"code"] integerValue];
            _resultObject = [[dictionary objectForKey:@"result"] copy];
            _errorCode = status;
            if(status == 0)
            {
                _extraObject = [[dictionary objectForKey:@"extra"] copy];
                _isSuccess = YES;
            }
            else
            {
                _errorString = [[dictionary objectForKey:@"msg"] copy];
            }
        }
        if(!_isSuccess)
        {
            NSLog(@"JsonParser error code : %d description: %@", (int)self.errorCode, self.errorString);
        }
    }
    return self;
}

- (instancetype)initWithString:(NSString*)value
{
    NSData* jsonData = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSError * err = nil;
    id jsonResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&err];
    
    NSDictionary *dictionary = jsonResult;
    return [self initWithDictionary:dictionary];
}


@end
