//
//  ChallengeVideoCell.h
//  rehab
//
//  Created by 何寻 on 9/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface ChallengeVideoCell : UITableViewCell

@property(nonatomic)CWStarRateView *rateView;
@property(nonatomic)UIImageView *lockImageView;
@property(nonatomic)UILabel *stateLabel;
+(CGFloat)defaultHeightForTableView:(UITableView*)tableView;

@end
