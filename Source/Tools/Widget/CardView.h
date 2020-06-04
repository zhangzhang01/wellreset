//
//  CardView.h
//  rehab
//
//  Created by herson on 7/19/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property(nonatomic) CGFloat cornerRadius;
@property(nonatomic) CGFloat shadowOffsetWidth, shadowOffsetHeight;

@property(nonatomic) UIColor *shadowColor;
@property(nonatomic) float shadowOpacity;

@end
