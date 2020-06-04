//
//  ChallengeVideoCell.m
//  rehab
//
//  Created by herson on 9/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ChallengeVideoCell.h"
#import <YYKit/YYKit.h>
@interface ChallengeVideoCell()
{
    UIView *_bgView, *_lineView;
    UILabel *_titleLabel;
}
@end

@implementation ChallengeVideoCell

+(CGFloat)defaultHeightForTableView:(UITableView *)tableView {
    UIImage* image = [UIImage imageNamed:@"well_default_4_3"];
    CGFloat height = 0;
    BOOL biPad = [WRUIConfig IsHDApp];
    if (biPad) {
        height = image.size.height * 0.8 + 3 * WRUIOffset;
    } else {
        height = image.size.height*0.4 + 4*WRUIOffset;
    }
    return height;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    BOOL biPad = [WRUIConfig IsHDApp];
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor wr_lightWhite];
        _bgView = [UIView new];//self.contentView;
        _bgView.backgroundColor = [UIColor whiteColor];
        //[_bgView wr_setShadow];
        [self.contentView addSubview:_bgView];

        UIView *container = _bgView;
        
        UIImage *stateImage = [UIImage imageNamed:@"well_challenge_unpass"];
        self.stateImageView = [[UIImageView alloc] initWithImage:stateImage];
        self.stateImageView.frame = CGRectMake(0, 0, stateImage.size.width*0.66, stateImage.size.height*0.66);
        
        [_bgView addSubview:self.stateImageView];
        
        self.iconImageView = [UIImageView new];
        [_bgView addSubview:self.iconImageView];
        
        self.coverView = [UIView new];
        _coverView.backgroundColor = [UIColor wr_alphaLabelBlackColor];
        [_bgView addSubview:_coverView];
        
        self.labelText = [UILabel new];
        [_bgView addSubview:self.labelText];
        self.labelText.font = [UIFont wr_smallFont];
        
        self.labelDetailText = [UILabel new];
        [_bgView addSubview:self.labelDetailText];
        self.labelDetailText.textAlignment = NSTextAlignmentCenter;
        self.labelDetailText.font = [UIFont wr_bigTitleFont];
        self.labelDetailText.alpha = 0.5;
        self.labelDetailText.textColor = [UIColor grayColor];
        
        self.lockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"well_time_state_lock"]];
        [container addSubview:self.lockImageView];
        
        UILabel *label = [[UILabel alloc] init];
        if (biPad) {
//            self.textLabel.font = [UIFont wr_smallTitleFont];
            self.labelText.font = [UIFont wr_smallTitleFont];
            self.labelText.numberOfLines = 2;
            label.font = [UIFont wr_lightFont];
        }
        label.text = NSLocalizedString(@"难度 ", nil);
        label.font = [UIFont wr_detailFont];
        label.textColor = [UIColor lightGrayColor];
        [label sizeToFit];
        [container addSubview:label];
        _titleLabel = label;
        
        CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, 80, 22) numberOfStars:5 backgroundImage:[UIImage imageNamed:@"nav_transparent"] foregroundImage:[UIImage imageNamed:@"b27_icon_star_yellow"]];
        starRateView.scorePercent = 0;
        starRateView.allowIncompleteStar = NO;
        starRateView.hasAnimation = NO;
        starRateView.userInteractionEnabled = NO;
        [container addSubview:starRateView];
        self.rateView = starRateView;
        
//        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
//        self.detailTextLabel.font = [self.textLabel.font fontWithBold];
        

//        label  = [[UILabel alloc] init];
//        label.font = self.labelDetailText.font;
//        label.textAlignment = self.labelDetailText.textAlignment;
//        [container addSubview:label];
//        _stateLabel = label;
        _lineView = [WRUIConfig createLineWithWidth:0];
        _lineView.height = 1;
        _lineView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
        [_bgView addSubview:_lineView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat offset = WRUIMidOffset;
    
    _bgView.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
    CGRect frame = _bgView.bounds;
    

    CGFloat cy = self.stateImageView.frame.size.height;
    CGFloat cx = self.stateImageView.frame.size.width;
    CGFloat x = frame.size.width - offset - cx;
    CGFloat y = (frame.size.height - cy)/2;
    self.stateImageView.frame = CGRectMake(x, y, cx, cy);
    [_bgView bringSubviewToFront:self.stateImageView];
    
    x = offset;
    y = offset;
    cy = frame.size.height - 2 *y;
    cx = cy*16/9;
    self.iconImageView.frame = CGRectMake(x, y, cx, cy);
    self.coverView.frame = self.iconImageView.frame;

    
    x += self.iconImageView.width + offset;
    
//    cx /= 3;
    CGSize size = [self.labelText sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    [self.labelText sizeToFit];
    y = self.iconImageView.top;
    self.labelText.frame = CGRectMake(x, y, size.width, size.height);
    y = self.labelText.bottom + 3;
    

    _titleLabel.frame = CGRectMake(x, y, _titleLabel.width, self.rateView.height);
    x = _titleLabel.right + 3;
    self.rateView.frame = CGRectMake(x, y, self.rateView.width, self.rateView.height);
    
//    x = self.labelText.right + 3;
//    self.labelDetailText.frame = CGRectMake(x, y, cx, cy);
    
//    self.stateLabel.frame = CGRectMake(x, y, cx, cy);
    
    cx = self.lockImageView.width;
    cy = self.lockImageView.height;
    x = self.iconImageView.centerX - cx / 2;
    y = self.iconImageView.centerY - cy / 2;
    self.lockImageView.frame = CGRectMake(x, y, cx, cy);
    
    [self.labelDetailText sizeToFit];
    x = frame.size.width - self.labelDetailText.width - offset;
    y = frame.size.height - self.labelDetailText.height - offset;
    self.labelDetailText.frame = [Utility moveRect:self.labelDetailText.frame x:x y:y];
    
    y = _bgView.height - _lineView.height;
    _lineView.frame = CGRectMake(0, y, _bgView.width, _lineView.height);
}

@end
