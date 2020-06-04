//
//  WRTestBaseViewController.h
//  rehab
//
//  Created by yongen zhou on 2017/3/10.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"
#import "ProTreatViewModel.h"
@interface WRTestBaseViewController : WRViewController
@property(nonatomic) NSUInteger stage;
@property ProTreatViewModel* viewmodel;
@property(nonatomic) WRRehabDisease *proTreatDisease;
@property BOOL isnew;
@end
