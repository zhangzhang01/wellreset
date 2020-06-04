//
//  TagLabel.h
//  rehab
//
//  Created by yefangyang on 2016/12/15.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WRProTreatAnswer;
@interface TagLabel : UILabel
@property (nonatomic, strong) WRProTreatAnswer *treatAnswer;

@property (nonatomic, assign) BOOL selected;

@end
