//
//  ChooseMusicView.h
//  rehab
//
//  Created by yefangyang on 2016/10/25.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseMusicView : UIVisualEffectView

@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIImageView *closeImageView;
@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, strong) UILabel *switchLabel;
@property (nonatomic, strong) UIView *musicListView;

@property (nonatomic, copy) void (^clickedMusicBlock)(UIButton *button, NSString *fileName);
@property (nonatomic, assign) BOOL isOn;

-(instancetype)initWithFrame:(CGRect)frame;
-(void)show;

@end
