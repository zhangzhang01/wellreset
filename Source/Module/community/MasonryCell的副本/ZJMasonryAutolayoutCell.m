//
//  ZJMasonryAutolayoutCell.m
//  ZJUIKit
//
//  Created by dzj on 2018/1/26.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//
/**
 *  ZJKitTool
 *
 *  GitHub地址：https://github.com/Dzhijian/ZJKitTool
 *
 *  本库会不断更新工具类，以及添加一些模块案例，请各位大神们多多指教，支持一下。😆
 */
#import "ZJMasonryAutolayoutCell.h"
#import "WRObject.h"

//#import "ZJReplyCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIButton+ZJMasonryKit.h"
//#import "KNPhotoBrower.h"
#import <KSPhotoBrowser/KSPhotoBrowser.h>
//#import "Masonry.h"
//#import "UIImageView+ZJMasonryKit.h"
//#import "UILabel+ZJMasonryKit.h"
//#import "UIView+ZJMasonryKit.h"
//#import "UIView+ZJMasonryFrame.h"
//#define ReplyCellKey @"ZJReplyCell"

@interface ZJMasonryAutolayoutCell() <KSPhotoBrowserDelegate>//<UITableViewDelegate,UITableViewDataSource>




@end

@implementation ZJMasonryAutolayoutCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}


-(void)setModel:(WRCOMArticle *)model{
    model = model;
    
//    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.user.imgUrl]];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.user.imgUrl] placeholderImage:[UIImage imageNamed:@"well_logo"]];
    
    NSString *str =  [model.user.name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (str.length<1) {
        str = @"匿名用户";
    }
    self.vipStar.hidden = YES;
    if ([model.user.userId isEqualToString:@"ce01d858-c94f-453f-b8e7-2d031fead928"]) {
//        [self.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_avatar.mas_centerY).offset(-10);
//            make.left.equalTo(_avatar.mas_right).offset(15);
//            make.right.mas_equalTo(-230);
//            make.height.mas_equalTo(20);
//        }];
//        [self.nameLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        self.vipStar.image = [UIImage imageNamed:@"V认证"];
        self.vipStar.hidden = NO;
    }
    
    
    
    self.nameLab.text =str;
    NSString* time = model.createTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:time];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    self.timeLab.text = [formatter stringFromDate:date];
    
//    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    style.lineBreakMode = NSLineBreakByWordWrapping;
//    style.alignment = NSTextAlignmentLeft;
//    NSAttributedString *string = [[NSAttributedString alloc]initWithString:model.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:style}];
//    CGSize size =  [string boundingRectWithSize:CGSizeMake(200.f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
     NSString *str2 =  [model.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithData:[str2 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
   
 
    CGSize size = [str2 boundingRectWithSize:CGSizeMake(ScreenW-90, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
//    CGFloat sizeHeight = size.height+10;
//    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_avatar.mas_bottom).offset(-10);
//        make.left.equalTo(_nameLab.mas_left);
//        make.right.mas_equalTo(-15);
//        NSLog(@"字体长度%lu",(unsigned long)string.length);
////        make.height.mas_equalTo(sizeHeight);
//    }];
    self.contentLab.attributedText = string;
  
    [self.ping setImage:[UIImage imageNamed:@"评论shejiao"] forState:0];
    [self.ping setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self.ping setTitleColor:COLOR_grayColor forState:UIControlStateNormal];
    [self.zan setTitleColor:COLOR_grayColor forState:UIControlStateNormal];
    self.ping.titleLabel.font = FONT_14;
    self.zan.titleLabel.font = FONT_14;
    [self.zan setImage:[UIImage imageNamed:@"点赞-1"] forState:0];
    [self.zan setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self.ping setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.zan setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    self.line.backgroundColor = COLOR_grayColor;
    [self.ping setTitle:[NSString stringWithFormat:@"%ld",(long)model.cnt] forState:0];
    [self.zan setTitle:[NSString stringWithFormat:@"%ld",(long)model.upvote] forState:0];
    
    if (model.isupvote) {
        [self.zan setImage:[UIImage imageNamed:@"点赞效果-1"] forState:0];
    }
    else
    {
        [self.zan setImage:[UIImage imageNamed:@"点赞-1"] forState:0];
    }
    
    NSInteger count = model.images.count;
   
    if (count > 0 ) {
        _photosView.pic_urls = model.images;
        _photosView.selfVc = _weakSelf;
        // 有图片重新更新约束
        CGFloat oneheight = (kScreenWidth - _nameLab.zj_originX - 15 -20)/3;
        // 三目运算符 小于或等于3张 显示一行的高度 ,大于3张小于或等于6行，显示2行的高度 ，大于6行，显示3行的高度
        CGFloat photoHeight = count<=3 ? oneheight : (count<=6 ? 2*oneheight+10 : oneheight *3+20);

        [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLab.mas_bottom).offset(10);
            make.left.equalTo(_nameLab.mas_left);
            make.right.mas_equalTo(-15);
            if (count==9) {
                make.height.mas_equalTo(photoHeight);
                
            }
            else{
                make.height.mas_equalTo(photoHeight);
                
            }
            
            make.bottom.mas_equalTo(-45);
        }];
        
        [_ping mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photosView.mas_bottom).offset(10);
            make.right.mas_equalTo(-100);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(20);
        }];
        
        
        [_zan mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photosView.mas_bottom).offset(10);
            make.right.mas_equalTo(-15);;
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(20);
        }];

        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_ping.mas_bottom).offset(35);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0); // 这句很重要！！！
        }];
        _photosView.hidden = NO;
    }else{
        [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLab.mas_bottom).offset(10);
            make.left.equalTo(_nameLab.mas_left);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(0.001);
        }];
        [_ping mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photosView.mas_bottom).offset(10);
            make.right.mas_equalTo(-100);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(20);
        }];
        
        
        [_zan mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photosView.mas_bottom).offset(10);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(20);
        }];
        
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_ping.mas_bottom).offset(10);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0); // 这句很重要！！！
        }];
    
        _photosView.hidden = YES;
    }
  
}


