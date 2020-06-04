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
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"well_common_answer"]];
    [self.contentView addSubview:imageView];
    self.iconImageView = imageView;
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor wr_faqContentColor];
    contentLabel.font = biPad ? [UIFont wr_textFont] : [UIFont wr_textFont];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    CGFloat margin = WRUIOffset;
    
    self.iconImageView.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .topSpaceToView(self.contentView, margin)
    .widthIs(20)
    .heightIs(20);
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.iconImageView, margin)
    .topSpaceToView(self.contentView, margin)
    .rightSpaceToView(self.contentView, margin)
    .autoHeightRatio(0);

    
    self.contentLabel.sd_layout
    .leftEqualToView(self.iconImageView)
    .rightEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, margin)
     .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:margin];
}

-(void)setContent:(WRFAQ*)object {
    self.titleLabel.text = object.question;
    
//    NSString *text = object.answer;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:8];//调整行间距
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
//    self.contentLabel.attributedText = attributedString;
    self.contentLabel.text = object.answer;
}

@end
