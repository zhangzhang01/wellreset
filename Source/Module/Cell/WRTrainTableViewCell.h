//
//  WRTrainTableViewCell.h
//  rehab
//
//  Created by yongen zhou on 2017/2/24.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRTrainTableViewCell : UITableViewCell
@property(nonatomic) UILabel *titleLabel, *signContent , *completeContent , *trainContent , *sign , *complete , *train , *nameLabel;
@property(nonatomic) UIImageView *iconimageView , *nextIM;
- (CGFloat)Heightforcell;
@end
