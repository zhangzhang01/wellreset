//
//  ArticleCell.m
//  rehab
//
//  Created by 何寻 on 6/3/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ArticleCell.h"

@interface ArticleCell()
{
    UIView *_bgView;
    UILabel *_readLabel;
    UIImageView *_indicatorImageView;
}
@end

@implementation ArticleCell

+(CGFloat)defaultHeightWithTableView:(UITableView*)tableView {
    static CGFloat height = 0;
    if (height == 0) {
        ArticleCell *cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        height = 5*WRUIMidOffset + cell.titleLabel.height + cell.contentLabel.height + cell.dateLabel.height + cell.lineView.height;
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
            font = [UIFont wr_tinyFont];
        }
    }
    titleLabel.font = font;
    titleLabel.numberOfLines = 2;
    return titleLabel;
}

+(UILabel*)createDetailLabel {
    BOOL biPad = [WRUIConfig IsHDApp];
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor wr_detailTextColor];
    UIFont *font;
    if(biPad)
    {
        font = [UIFont wr_titleFont];
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
        font = [UIFont wr_titleFont];
    }
    else
    {
        if ([UIScreen mainScreen].scale > 2.0)
        {
            font = [UIFont wr_detailFont];
        }
        else
        {
            font = [UIFont wr_detailFont];
        }
    }
    titleLabel.font = font;
    titleLabel.numberOfLines = 1;
    return titleLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setUp];
    }
    return self;
}

-(void)setUp {
    _bgView = self.contentView;
    
    _titleLabel = [self.class createTitleLabel];
    _titleLabel.text = @"test\ntest";
    [_titleLabel sizeToFit];
    [_bgView addSubview:_titleLabel];
    
    _contentLabel = [self.class createDetailLabel];
    _contentLabel.text = @"test\test";
    [_contentLabel sizeToFit];
    [_bgView addSubview:_contentLabel];

    _dateLabel = [self.class createSubTitleLabel];
    _dateLabel.text = @"2016-01-01";
    [_dateLabel sizeToFit];
    [_bgView addSubview:_dateLabel];
    
    _logoImageView = [[UIImageView alloc] init];
    [_bgView addSubview:_logoImageView];
    
    _lineView = [WRUIConfig createLineWithWidth:0];
    [_bgView addSubview:_lineView];
    
    _readLabel = [self.class createSubTitleLabel];
    _readLabel.text = @"1000000";
    _readLabel.textAlignment = NSTextAlignmentLeft;
    [_readLabel sizeToFit];
    [_bgView addSubview:_readLabel];
    
    _indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_view"]];
    [_bgView addSubview:_indicatorImageView];
    
    _badgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    _badgeView.backgroundColor = [UIColor redColor];
    _badgeView.layer.cornerRadius = _badgeView.height/2;
    _badgeView.layer.masksToBounds = YES;
    [_bgView addSubview:_badgeView];
}

-(void)layoutSubviews {
    [super layoutSubviews];

    CGRect bounds = _bgView.bounds;
    
    CGFloat x, y, cy;
    const CGFloat offset = WRUIMidOffset;
    const CGFloat smallOffset = WRUILittleOffset;
    x = offset;
    y = x;
    CGFloat cx = (bounds.size.height - 2*offset - self.lineView.height);
    cy = cx;
    _logoImageView.frame = CGRectMake(x, y, cx, cy);
    
    x = _logoImageView.right - self.badgeView.width/2;
    y = _logoImageView.top - self.badgeView.height/2;
    self.badgeView.frame = CGRectMake(x, y, self.badgeView.width, self.badgeView.height);
    
    x = _logoImageView.right + offset;
    cx = bounds.size.width - offset - x;
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    _titleLabel.frame = CGRectMake(x, y, cx, size.height);
    y = _titleLabel.bottom + smallOffset;
    
    size = [_contentLabel sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    cy = size.height;
    _contentLabel.frame = CGRectMake(x, y, cx, cy);
    
    cy = _dateLabel.height;
    y = _logoImageView.bottom - cy;
    cx = _dateLabel.width;
    _dateLabel.frame = CGRectMake(x, y, cx, cy);
    [_dateLabel sizeToFit];
    
    [_readLabel sizeToFit];
    
    cy = MAX(_indicatorImageView.height, _readLabel.height);
    x = bounds.size.width - offset - _readLabel.width - smallOffset - _indicatorImageView.width;
    y = _logoImageView.bottom - cy;
    CGFloat y0 = y + (cy - _indicatorImageView.height)/2;
    _indicatorImageView.frame = CGRectMake(x, y0, _indicatorImageView.width, _indicatorImageView.height);
    x = _indicatorImageView.right + smallOffset;
    y0 = y + (cy - _readLabel.height)/2;
    _readLabel.frame = CGRectMake(x, y0, _readLabel.width, _readLabel.height);
    
    y = bounds.size.height - _lineView.height;
    _lineView.frame = CGRectMake(0, y, bounds.size.width, _lineView.height);
}

-(void)setContent:(WRArticle *)news {
    _titleLabel.text = news.title;
    NSString *dateString = news.createTime;
    if (dateString.length > 10) {
        dateString = [dateString substringToIndex:10];
    }
    _dateLabel.text = dateString;
    [_logoImageView setImageWithUrlString:news.imageUrl holder:@"well_default"];
    _contentLabel.text = news.subtitle;
    
    _readLabel.text = [@(news.viewCount) stringValue];
}

@end
