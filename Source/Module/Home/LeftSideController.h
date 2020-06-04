//
//  LeftSideController.h
//  rehab
//
//  Created by herson on 2016/11/21.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface LeftSideController : WRViewController

@property(nonatomic)void(^clickedEvent)(UIView *sender);

-(instancetype)initWithSideWidth:(CGFloat)width;

@end
