//
//  BaseCell.h
//  rehab
//
//  Created by herson on 7/14/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "CWStarRateView.h"

@interface BaseCell : UITableViewCell

+(CGFloat)defaultHeightForTableView:(UITableView*)tableView;

@end

@interface CenterTitleCell : UITableViewCell

@end

@interface FillImageWithCenterTitleCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasMaskView:(BOOL)hasMaskView;

+(CGFloat)defaultHeightForTableView:(UITableView*)tableView;

@end

