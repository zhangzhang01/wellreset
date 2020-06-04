//
//  WRSelfInfoPanelView.h
//  rehab
//
//  Created by Matech on 3/9/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRSelfInfoPanelView : UIView

-(instancetype)initWithFrame:(CGRect)frame isSimple:(BOOL)isSimply;

@property(nonatomic) UIImageView *headImageView;
@property(nonatomic) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *experiseLabel;
@property (nonatomic, strong) UILabel *levellabal;
@property(nonatomic) UIButton *logOffButton;
@property (nonatomic, strong) UIProgressView *progressView;


+(CGFloat)defaultHeight;
-(void)update;

@end
