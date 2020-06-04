//
//  ArticleCell.m
//  rehab
//
//  Created by herson on 6/3/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ArticleCell.h"
#import <YYKit/YYKit.h>
#import "UIKit+WR.h"
@interface ArticleCell()
{
    UIView *_bgView;
    UIImageView *_indicatorImageView;
}
@end

@implementation ArticleCell

+(CGFloat)defaultHeightWithTableView:(UITableView*)tableView {
    static CGFloat height = 0;
    if (height == 0) {
//        ArticleCell *cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        height = 4*WRUIMidOffset + cell.titleLabel.height + cell.readLabel.height/* + cell.lineView.height*/;
        height = 103;
    }
    return height;
}

+(UILabel*)createTitleLabel {
    BOOL biPad = [WRUIConfig IsHDApp];
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor wr_titleTextColor];
    UIFont *font;
    if(biPad)
    {
        font = [UIFont wr_titleFont];
    }
    else
    {
        if ([UIScreen mainScreen].scale > 2.0)
        {
            font = [UIFont systemFontOfSize:([UIFont buttonFontSize])];
        }
        else
        {
            font = [UIFont systemFontOfSize:WRTitleFont];
        }
    }
    titleLabel.font = font;
    titleLabel.numberOfLines = 1;
    return titleLabel;
}

+(UILabel*)createDetailLabel {
    BOOL biPad = [WRUIConfig IsHDApp];
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor wr_detailTextColor];
    UIFont *font;
    if(biPad)
    {
        font = [UIFont wr_smallTitleFont];
    }
    else
    {
        if ([UIScreen mainScreen].scale > 2.0)
        {
            font = [UIFont systemFontOfSize:([UIFont labelFontSize] - 2)];
        }
        else
        {
            font = [UIFont wr_smallFont];
        }
    }
    titleLabel.font = font;
    titleLabel.numberOfLines = 2;
    return titleLabel;
}

+(UILabel*)createSubTitleLabel {
    BOOL biPad = [WRUIConfig IsHDApp];
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor wr_detailTextColor];
    UIFont *font;
    if(biPad)
    {
        font = [UIFont wr_lightFont];
    }
    else
    {
        if ([UIScreen mainScreen].scale > 2.0)
        {
            font = [UIFont systemFontOfSize:WRDetailFont];
        }
        else
        {
            font = [UIFont systemFontOfSize:WRDetailFont];
        }
    }
    titleLabel.font = font;
    titleLabel.numberOfLines = 2;
    return titleLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
}

-(void)setUp {
    _bgView = [UIView new];//self.contentView;
    _bgView.backgroundColor = [UIColor whiteColor];
    //[_bgView wr_setShadow];
    [self.contentView addSubview:_bgView];
    
    UILabel *label = [self.class createTitleLabel];
//    label.text = @"test\ntest";
    [label sizeToFit];
    [_bgView addSubview:label];
    _titleLabel = label;

    label = [self.class createSubTitleLabel];
    label.backgroundColor = [UIColor wr_lightWhite];
    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"10000";
    [label wr_roundBorderWithColor:[UIColor wr_lightWhite]];
    [label sizeToFit];
//    [_bgView addSubview:label];
    _readLabel = label;
    
    UIButton* comment = [UIButton new];
    [comment setImage:[UIImage imageNamed:@"评论"] forState:0];
    comment.titleLabel.font = [UIFont systemFontOfSize:10];
//    [comment setTitle:@"999" forState:0];
    [comment  setTitleColor:[UIColor wr_detailTextColor] forState:0];
     [comment setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
    _commetBtn = comment;
    [_bgView addSubview:comment];
    
     comment = [UIButton new];
    [comment setImage:[UIImage imageNamed:@"人数"] forState:0];
//    [comment setTitle:@"100" forState:0];
    comment.titleLabel.font = [UIFont systemFontOfSize:10];
    [comment  setTitleColor:[UIColor wr_detailTextColor] forState:0];
    [comment setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
    _readBtn = comment;
    [_bgView addSubview:_readBtn];
    
    label = [self.class createSubTitleLabel];
//    label.text = @"10000";
    
    [_bgView addSubview:label];
    
    _contentLabel = label;
    
    
    _logoImageView = [[UIImageView alloc] init];
//    [_logoImageView wr_roundBorderWithColor:[UIColor whiteColor]];
    [_bgView addSubview:_logoImageView];
    
    _hot = [UIImageView new];
    [_hot setImage:[UIImage imageNamed:@"底部"]];
       [_bgView addSubview:_hot];
    
    _lineView = [WRUIConfig createLineWithWidth:0];
    _lineView.height = 1;
    _lineView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [_bgView addSubview:_lineView];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat offset = 12;
//    const CGFloat smallOffset = WRUILittleOffset;

    _bgView.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
    CGRect bounds = _bgView.bounds;
    
    CGFloat x, y, cy;
    
    x = offset;
    y = x;
    CGFloat cx = _bgView.height - 2*y;
    cy = cx;
    _logoImageView.frame = CGRectMake(x, y, cx, cy);
    
    

    
    
    x = _logoImageView.right + offset;
    cx = bounds.size.width - offset - x-20;
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    _titleLabel.frame = CGRectMake(x, y, cx, size.height);
    
    _contentLabel.frame = CGRectMake(x, _titleLabel.bottom+WRUIOffset, cx, size.height);
    [_contentLabel sizeToFit];
    
    
    
    _commetBtn.x = self.width-123;
    _commetBtn.y = self.height- 35;
    _commetBtn.height = 30;
    _commetBtn.width = 64;
//    [_commetBtn sizeToFit];
    
    _readBtn.x = self.width-64;
    _readBtn.y = self.height- 35;
    _readBtn.height = 30;
    _readBtn.width = 64;
//    [_readBtn sizeToFit];
    
    
    [_readLabel sizeToFit];
    cy = _readLabel.height + offset;
    y = _logoImageView.bottom - cy;
    cx = _readLabel.width + offset;
    x = bounds.size.width - offset - cx;                               
    _readLabel.frame = CGRectMake(x, y, cx, cy);
 
   
    _hot.x = 12;
    _hot.y = 16;
    _hot.width = _hot.image.size.width;
    _hot.height = _hot.image.size.height;
    UILabel* la = [[UILabel alloc]initWithFrame:_hot.bounds];
    la.text = @"热文";
    la.textColor = [UIColor whiteColor];
    la.font = [UIFont systemFontOfSize:12];
    la.textAlignment = NSTextAlignmentCenter;
    [_hot removeAllSubviews];
    [_hot addSubview:la];
    
    
    y = bounds.size.height - _lineView.height;
    _lineView.frame = CGRectMake(0, y, bounds.size.width, _lineView.height);
}

-(void)setContent:(WRArticle *)news {
    _titleLabel.text = news.title;
    _contentLabel.text =news.subtitle;
    [_readBtn setTitle:[NSString stringWithFormat:@"%ld",news.viewCount] forState:0];
    _hot.hidden = !news.hot;
    NSString *dateString = news.createTime;
    if (dateString.length > 10) {
        dateString = [dateString substringToIndex:10];
    }

    [_logoImageView setImageWithUrlString:news.imageUrl holder:@"well_default"];
    _readLabel.text = [NSString stringWithFormat:@"%@人阅读",[@(news.viewCount) stringValue]] ;
    [_commetBtn setTitle:[NSString stringWithFormat:@"%@",[@(news.commentCount) stringValue]] forState:0];
    
}

@end
