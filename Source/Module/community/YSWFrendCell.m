//
//  YSWFrendCell.m
//  Gofind
//
//  Created by yongen zhou on 16/10/20.
//  Copyright © 2016年 shizaihaoshizaihao. All rights reserved.
//

#import "YSWFrendCell.h"
#import "KNPhotoBrower.h"
#import "ComulitModel.h"
@interface YSWFrendCell()<KNPhotoBrowerDelegate>

@property (nonatomic, strong) NSMutableArray *itemsArr;

@end
@implementation YSWFrendCell


//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
//        
//    }
//    return self;
//}


-(void)loadcellWith:(WRCOMArticle*)friend
{
    [self.headIm setImageWithURL:[NSURL URLWithString:friend.user.imgUrl] placeholder:[UIImage imageNamed:@"well_logo"]];
    
    self.vipImg.hidden = YES;
    if ([friend.user.userId isEqualToString:@"ce01d858-c94f-453f-b8e7-2d031fead928"]) {
       
        
        
        self.self.vipImg.image = [UIImage imageNamed:@"V认证"];
        self.self.vipImg.hidden = NO;
    }
    
//    NSMutableAttributedString* string2 = [[NSMutableAttributedString alloc]initWithData:[friend.user.name dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    [string2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string2.length)];
//    self.name.attributedText = string2;
    
   NSString *str =  [friend.user.name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (str.length<1) {
        str = @"匿名用户";
    }
    self.name.text =str;
    
    NSString* time = friend.createTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:time];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    self.time.text = [formatter stringFromDate:date];
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithData:[friend.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.length)];
    self.content.attributedText =string;
    [self.zan setTitle:[NSString stringWithFormat:@"%ld",friend.upvote] forState:0];
    [self.ping setTitle:[NSString stringWithFormat:@"%ld",friend.cnt] forState:0];
    if (friend.isupvote) {
        [self.zan setImage:[UIImage imageNamed:@"点赞效果-1"] forState:0];
    }
    else
    {
        [self.zan setImage:[UIImage imageNamed:@"点赞-1"] forState:0];
    }
    
    
    NineSquareModel *model = [[NineSquareModel alloc] init];
    model.urlArr = [NSMutableArray array];
    NSInteger MaxIndex = friend.images.count-1;
    for (int i =0;i<friend.images.count ;i++ ) {
        UIImageView* imV = self.images[i];
        NSString* img = friend.images[i];
        
        
        [imV sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"well_default_banner"]];
        NineSquareUrlModel *urlModel = [[NineSquareUrlModel alloc] init];
        urlModel.url = img;
        [model.urlArr addObject:urlModel];
        
    }
    self.squareM = model;
    CGFloat sqW = (ScreenW-40-56-20)*1.0/3;
    if (friend.images.count*1.0/3<=1) {
        for (NSLayoutConstraint* constraint in self.imagesH) {
            if ([self.imagesH indexOfObject:constraint]<3) {
                constraint.constant = sqW;
            }
            else
            {
                constraint.constant = 0;
            }
            self.LineOneSegue.constant = 10;
            self.LineTwoSegue.constant = 0;
            self.LineThreeSegue.constant = 0;
        }
    }
    else if(friend.images.count*1.0/3 > 1 &&friend.images.count*1.0/3<=2)
    {
        for (NSLayoutConstraint* constraint in self.imagesH) {
            if ([self.imagesH indexOfObject:constraint]<6) {
                constraint.constant = sqW;
            }
            else
            {
                constraint.constant = 0;
            }
            self.LineOneSegue.constant = 10;
            self.LineTwoSegue.constant = 10;
            self.LineThreeSegue.constant = 0;
        }
    }
    else
    {
        for (NSLayoutConstraint* constraint in self.imagesH) {
            constraint.constant = sqW;
            self.LineOneSegue.constant = 10;
            self.LineTwoSegue.constant = 10;
            self.LineThreeSegue.constant = 10;

        }
    }
    
    
    if (friend.images.count == 0) {
        for (NSLayoutConstraint* constraint in self.imagesH) {
            constraint.constant = 0;
            self.LineOneSegue.constant = 0;
            self.LineTwoSegue.constant = 0;
            self.LineThreeSegue.constant = 0;
        }
    }
    

    
    for (UIImageView* im in self.images) {
        if ([self.images indexOfObject:im]>MaxIndex) {
            im.hidden=YES;
        }
        else
        {
            im.hidden=NO;
        }
    }

    
    
    
    
}

//- (void)imageViewIBAction2:(UITapGestureRecognizer *)tap{
//    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
//    NSArray *imageArray = [NSArray arr];
//    photoBrower.itemsArr = [self.itemsArr copy];
//    photoBrower.currentIndex = [self.images indexOfObject:tap.view
//                                ];
//    [photoBrower present];
//
//    [photoBrower setDelegate:self];
//}



//- (IBAction)CommentAct:(id)sender {
//    YSWCoomentTableViewController* pushVc = [YSWCoomentTableViewController new];
//    pushVc.hidesBottomBarWhenPushed = YES;
//    UINavigationController* na = self.viewController;
//    [na pushViewController:pushVc animated:YES ];
//}
- (void)setSquareM:(NineSquareModel *)squareM{
    _squareM = squareM;
    
    
    self.itemsArr = [NSMutableArray array];
    [self settingData];
}
- (void)settingData{
    
   

    for (NSInteger i = 0; i < _squareM.urlArr.count; i++) {
        UIImageView *imageView = [self.images objectAtIndex:i];

        NineSquareUrlModel *urlModel = [_squareM.urlArr objectAtIndex:i];

        [imageView sd_setImageWithURL:[NSURL URLWithString:urlModel.url] placeholderImage:[UIImage imageNamed:@"well_default_banner"]];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewIBAction:)]];
        /****************************** == 添加 控件和url == ********************************/

        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.sourceView = imageView;
        [self.itemsArr addObject:items];
    }
    

}
- (void)imageViewIBAction:(UITapGestureRecognizer *)tap{
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    photoBrower.itemsArr = [self.itemsArr copy];
    photoBrower.currentIndex = [self.images indexOfObject:tap.view
                                ];
    [photoBrower present];
    
    [photoBrower setDelegate:self];
}

/****************************** == 代理方法 == ********************************/
/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index{
    NSLog(@"operation:%zd",index);
}


/**
 *  删除当前图片
 *
 *  @param index 相对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index{
    NSLog(@"delete-Relative:%zd",index);
}

/**
 *  删除当前图片
 *
 *  @param index 绝对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index{
    NSLog(@"delete-Absolute:%zd",index);
}

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success{
    NSLog(@"saveImage:%zd",success);
}
//对应的vc
- (UIViewController *)viewController {
    id target=self.superview.superview;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UINavigationController class]]) {
            break;
        }
    }
    return target;
}
- (IBAction)upvote:(id)sender {
}

@end
