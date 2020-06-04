//
//  questionTableViewCell.m
//  rehab
//
//  Created by matech on 2019/5/31.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "questionTableViewCell.h"

@implementation questionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}
-(void)setUpAllView
{

    self.titleImageV = [UIImageView zj_imageViewWithImage:@"WELL健康" SuperView:self.contentView contentMode:UIViewContentModeScaleAspectFit isClip:NO constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    
 
    
    
    // 昵称
    self.titleLabel = [UILabel zj_labelWithFontSize:15 textColor:[UIColor blackColor] superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleImageV.mas_bottom);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_lessThanOrEqualTo(30);
    }];
    self.titleLabel.numberOfLines = 0;
    // 内容
    self.contentLab = [UILabel zj_labelWithFontSize:15 lines:0 text:@"" textColor:COLOR_grayColor superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.height.mas_lessThanOrEqualTo(16);
    }];
    
    
    self.line = [UIView zj_viewWithBackColor:COLOR_grayColor supView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(15);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0); // 这句很重要！！！
        
    }];
    
}

-(void)setValueWithTitle:(NSString *)title withDetail:(NSString *)detail
{
    self.titleLabel.text = title;
    
    
    NSMutableAttributedString* string2 = [[NSMutableAttributedString alloc]initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [string2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string2.length)];
    
    
    CGSize size2 = [title boundingRectWithSize:CGSizeMake(350, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    CGFloat sizeHeight2 = size2.height+20;
    
    
    // 昵称
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleImageV.mas_bottom);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(sizeHeight2);
    }];
    
    
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithData:[detail dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
    
    
    CGSize size = [detail boundingRectWithSize:CGSizeMake(350, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    CGFloat sizeHeight = size.height+20;
    
    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(sizeHeight);
    }];
    self.contentLab.attributedText = string;
    self.contentLab.textColor = COLOR_grayColor;
    
    [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLab.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0); // 这句很重要！！！
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
