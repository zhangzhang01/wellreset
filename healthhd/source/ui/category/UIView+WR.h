//
//  UIView+WR.h
//  rehab
//
//  Created by Matech on 3/4/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(WR)

-(void)wr_roundBorder;
-(void)wr_roundBorderWithColor:(UIColor*)borderColor;
-(void)wr_setShadow;
-(void)wr_move:(CGFloat)x y:(CGFloat)y;
-(void)wr_resize:(CGFloat)cx cy:(CGFloat)cy;

@end
