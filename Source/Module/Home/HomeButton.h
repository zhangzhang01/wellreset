//
//  HomeButton.h
//  rehab
//
//  Created by yefangyang on 2016/11/14.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeButton : UIButton
@property (nonatomic, assign) NSInteger index, amount, radius;
- (void)setUpBezierPath;
- (instancetype)initWithImage:(NSString *)image title:(NSString *)title superView: (UIView *)superView amount:(NSInteger)amount index:(NSInteger)index;
@end
