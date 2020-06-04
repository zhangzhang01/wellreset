//
//  WRMesCell.m
//  rehab
//
//  Created by yongen zhou on 2018/9/11.
//  Copyright © 2018年 WELL. All rights reserved.
//

#import "WRMesCell.h"

@implementation WRMesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadWith:(WRMessage *)mes
{
    [self.userImg setImageWithURL:mes.userImg placeholder:[UIImage imageNamed:@"well_default_head"]];
    if ([mes.action isEqualToString:@"comment"]) {
        self.content.text = [NSString stringWithFormat:@"%@ 评论了你的动态",mes.userName];
        self.msg.text = mes.msg;
    }
    else if ([mes.action isEqualToString:@"upvote"])
    {
        self.content.text = [NSString stringWithFormat:@"%@ 点赞了你的动态",mes.userName];
    }
    NSString* time = mes.rltTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:time];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    self.createTime.text = [formatter stringFromDate:date];
    
    if ([mes.img isEqualToString:@""]) {
        self.rightconst.constant = 15;
    }
    else
    {
        self.rightconst.constant = 91;
        
    }
    [self.img setImageWithURL:[NSURL URLWithString:mes.img] placeholder:nil];
    
    self.rltMsg.text = mes.rltMsg;
    
}
@end
