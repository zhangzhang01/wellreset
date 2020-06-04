//
//  YSWFrendCell.h
//  Gofind
//
//  Created by yongen zhou on 16/10/20.
//  Copyright © 2016年 shizaihaoshizaihao. All rights reserved.
//
#import "NineSquareModel.h"
#import <UIKit/UIKit.h>
#import "WRObject.h"
@class NineSquareModel;
@interface YSWFrendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *images;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *imagesH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LineOneSegue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LineTwoSegue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LineThreeSegue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineheight;
@property (nonatomic, strong) NineSquareModel *squareM;
@property (weak, nonatomic) IBOutlet UIImageView *vipImg;
@property (weak, nonatomic) IBOutlet UIImageView *headIm;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *ping;
@property (weak, nonatomic) IBOutlet UIButton *zan;
@property (weak, nonatomic) IBOutlet UIButton *liwu;
-(void)loadcellWith:(WRCOMArticle*)friend;
@end
