//
//  WRCircleNews.h
//  rehab
//
//  Created by yongen zhou on 2017/11/2.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRCircleNews : NSObject
@property NSString* uuid ,* title ,* titleColor ,* titleImageUrl,* contentImageUrl,* btnText , * btnTextColor ,* btnBackground ,* url;
@property BOOL status;
@property NSString* content;
@property NSString* contentColor;

@end
