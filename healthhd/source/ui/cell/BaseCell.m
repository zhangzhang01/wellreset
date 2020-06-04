//
//  BaseCell.m
//  rehab
//
//  Created by 何寻 on 7/14/16.
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