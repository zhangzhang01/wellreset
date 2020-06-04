//
//  WRFAQCell.m
//  rehab
//
//  Created by Matech on 3/23/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRFAQCell.h"
#import "UIView+SDAutoLayout.h"

@interface WRFAQCell ()
{
    UILabel *_bubbleTextLabel;
    UIImageView *_bubbleImageView;
    UIView *_bubbleView;
}

@end

@implementation WRFAQCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
    }
    return self;
}

-(void)setUp {
    BOOL biPad = [WRUIConfig IsHDApp];
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = biPad ? [UIFont wr_titleFont] : [UIFont systemFontOfSize:[UIFont labelFontSize]];
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor lightGrayColor];
    contentLabel.font = biPad ? [UIFont wr_textFont] : [UIFont wr_textFont];
    contentLabel.numberOfLines = 3;
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    CGFloat margin = WRUIOffset;
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .topSpaceToView(self.contentView, margin)
    .rightSpaceToView(self.contentView, margin)
    .autoHeightRatio(0);
    
    contentLabel.text = @" ";
    CGSize size = [contentLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    self.contentLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, margin)
    .heightIs(size.height);
    
    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:margin];
}

-(void)setContent:(WRFAQ*)object {
    self.titleLabel.text = object.question;
    self.contentLabel.text = object.answer;
}

@end
