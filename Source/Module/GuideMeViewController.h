//
//  GuideMeViewController.h
//  rehab
//
//  Created by yongen zhou on 2017/3/6.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"
#import "RehabObject.h"
#import "PreventVideosController.h"
#import "WRScene.h"

@interface GuideMeViewController : WRViewController
@property NSInteger type;
@property WRRehabDisease* re;
@property BOOL ispro;
@property NSInteger index;
@property WRScene *scene;
@end
