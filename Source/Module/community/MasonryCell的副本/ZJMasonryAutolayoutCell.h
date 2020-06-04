//
//  ZJMasonryAutolayoutCell.h
//  ZJUIKit
//
//  Created by dzj on 2018/1/26.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJCommitPhotoView.h"
/**
 *  定义选择的block方法
 */
typedef void (^zanBlock)(NSInteger index);
typedef void (^pinglunBlock)(NSInteger index);
@class ZJCommit;

@interface ZJMasonryAutolayoutCell : UITableViewCell

@property(nonatomic ,strong) ZJCommit           *model;
@property(nonatomic ,strong) WRCOMArticle           *Articlemodel;

@property(nonatomic ,weak) UIViewController *selfVc;
@property(nonatomic ,weak) UIViewController      *weakSelf;
//赞
@property(nonatomic ,strong) zanBlock block;
//评论
@property(nonatomic ,strong) pinglunBlock pingblock;
// 昵称
@property(nonatomic ,strong) UILabel        *nameLab;
// 头像
@property(nonatomic ,strong) UIImageView    *avatar;


// 头像
@property(nonatomic ,strong) UIImageView    *vipStar;

// 时间
@property(nonatomic ,strong) UILabel        *timeLab;

// 时间
@property(nonatomic ,strong) UILabel        *timeLab2;

// 内容
@property(nonatomic ,strong) UILabel        *contentLab;
// 图片
@property(nonatomic ,strong) ZJCommitPhotoView *   photosView;


// 评论
@property(nonatomic ,strong) UIButton         *ping;

// 赞
@property(nonatomic ,strong) UIButton         *zan;

// 分割线
@property(nonatomic ,strong) UIView         *line;
// 评论列表
@property (nonatomic, strong) WRCOMArticle  *commentTable;
@end
