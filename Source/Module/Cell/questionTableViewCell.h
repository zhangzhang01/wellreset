//
//  questionTableViewCell.h
//  rehab
//
//  Created by matech on 2019/5/31.
//  Copyright © 2019 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface questionTableViewCell : UITableViewCell
@property(nonatomic, strong) UIImageView *titleImageV;
@property(nonatomic, strong) UILabel *titleLabel, *contentLab, *wellLab;
// 分割线
@property(nonatomic ,strong) UIView         *line;
@property(nonatomic ,weak) UIViewController      *weakSelf;
-(void)setValueWithTitle:(NSString *)title withDetail:(NSString *)detail;

///未展开时的高度
+ (CGFloat)cellDefaultHeight:(NSString *)entity;
///展开后的高度
+(CGFloat)cellMoreHeight:(NSString *)entity;
@end

NS_ASSUME_NONNULL_END
