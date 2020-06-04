//
//  WRProTreatRehabCell.m
//  rehab
//
//  Created by Matech on 4/11/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRProTreatRehabCell.h"
#import <YYKit/YYKit.h>
@implementation WRProTreatRehabDetailBannerCell
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    //CGSize size = [UIImage imageNamed:@"well_default"].size;
    self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}
@end

@implementation WRProTreatRehabDetailVideosCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_scrollView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    _scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

@end

@interface WRProTreatRehabDetailProgressCell()
{
    UIView *_leftLineView, *_rightSideView, *_rightLineView;
    UIImageView *_iconImageView;
    UIColor *_themeColor;
}
@end
@implementation WRProTreatRehabDetailProgressCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _themeColor = [UIColor colorWithHexString:@"3E3E3E"];
        
        _leftLineView = [UIView new];
        _leftLineView.backgroundColor = _themeColor;
        [self.contentView addSubview:_leftLineView];
        
        _rightSideView = [UIView new];
        [self.contentView addSubview:_rightSideView];
        
        _rightLineView = [UIView new];
        [self.contentView addSubview:_rightLineView];
        
        UIImage *image = [UIImage imageNamed:@"well_time_state_default"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        imageView.tintColor = [UIColor whiteColor];
        [self.contentView addSubview:imageView];
        _iconImageView = imageView;
        
        [self.contentView insertSubview:_rightSideView belowSubview:self.textLabel];
        [self.contentView insertSubview:_leftLineView aboveSubview:_rightSideView];
        [self.contentView insertSubview:_rightLineView aboveSubview:_rightSideView];
        
        self.backgroundColor = [UIColor wr_themeColor];
        
        self.textLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    CGFloat offset = WRUIOffset,  x = 2*offset, y = 0, cy, cx;
    
    cy = _iconImageView.frame.size.height;
    y = (frame.size.height - cy)/2;
    _iconImageView.frame = CGRectMake(x, y, _iconImageView.frame.size.width, _iconImageView.frame.size.height);
    
    x = CGRectGetMaxX(_iconImageView.frame) + x;
    y = 0;
    cy = frame.size.height;
    _leftLineView.frame = CGRectMake(x, y, 2, cy);
    
    cx = frame.size.width - x;
    _rightSideView.frame = CGRectMake(x, y, cx, cy);
    
    cx = 4;
    x = frame.size.width - cx;
    _rightLineView.frame = CGRectMake(x, y, cx, cy);
    
    x = CGRectGetMaxX(_leftLineView.frame) + offset;
    self.textLabel.frame = [Utility moveRect:self.textLabel.frame x:x y:-1];
}

-(void)setState:(ProTreatRehabDetailProgressState)state {
    _state = state;
    NSString *imageName = nil;
    UIColor *rightSideColor = [UIColor whiteColor];
    switch (state) {
        case ProTreatRehabDetailProgressStateUndo: {
            imageName = @"well_time_state_undo";
            rightSideColor = [UIColor orangeColor];
            break;
        }
        case ProTreatRehabDetailProgressStateDefault: {
            imageName = @"well_time_state_default";
            break;
        }
        case ProTreatRehabDetailProgressStateDone: {
            imageName = @"well_time_state_done";
            rightSideColor = [UIColor greenColor];
            break;
        }
        case ProTreatRehabDetailProgressStateLock: {
            imageName = @"well_time_state_lock";
            rightSideColor = [UIColor wr_lightThemeColor];
            break;
        }
    }
    _iconImageView.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    _leftLineView.backgroundColor = [UIColor orangeColor];
    _leftLineView.hidden = (state != ProTreatRehabDetailProgressStateDefault);
    
    _rightLineView.backgroundColor = rightSideColor;
    _rightSideView.backgroundColor = (state == ProTreatRehabDetailProgressStateLock) ? [UIColor wr_themeColor] : [UIColor wr_lightThemeColor];
}

@end
