//
//  RehabPlayerPauseView.h
//  rehab
//
//  Created by 何寻 on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,RehabPlayerPauseViewType) {
    RehabPlayerPauseViewTypeRehab,
    RehabPlayerPauseViewTypeChallenge
};

@interface RehabPlayerPauseView : UIVisualEffectView

-(instancetype)initWithFrame:(CGRect)frame type:(RehabPlayerPauseViewType)type;

@property(nonatomic)RehabPlayerPauseViewType type;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UIImageView *imageView;
@property(nonatomic)UIButton *controlButton;

-(void)show;

@end
