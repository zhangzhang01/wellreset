//
//  WRMesCell.h
//  rehab
//
//  Created by yongen zhou on 2018/9/11.
//  Copyright © 2018年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRObject.h"
@interface WRMesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *msg;
@property (weak, nonatomic) IBOutlet UILabel *rltMsg;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightconst;
@property (weak, nonatomic) IBOutlet UILabel *contentDetail;
- (void)loadWith:(WRMessage*)mes;
@end
