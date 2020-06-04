//
//  ReceiveQuestionnaireView.h
//  rehab
//  问卷调查
//  Created by yefangyang on 2016/10/28.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiveQuestionnaireView : UIView

@property (nonatomic, copy) void (^clickedChooseBlock)(NSInteger);

-(void)showWithAnimationInSuperView:(UIView*)superView;
-(void)dismiss;

@end