// 添加所子控件
-(void)setUpAllView{
    // 头像
    self.avatar = [UIImageView zj_imageViewWithImage:@"" SuperView:self.contentView contentMode:UIViewContentModeScaleAspectFit isClip:NO constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
//    self.avatar.layer.cornerRadius = 5.0;
//    self.avatar.layer.masksToBounds = YES;
    
   
//    self.vipStar.layer.cornerRadius = 5.0;
//    self.vipStar.layer.masksToBounds = YES;
    
    
    // 昵称
    self.nameLab = [UILabel zj_labelWithFontSize:14 textColor:COLORBLUE superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_avatar.mas_centerY).offset(-5);
        make.left.equalTo(_avatar.mas_right).offset(15);
//        make.right.mas_equalTo(-180);
        make.height.mas_equalTo(30);
    }];
    if (IPAD_DEVICE) {
        self.nameLab.font = FONT_13;
    }
    
    //vip
    self.vipStar = [UIImageView zj_imageViewWithImage:@"" SuperView:self.contentView contentMode:UIViewContentModeScaleAspectFit isClip:NO constraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_avatar.mas_centerY).offset(-5);
        make.left.equalTo(_nameLab.mas_right).offset(5);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    // 时间
    self.timeLab = [UILabel zj_labelWithFontSize:12 textColor:COLOR_grayColor superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_avatar.mas_centerY).offset(-10);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(30);
        
    }];
    self.timeLab.textAlignment = NSTextAlignmentRight;
    
    
    
    // 内容
    self.contentLab = [UILabel zj_labelWithFontSize:15 lines:0 text:@"" textColor:[UIColor blackColor] superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatar.mas_bottom).offset(5);
        make.left.equalTo(_nameLab.mas_left);
        make.right.mas_equalTo(-15);
//        make.height.mas_lessThanOrEqualTo(16);
    }];
    
//    self.timeLab2 = [UILabel zj_labelWithFontSize:12 textColor:[UIColor blackColor] superView:self.contentView constraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_contentLab.mas_bottom).offset(10);
//        make.right.mas_equalTo(-15);
//        make.width.mas_equalTo(120);
//        make.height.mas_equalTo(40);
//
//    }];
    
    
    
    
    // 图片
    self.photosView = [[ZJCommitPhotoView alloc]init];
    [self.contentView addSubview:self.photosView];
    [_photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLab.mas_bottom).offset(10);
        make.left.equalTo(_nameLab.mas_left);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.001);
    }];
    
    
    self.ping = [UIButton zj_buttonWithTitle:@"" superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_photosView.mas_bottom).offset(10);
        make.right.mas_equalTo(-100);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    } touchUp:^(id sender) {
        if (self.pingblock) {
            self.pingblock(self.ping.tag);
            NSLog(@"%ld",(long)self.ping.tag);
        }
    }];

    self.zan = [UIButton zj_buttonWithTitle:@"" superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_photosView.mas_bottom).offset(10);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    } touchUp:^(id sender) {
        if (self.block) {
            self.block(self.zan.tag);
            NSLog(@"%ld",(long)self.zan.tag);
        }
    }];
    
   
    
    
#warning 注意  不管你的布局是怎样的 ，一定要有一个(最好是最底部的控件)相对 contentView.bottom的约束，否则计算cell的高度的时候会不正确！
    self.line = [UIView zj_viewWithBackColor:[UIColor blackColor] supView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zan.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(15);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0); // 这句很重要！！！
        
    }];
    
 
}

/*
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ReplyCellKey];
    
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 计算缓存cell的高度
    return [self.commentTable fd_heightForCellWithIdentifier:ReplyCellKey cacheByIndexPath:indexPath configuration:^(ZJReplyCell *cell) {
        [cell configData];
    }];
}


-(UITableView *)commentTable{
    if (!_commentTable) {
        _commentTable = [[UITableView alloc]init];
        _commentTable.scrollEnabled = NO;
        _commentTable.userInteractionEnabled = YES;
        _commentTable.backgroundView.userInteractionEnabled = YES;
        _commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentTable.delegate =self;
        _commentTable.dataSource = self;
        [_commentTable registerClass:[ZJReplyCell class] forCellReuseIdentifier:ReplyCellKey];
    }
    return _commentTable;
}
 
 */

// 如果你是自动布局子控件，就不需要实现此方法，如果是计算子控件frame的话就需要实现此方法
//- (CGSize)sizeThatFits:(CGSize)size {
//
//    CGFloat cellHeight = 0;
//
//    cellHeight += [self.avatar sizeThatFits:size].height;
//    cellHeight += [self.contentLab sizeThatFits:size].height;
//    cellHeight += [self.photosView sizeThatFits:size].height;
//    cellHeight += [self.line sizeThatFits:size].height;
//    cellHeight += 40;
//
//    return CGSizeMake(size.width, cellHeight);
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
