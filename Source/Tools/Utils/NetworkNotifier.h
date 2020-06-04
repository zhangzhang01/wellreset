//
//  NetworkNotifier.h
//  rehab
//
//  Created by yefangyang on 2016/12/7.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkNotifier : NSObject

@property (nonatomic, copy) void (^continueBlock)(NSInteger index);

- (instancetype)initWithController:(UIViewController *)controller;
@end
