//
//  CaseCell.h
//  rehab
//
//  Created by yongen zhou on 2017/3/17.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRObject.h"
@interface CaseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *dise;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *person;
@property (weak, nonatomic) IBOutlet UIImageView *im;
- (void)layout:(WRcase*)wrcase;
@end
