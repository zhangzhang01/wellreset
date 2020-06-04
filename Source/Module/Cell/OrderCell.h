//
//  OrderCell.h
//  rehab
//
//  Created by yongen zhou on 2017/6/29.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "TableViewCell.h"
#import "WRObject.h"
@interface OrderCell : TableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIView *bac;
@property (weak, nonatomic) IBOutlet UILabel *date;
- (void)loadwith:(WRImOrder*)detail;
@end
