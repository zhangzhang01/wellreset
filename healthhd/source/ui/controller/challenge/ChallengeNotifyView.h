//
//  ChallengeNotifyView.h
//  rehab
//
//  Created by 何寻 on 8/24/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeNotifyView : UIView

-(instancetype)initWithFrame:(CGRect)frame isExcellent:(BOOL)flag;

@property(nonatomic) UIImageView* lightImageView;
@property(nonatomic) UILabel *titleLabel, *detailLabel;

@property(nonatomic, copy) void(^click)(NSInteger index);

@end
