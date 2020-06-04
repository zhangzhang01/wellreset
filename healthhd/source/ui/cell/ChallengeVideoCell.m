//
//  ChallengeVideoCell.m
//  rehab
//
//  Created by 何寻 on 9/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ChallengeVideoCell.h"

@interface ChallengeVideoCell()
{
    UILabel *_titleLabel;
}
@end

@implementation ChallengeVideoCell

+(CGFloat)defaultHeightForTableView:(UITableView *)tableView {
    UIImage* image = [UIImage imageNamed:@"well_default_4_3"];
    return image.size.height*0.4 + 2*WRUIOffset;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *container = self.textLabel.superview;
        
        self.textLabel.font = [UIFont wr_smallFont];
        
        self.lockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"well_time_state_lock"]];
        [container addSubview:self.lockImageView];
        
        UILabel *label = [[UILabel alloc] init];
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
        
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        self.detailTextLabel.font = [self.textLabel.font fontWithBold];
        
        label  = [[UILabel alloc] init];
        label.font = self.detailTextLabel.font;
        label.textAlignment = self.detailTextLabel.textAlignment;
        [container addSubview:label];
        _stateLabel = label;
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
    
    CGRect frame = self.textLabel.superview.bounds;
    
    UIImage* image = [UIImage imageNamed:@"well_default_4_3"];
    CGFloat offset = WRUIOffset;
    CGFloat x = offset;
    CGFloat y = offset;
    CGFloat cy = frame.size.height - 2*y;
    CGFloat cx = cy*image.size.width/image.size.height;
    self.imageView.frame = CGRectMake(x, y, cx, cy);
    
    x += self.imageView.width + offset;
    cx = frame.size.width - x - 2*offset;
    
    cx /= 3;
    CGSize size = [self.textLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    y = (frame.size.height - self.rateView.height - 3 - size.height)/2;
    self.textLabel.frame = CGRectMake(x, y, (2*cx - 15), size.height);
    y = self.textLabel.bottom + 3;
    
    _titleLabel.frame = CGRectMake(x, y, _titleLabel.width, self.rateView.height);
    x = _titleLabel.right + 3;
    self.rateView.frame = CGRectMake(x, y, self.rateView.width, self.rateView.height);
    
    x = self.textLabel.right + offset;
    cx = frame.size.width - x - offset;
    y = self.textLabel.top;
    cy = self.textLabel.height;
    self.detailTextLabel.frame = CGRectMake(x, y, cx, cy);
    
    y = self.rateView.top;
    self.stateLabel.frame = CGRectMake(x, y, cx, cy);
    
    cx = self.lockImageView.width;
    cy = self.lockImageView.height;
    x = self.detailTextLabel.left + (self.detailTextLabel.width - cx)/2;
    y = (frame.size.height - cy)/2;
    self.lockImageView.frame = CGRectMake(x, y, cx, cy);
}

@end
