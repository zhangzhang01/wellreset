
//
//  WRcommentCell.m
//  rehab
//
//  Created by yongen zhou on 2018/8/31.
//  Copyright © 2018年 WELL. All rights reserved.
//

#import "WRcommentCell.h"
#import "ComulitModel.h"
@implementation WRcommentCell

-(void)loadwith:(WRCOMcomment *)comment
{
    [self.userimg setImageWithURL:[NSURL URLWithString:comment.userimg]placeholder:[UIImage imageNamed:@"well_default_head"]];
    NSString *str =  [comment.username stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (str.length<1) {
        str = @"匿名用户";
    }
    self.firstImg.hidden = YES;
    self.secondimg.hidden = YES;
    if ([comment.userId isEqualToString:@"ce01d858-c94f-453f-b8e7-2d031fead928"]) {
        
        
        
        self.firstImg.image = [UIImage imageNamed:@"V认证"];
        self.firstImg.hidden = NO;
        
        
    }
    
    
    self.username.text = str;
    NSString* time = comment.createTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:time];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    self.createTime.text = [formatter stringFromDate:date];
    [self.repuserimg setImageWithURL:[NSURL URLWithString:comment.repuserimg]];
    NSString *str2 =  [comment.repusername stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.repusername.text = str2;
    [self.upvoteIM setTitle:[NSString stringWithFormat:@"%@",comment.upvote]  forState:UIControlStateNormal];
    NSString *str22 =  [comment.reptext stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.reptext.text = str22;
    NSString *str23 =  [comment.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.text.text = str23;
    
    
    if ([comment.repuserId isEqualToString:@"ce01d858-c94f-453f-b8e7-2d031fead928"]) {
        self.secondimg.image = [UIImage imageNamed:@"V认证"];
        self.secondimg.hidden = NO;
    }
    self.resp.layer.borderColor = [UIColor colorWithHexString:@"bfbfbf"].CGColor;
    if (comment.isupvote) {
        [self.upvoteIM setImage:[UIImage imageNamed:@"点赞效果-1"] forState:0];
        self.upvoteIM.layer.borderColor = [UIColor wr_themeColor].CGColor;

        self.upvoteIM.titleLabel.textColor = [UIColor wr_themeColor];
    }
    else
    {
        [self.upvoteIM setImage:[UIImage imageNamed:@"点赞-1"] forState:0];
        self.upvoteIM.layer.borderColor = [UIColor colorWithHexString:@"bfbfbf"].CGColor;
        self.upvoteIM.titleLabel.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    }
    
    if ([comment.repuserId isEqualToString:@""]) {
        self.hightcon.constant = 0;
        self.repuserimg.hidden = YES;
        [self updateConstraints];
    }
    else
    {
        CGFloat w = ScreenW - 68 - 17;
        
        
       CGRect r = [comment.reptext boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
        
        self.hightcon.constant = r.size.height+50+13;
        
        
        
        
    }
    [self.upvoteIM bk_whenTapped:^{
        ComulitModel* model = [ComulitModel new];
        [model upvoteArticle:comment.uuid Completion:^(NSError * error) {
            if (error==nil) {
                [self.upvoteIM setImage:[UIImage imageNamed:@"点赞效果-1"] forState:0];
                comment.isupvote = YES;
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"zanReloadCell" object:nil];
            }else{
                [AppDelegate show:error];
            }
            
        }];
    }];
}
@end
