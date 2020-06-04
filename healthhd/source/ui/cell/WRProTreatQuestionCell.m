//
//  WRProTreatQuestionCell.m
//  rehab
//
//  Created by 何寻 on 16/4/11.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "WRProTreatQuestionCell.h"
#import "UIView+SDAutoLayout.h"
#import "WRProTreat.h"

@interface WRProTreatQuestionCell ()

@end

@implementation WRProTreatQuestionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor lightGrayColor];
    contentLabel.font = [UIFont wr_textFont];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    CGFloat margin = WRUIOffset;
    
    self.contentLabel.sd_layout
    .leftSpaceToView(self.imageView, margin)
    .topSpaceToView(self.contentView, margin)
    .rightSpaceToView(self.contentView, margin)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:margin];
}

-(void)setModel:(NSObject *)model {
    WRProTreatAnswer *answer = (WRProTreatAnswer*)model;
    CGFloat bottomMargin = WRUIOffset;
    _contentLabel.text = answer.answer;
    //第一个参数是cell最下面的那个view,第二个参数是最下面那个View离cell底部的距离
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:bottomMargin];
}

@end


@implementation WRProTreatQuestionTitleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
    }
    return self;
}

-(void)setUp {
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [UIFont wr_titleFont];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    CGFloat margin = WRUIOffset;
    
    self.contentLabel.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .topSpaceToView(self.contentView, margin)
    .rightSpaceToView(self.contentView, margin)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:margin];
}


-(void)setModel:(NSObject *)model
{
    NSString *question = (NSString*)model;
    CGFloat bottomMargin = WRUIOffset;
    _contentLabel.text = question;
    //第一个参数是cell最下面的那个view,第二个参数是最下面那个View离cell底部的距离
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:bottomMargin];
}

@end
