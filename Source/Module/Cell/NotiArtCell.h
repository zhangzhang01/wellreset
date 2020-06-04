//
//  NotiArtCell.h
//  rehab
//
//  Created by yongen zhou on 2017/4/28.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotiArtCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *im;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *choose;
//@property (weak, nonatomic) IBOutlet UIButton *sender;
@property (weak, nonatomic) IBOutlet UILabel *sender;

@end
