//
//  RehabStageView.h
//  rehab
//
//  Created by herson on 2016/11/23.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface RehabStageView : UIVisualEffectView

-(instancetype)initWithFrame:(CGRect)frame treatRehabStage:(id)stage stageSets:(NSArray*)stageSets isProTreat:(BOOL)isProTreat isplaying:(BOOL)isplaying;
@property(nonatomic, copy) void(^closeEvent)(RehabStageView* sender);
@property BOOL isPlaying;
@end
