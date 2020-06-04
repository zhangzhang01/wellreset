//
//  WRProgressCell.h
//  rehab
//
//  Created by herson on 8/25/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRProgressCell : UITableViewCell

+(CGFloat)defaultHeightForTableView:(UITableView*)tableView;

@property(nonatomic) UILabel *titleLabel,*trainLabel ,*contentLabel;
@property(nonatomic) UIImageView *iconimageView;

@end
