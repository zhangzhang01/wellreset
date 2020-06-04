//
//  FAQCell.m
//  rehab
//
//  Created by Matech on 3/23/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "FAQCell.h"
#import "UIView+SDAutoLayout.h"

@interface FAQCell ()
{
    UILabel *_bubbleTextLabel;
    UIImageView *_bubbleImageView;
    UIView *_bubbleView;
}

@end

@implementation FAQCell

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
    
    UILabel *label = [UILabel new];
    label.text = NSLocalizedString(@"Q:", nil);
    label.textColor = [UIColor wr_rehabBlueColor];
    label.font = biPad ? [UIFont wr_titleFont] : [UIFont systemFontOfSize:[UIFont labelFontSize]];
    [self.contentView addSubview:label];
    self.leftLabel = label;
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = biPad ? [UIFont wr_textFont] : [UIFont wr_textFont];
    contentLabel.numberOfLines = 0;
    //contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    CGFloat lineHeight = 0.5;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, lineHeight)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    CGFloat margin;
    margin = WRUIOffset;
    
    NSDictionary *answerAttr = @{NSFontAttributeName:biPad ? [UIFont wr_titleFont] : [UIFont systemFontOfSize:[UIFont labelFontSize]]};
    CGSize answerMaxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize answerSize = [@"Q:" boundingRectWithSize:answerMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:answerAttr context:nil].size;
    self.leftLabel.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .topSpaceToView(self.contentView, margin)
    .widthIs(answerSize.width)
    .heightIs(answerSize.height);
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.leftLabel, 0)
    .topSpaceToView(self.contentView, margin)
    .rightSpaceToView(self.contentView, margin)
    .autoHeightRatio(0);
    
    contentLabel.text = @" ";
    //CGSize size = [contentLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    self.contentLabel.sd_layout
    .leftEqualToView(self.leftLabel)
    .rightEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, margin)
    .autoHeightRatio(0);
    
    line.sd_layout
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .topSpaceToView(self.contentLabel, margin - lineHeight)
    .heightIs(lineHeight);
    
    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:margin];
}

-(void)setContent:(WRFAQ*)object {
    self.titleLabel.text = object.question;
    self.contentLabel.text = object.answer;
}

@end
