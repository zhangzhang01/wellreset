//
//  UIImage+WR.h
//  rehab
//
//  Created by herson on 2016/11/24.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(WR)

-(CGFloat)scaleHeightForWidth:(CGFloat)cx;
-(CGFloat)scaleWidthForHeight:(CGFloat)cy;
- (UIImage *)fixOrientation:(UIImage *)aImage;
@end
