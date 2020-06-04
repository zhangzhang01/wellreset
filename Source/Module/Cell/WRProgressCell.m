//
//  WRProgressCell.m
//  rehab
//
//  Created by herson on 8/25/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRProgressCell.h"
#import "CardView.h"

@interface WRProgressCell ()
{
    UIView *_bgView;
}
@end

@implementation WRProgressCell

+(CGFloat)defaultHeightForTableView:(UITableView *)tableView
{
    static CGFloat dy = 0;
    if (dy == 0) {
        UIImage *image = [UIImage imageNamed:@"well_default_banner"];
        dy = tableView.frame.size.width*image.size.height/image.size.width + 60;
    }
    return dy;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor whiteColor];
        _bgView = [CardView new];//self.contentView;
        //_bgView.backgroundColor = [UIColor whiteColor];
        //[_bgView wr_setShadow];
        [self.contentView addSubview:_bgView];
        
        self.iconimageView = [UIImageView new];
        self.iconimageView.clipsToBounds =YES;
        [_bgView addSubview:self.iconimageView];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = [UIColor whiteColor];
        [_bgView addSubview:self.titleLabel];
        self.contentLabel = [UILabel new];
        [_bgView addSubview:self.contentLabel];
        self.trainLabel = [UILabel new];
        [_bgView addSubview:self.trainLabel];
        self.trainLabel.textColor = [UIColor whiteColor];
        
        self.titleLabel.font = [UIFont wr_lightFont];
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.font = [UIFont wr_smallestFont];
        self.trainLabel.font = [UIFont wr_smallestFont];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat offset = WRUIOffset;
    
    CGFloat x = offset, y = 3;
    _bgView.frame = CGRectMake(x, y, self.contentView.width - 2*x, self.contentView.height - 3);
    
    CGRect frame = _bgView.bounds;
    
    x = 0, y = 0;

//    CGFloat cy = frame.size.width*image.size.height/image.size.width;
    CGFloat cy = _bgView.height;
    
    self.iconimageView.frame = CGRectMake(0, 0, frame.size.width, cy);
//    self.iconimageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentLabel sizeToFit];
    
//    y = (self.iconimageView.height - self.titleLabel.height)/2;
//    x = (self.iconimageView.width - self.titleLabel.width)/2;
    self.titleLabel.x = WRUIBigOffset;
    self.titleLabel.y = WRUIBigOffset;
    [self.titleLabel sizeToFit];
    
    self.trainLabel.x = WRUIBigOffset;
    self.trainLabel.y = self.titleLabel.bottom+WRUIOffset;
    [self.trainLabel sizeToFit];
    
    self.contentLabel.x = WRUIBigOffset;
    self.contentLabel.y = _bgView.height-WRUIBigOffset-self.contentLabel.height;
    [self.contentLabel sizeToFit];
//    y = self.contentView.bottom - offset - self.contentLabel.height;
//    x = _bgView.right - self.contentLabel.width - WRUIOffset;
//    self.contentLabel.frame = [Utility moveRect:self.contentLabel.frame x:x y:y];
    
    [_bgView bringSubviewToFront:self.titleLabel];
    [_bgView bringSubviewToFront:self.contentLabel];
    [_bgView bringSubviewToFront:self.trainLabel];
    
}

@end
