//
//  ArticleCell.h
//  rehab
//
//  Created by herson on 6/3/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRObject.h"

@interface ArticleCell : UITableViewCell

+(CGFloat)defaultHeightWithTableView:(UITableView*)tableView;
@property(nonatomic, readonly) UILabel *titleLabel, *dateLabel, *contentLabel, *readLabel;
@property(nonnull)UIButton* commetBtn ,*readBtn;
@property(nonatomic, readonly) UIImageView *logoImageView;
@property(nonatomic) UIView *badgeView, *lineView;
@property(nonatomic) UIImageView* hot;
-(void)setContent:(WRArticle*)news;

@end
