//
//  WRTrainTableViewCell.m
//  rehab
//
//  Created by yongen zhou on 2017/2/24.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRTrainTableViewCell.h"

@implementation WRTrainTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = [UIColor darkTextColor];
        self.titleLabel.font = [UIFont wr_detailFont];
        self.titleLabel.text = @"锻炼打卡";
        [self.contentView addSubview:self.titleLabel];
        
        self.nameLabel = [UILabel new];
        self.nameLabel.textColor = [UIColor darkTextColor];
        self.nameLabel.font = [UIFont wr_textFont];
        [self.contentView addSubview:self.nameLabel];
        
        self.signContent = [UILabel new];
        self.signContent.textColor = [UIColor lightGrayColor];
        self.signContent.font = [UIFont wr_smallestFont];
        self.signContent.text = @"累计签到";
        [self.contentView addSubview:self.signContent];
        
        self.completeContent = [UILabel new];
        self.completeContent.textColor = [UIColor lightGrayColor];
        self.completeContent.font = [UIFont wr_smallestFont];
        self.completeContent.text = @"累计完成";
        [self.contentView addSubview:self.completeContent];
        
        self.trainContent = [UILabel new];
        self.trainContent.textColor = [UIColor lightGrayColor];
        self.trainContent.font = [UIFont wr_smallestFont];
        self.trainContent.text = @"累计锻炼";
        [self.contentView addSubview:self.trainContent];
        
        self.complete = [UILabel new];
        self.complete.textColor = [UIColor darkTextColor];
        self.complete.font = [UIFont wr_smallestFont];
        self.complete.text = @"0次";
        [self.contentView addSubview:self.complete];
        
        self.sign = [UILabel new];
        self.sign .textColor = [UIColor darkTextColor];
        self.sign .font = [UIFont wr_smallestFont];
        self.sign.text = @"0天";
        [self.contentView addSubview:self.sign ];
        
        self.train = [UILabel new];
        self.train .textColor = [UIColor darkTextColor];
        self.train .font = [UIFont wr_smallestFont];
        self.train.text = @"0分钟";
        [self.contentView addSubview:self.train ];
        
        self.iconimageView = [UIImageView  new];
        [self.iconimageView wr_roundFill];
        [self.contentView addSubview:self.iconimageView];
        
        self.nextIM = [UIImageView new];
        [self.contentView addSubview:self.nextIM];
    }
    return self;
}
-(void)layoutSubviews
{
    CGFloat offset = WRUIMidOffset;
    CGFloat inset = WRUIMidOffset;
    if (IPAD_DEVICE) {
        inset = ScreenW*1.0/4-70;
    }
    self.titleLabel.x = offset;
    self.titleLabel.y = offset;
    [self.titleLabel sizeToFit];
    self.iconimageView.x = offset+self.titleLabel.width+WRUILittleOffset;
    self.iconimageView.y = offset;
    self.iconimageView.width = 20;
    self.iconimageView.height = 20;
    self.iconimageView.centerY = self.titleLabel.centerY;
    [self.iconimageView wr_roundFill];
    self.nameLabel.x = self.iconimageView.x+self.iconimageView.width+offset;
    self.nameLabel.y = offset;
    self.nameLabel.centerY = self.iconimageView.centerY;
    [self.nameLabel sizeToFit];
    self.nextIM.width =  WRNextWeight;
    self.nextIM.height = WRNextHeight;
    self.nextIM.x = self.width-self.nextIM.width-offset;
    self.nextIM.y = offset;
    [self.nextIM setImage:[UIImage imageNamed:@"训练打卡下一步图标"]];
    CGFloat Hoffset = WRUIBigOffset+WRUIOffset+WRUIDiffautOffset;
    NSString* attiStr ;
    
    attiStr = self.sign.text;
    NSRange attiRange = NSMakeRange(0, attiStr.length-1);
    [self.sign setWr_AttributedWithColorRange:attiRange Color:[UIColor wr_themeColor] FontRange:attiRange Font:[UIFont wr_titleFont] InitTitle:attiStr];
    self.sign.x = inset;
    self.sign.y = self.titleLabel.bottom+Hoffset;
    [self.sign sizeToFit];
    self.signContent.x = inset;
    self.signContent.y = self.sign.bottom+WRUILittleOffset;
    [self.signContent sizeToFit];
    self.sign.centerX = self.signContent.centerX;
    
    attiStr = self.complete.text;
    attiRange = NSMakeRange(0, attiStr.length-1);
    [self.complete setWr_AttributedWithColorRange:attiRange Color:[UIColor wr_themeColor] FontRange:attiRange Font:[UIFont wr_titleFont] InitTitle:attiStr];
    [self.complete sizeToFit];
    self.complete.centerX = self.completeContent.centerX;
    self.complete.y = self.titleLabel.bottom+Hoffset;
    
    self.completeContent.y = self.sign.bottom+WRUILittleOffset;
    [self.completeContent sizeToFit];
    self.completeContent.x = self.width-inset-self.completeContent.width;
    self.complete.centerX = self.completeContent.centerX;
    
    attiStr = self.train.text;
    attiRange = NSMakeRange(0, attiStr.length-2);
    [self.train setWr_AttributedWithColorRange:attiRange Color:[UIColor wr_themeColor] FontRange:attiRange Font:[UIFont systemFontOfSize:40] InitTitle:attiStr];
    self.train.x = self.centerX;
    self.train.bottom = self.sign.bottom;
    [self.train sizeToFit];
    self.trainContent.y = self.sign.bottom+WRUILittleOffset;
    [self.trainContent sizeToFit];
    self.trainContent.centerX = self.contentView.centerX ;
    self.train.centerX = self.trainContent.centerX;
    
}
- (CGFloat)Heightforcell
{
    return 95;
}
@end
