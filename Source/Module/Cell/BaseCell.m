//
//  BaseCell.m
//  rehab
//
//  Created by herson on 7/14/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

+(CGFloat)defaultHeightForTableView:(UITableView *)tableView {
    UIImage* image = [UIImage imageNamed:@"well_default_4_3"];
    return image.size.height + 2*WRUIOffset;
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
    
    UIImage* image = [UIImage imageNamed:@"well_default_4_3"];
    CGFloat offset = WRUIOffset;
    CGFloat x = offset;
    CGFloat y = offset;
    self.imageView.frame = CGRectMake(x, y, image.size.width, image.size.height);
    
    x += image.size.width + offset;
    CGFloat cx = self.frame.size.width - x - 2*offset;
    
    y = CGRectGetMinY(self.imageView.frame);
    CGFloat cy = [self.textLabel sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)].height;
    self.textLabel.frame = CGRectMake(x, y, cx, cy);
    
    cy = [self.detailTextLabel sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)].height;
    y = CGRectGetMaxY(self.textLabel.frame) + 3;
    cy = MIN(cy, CGRectGetMaxY(self.imageView.frame) - y);
    self.detailTextLabel.frame = CGRectMake(x, y, cx, cy);
}

@end


@implementation CenterTitleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blueColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = self.contentView.bounds;
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = NO;
        }
    }
}
@end

@interface FillImageWithCenterTitleCell ()
{
    UIView *_maskView;
}
@end

@implementation FillImageWithCenterTitleCell

+(CGFloat)defaultHeightForTableView:(UITableView *)tableView
{
    static CGFloat dy = 0;
    if (dy == 0) {
        UIImage *image = [UIImage imageNamed:@"well_default_video"];
        dy = tableView.frame.size.width*image.size.height/image.size.width;
    }
    return dy;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasMaskView:(BOOL)hasMaskView {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
     
        self.textLabel.textColor = [UIColor wr_themeColor];
        self.textLabel.font = [UIFont wr_smallTitleFont];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        self.detailTextLabel.font = [UIFont wr_detailFont];
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        
        if (hasMaskView) {
            _maskView = [UIView new];
            _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            [self.textLabel.superview addSubview:_maskView];
        }
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat offset = WRUIMidOffset;
    
    CGFloat x, y;
    
    CGRect frame = self.contentView.bounds;
    
    x = 0, y = 0;
    UIImage *image = [UIImage imageNamed:@"well_default_video"];
    CGFloat cy = frame.size.width*image.size.height/image.size.width;
    self.imageView.frame = CGRectMake(0, 0, frame.size.width, cy);
    
    _maskView.frame = self.imageView.frame;
    
    [self.textLabel sizeToFit];
    [self.detailTextLabel sizeToFit];
    
    self.textLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    
    y = frame.size.height - self.detailTextLabel.height - offset;
    self.detailTextLabel.frame = CGRectMake(x, y, frame.size.width, self.detailTextLabel.height);
    
    [self.contentView bringSubviewToFront:_maskView];
    [self.contentView bringSubviewToFront:self.textLabel];
    [self.contentView bringSubviewToFront:self.detailTextLabel];
}

@end
