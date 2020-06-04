//
//  ArticleCell.h
//  rehab
//
//  Created by 何寻 on 6/3/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRObject.h"

@interface ArticleCell : UITableViewCell

+(CGFloat)defaultHeightWithTableView:(UITableView*)tableView;
@property(nonatomic, readonly) UILabel *titleLabel, *dateLabel, *contentLabel;
@property(nonatomic, readonly) UIImageView *logoImageView;
@property(nonatomic) UIView *badgeView, *lineView;

-(void)setContent:(WRArticle*)news;

@end
