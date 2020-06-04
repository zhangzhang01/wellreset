//
//  ChallengeVideoCell.h
//  rehab
//
//  Created by herson on 9/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface ChallengeVideoCell : UITableViewCell

@property(nonatomic)CWStarRateView *rateView;
@property(nonatomic)UIImageView *lockImageView, *iconImageView, *stateImageView;
@property(nonatomic)UILabel *stateLabel, *labelText, *labelDetailText;
@property (nonatomic, strong) UIView *coverView;

+(CGFloat)defaultHeightForTableView:(UITableView*)tableView;

@end
