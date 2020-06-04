//
//  OrderCell.m
//  rehab
//
//  Created by yongen zhou on 2017/6/29.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell
-(void)loadwith:(WRImOrder *)detail
{
    self.bac.layer.shadowOpacity = 0.15;// 阴影透明度
    //    card.layer.masksToBounds =YES;
    self.bac.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
    
    //    card.layer.borderColor = [UIColor blackColor].CGColor;
    //    card.layer.borderWidth =0.5;
    
    self.bac.layer.shadowRadius = 3;// 阴影扩散的范围控制
    
    self.bac.layer.shadowOffset  = CGSizeMake(2, 2);
    self.bac.layer.cornerRadius = 5;
    NSString* createtime = @"";
    NSDate* date = [NSDate dateWithString:detail.createTime];
    NSDateFormatter* format =[NSDateFormatter new];
    [format setDateFormat:@"YYYY.MM.dd"];
    createtime = [format stringFromDate:date];
    self.time.text = [NSString stringWithFormat:@"订单日期：%@",createtime];
    switch (detail.status) {
        case 0:
            self.status.text = @"未付款";
            self.status.textColor = [UIColor redColor];
            break;
        case 1:
            self.status.text = @"已付款";
            self.status.textColor = [UIColor wr_themeColor];
            break;
        case 2:
            self.status.text = @"已完成";
            self.status.textColor = [UIColor wr_themeColor];
            break;
            
        default:
            break;
        
            

    }
    self.name.text = detail.productName;
    if (detail.type ==1) {
        self.type.text = @"单次";
    }
    else
    {
        self.type.text = @"签约";
    }
    
    NSDate* timestar = [NSDate dateWithString:detail.startDate];
    NSDate* timeend = [NSDate dateWithString:detail.endDate];
    
    self.date.text = [NSString stringWithFormat:@"签约期限：%@~%@",[format stringFromDate:timestar],[format stringFromDate:timeend]];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
