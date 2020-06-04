//
//  WRcommentCell.h
//  rehab
//
//  Created by yongen zhou on 2018/8/31.
//  Copyright © 2018年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRObject.h"
@interface WRcommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userimg;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *repuserimg;
@property (weak, nonatomic) IBOutlet UILabel *repusername;
@property (weak, nonatomic) IBOutlet UILabel *reptext;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightcon;
@property (weak, nonatomic) IBOutlet UIButton *upvoteIM;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondimg;
@property (weak, nonatomic) IBOutlet UIButton *resp;
- (void)loadwith:(WRCOMcomment*)comment;
@end
