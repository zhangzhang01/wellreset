//
//  QuestionDetailView.h
//  rehab
//
//  Created by yefangyang on 2016/12/15.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionDetailView : UIView
-(instancetype)initWithFrame:(CGRect)frame initWithProTreatQuestion:question selectedArray:selectedArray;

@property(nonatomic) UIImageView* lightImageView;
@property(nonatomic) UILabel *titleLabel, *detailLabel;

@property(nonatomic, copy) void(^click)(NSInteger index);
@property(nonatomic, copy) void(^completion)(NSArray<WRProTreatAnswer*> *answers);
@property(nonatomic, copy) BOOL (^beforeCompletion)(NSArray<WRProTreatAnswer*> *answers);
@end
