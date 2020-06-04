//
//  WRUserDiseaseHistoryCell.m
//  rehab
//
//  Created by Matech on 4/13/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRUserDiseaseHistoryCell.h"
#//import "UIView+SDAutoLayout.h"

@implementation WRUserDiseaseHistoryCell

+(CGFloat)heightForText:(NSString *)title text:(NSString *)text tabelView:(UITableView *)tableView {
    CGFloat hMargin = WRUIBigOffset, vMargin = WRUIBigOffset;
    UIFont *font = [UIFont wr_textFont];
    CGSize size1 = [title sizeForFont:font size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    CGSize size2 = [text sizeForFont:font size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    CGFloat dy = 0;
    if ((size1.width + hMargin + size2.width) > (tableView.bounds.size.width - 2*hMargin)) {
        size2 = [text sizeForFont:font size:CGSizeMake(tableView.bounds.size.width - 2*hMargin, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
        dy = size1.height + size2.height + 3*vMargin;
    } else {
        dy = 2*vMargin + size1.height;
    }
    return dy;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
    }
    return self;
}

-(void)setUp {
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont wr_textFont];
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor lightGrayColor];
    contentLabel.font = [UIFont wr_textFont];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    _contentLabel = contentLabel;
    
    /*
    CGFloat hMargin = WRUIBigOffset, vMargin = WRUILittleOffset;
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, hMargin)
    .topSpaceToView(self.contentView, vMargin)
    .rightSpaceToView(self.contentView, hMargin)
    .autoHeightRatio(0);
    
    self.contentLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, vMargin)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:vMargin];
     */
}

-(void)setModel:(NSObject *)model
{
    NSString *text = (NSString*)model;
    //CGFloat bottomMargin = WRUILittleOffset;
    _contentLabel.text = text;
    //第一个参数是cell最下面的那个view,第二个参数是最下面那个View离cell底部的距离
    //[self setupAutoHeightWithBottomView:_contentLabel bottomMargin:bottomMargin];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.bounds;
    CGFloat hMargin = WRUIBigOffset, vMargin = WRUIBigOffset;
    CGFloat x = (IPAD_DEVICE ? 3*hMargin : hMargin), y = vMargin, cx = (frame.size.width - 2*x);//, cy = [WRUIConfig defaultLabelHeight];
    
    CGSize size1 = [self.titleLabel.text sizeForFont:[UIFont wr_textFont] size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    CGSize size2 = [self.contentLabel.text sizeForFont:[UIFont wr_textFont] size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    ///CGFloat dy = 0;
    
    self.titleLabel.frame = CGRectMake(x, y, size1.width, size1.height);
    x += size1.width + hMargin;
    if ((size1.width + hMargin + size2.width) > (frame.size.width - 2*hMargin)) {
        y = CGRectGetMaxY(self.titleLabel.frame) + vMargin;
        x = hMargin;
        cx = frame.size.width - 2*x;
        size2 = [self.contentLabel.text sizeForFont:[UIFont wr_textFont] size:CGSizeMake(cx, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    }
    self.contentLabel.frame = CGRectMake(x, y, cx, size2.height);

    /*
    y = CGRectGetMaxY(self.titleLabel.frame) + vMargin;
    CGSize size = [self.contentLabel.text sizeForFont:[UIFont wr_textFont] size:CGSizeMake(frame.size.width - 2*hMargin, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    self.contentLabel.frame = CGRectMake(x, y, frame.size.width - 2*hMargin, size.height);
     */
}

@end

