//
//  WRTestResultViewController.h
//  rehab
//
//  Created by yongen zhou on 2017/3/10.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface WRTestResultViewController : WRViewController
@property(nonatomic) NSMutableArray <WRTestInfo *>* lastarry;
@property(nonatomic) WRTestInfo *UserHealthStage;
@property(nonatomic) WRRehab* rehab;
@property(nonatomic) BOOL isCompit;
@end
