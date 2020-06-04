//
//  WRProTreatQuestionCell.h
//  rehab
//
//  Created by 何寻 on 16/4/11.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRProTreatQuestionCell : UITableViewCell

@property (nonatomic, strong) NSObject *model;

@property(nonatomic, weak) UILabel *contentLabel;

@end


@interface WRProTreatQuestionTitleCell : UITableViewCell

@property (nonatomic, strong) NSObject *model;

@property(nonatomic, weak) UILabel *contentLabel;

@end