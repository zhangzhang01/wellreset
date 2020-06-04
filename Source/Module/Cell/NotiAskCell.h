//
//  NotiAskCell.h
//  rehab
//
//  Created by yongen zhou on 2017/4/28.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotiAskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *choose;

@end
