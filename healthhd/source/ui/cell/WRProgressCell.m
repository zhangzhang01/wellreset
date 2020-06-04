//
//  WRProgressCell.m
//  rehab
//
//  Created by 何寻 on 8/25/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRProgressCell.h"

@implementation WRProgressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [UILabel new];
        [self.contentView addSubview:self.titleLabel];
        self.contentLabel = [UILabel new];
        [self.contentView addSubview:self.contentLabel];
        
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont wr_bigFont];
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.font = [UIFont wr_detailFont];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    
    //CGSize size = [UIImage imageNamed:@"well_default"].size;
    CGFloat offset = WRUILittleOffset, x = 0, y = 0;
    
    self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    [self.titleLabel sizeToFit];
    [self.contentLabel sizeToFit];
    y = (frame.size.height - self.titleLabel.bounds.size.height)/2;
    x = (frame.size.width - self.titleLabel.bounds.size.width)/2;
    self.titleLabel.frame = [Utility moveRect:self.titleLabel.frame x:x y:y];
    
    y = frame.size.height - self.contentLabel.bounds.size.height - offset;
    x = (frame.size.width - self.contentLabel.bounds.size.width) - offset;
    self.contentLabel.frame = [Utility moveRect:self.contentLabel.frame x:x y:y];
    [self.contentView bringSubviewToFront:self.titleLabel];
    [self.contentView bringSubviewToFront:self.contentLabel];
}

@end
