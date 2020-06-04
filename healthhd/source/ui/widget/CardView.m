//
//  CardView.m
//  rehab
//
//  Created by 何寻 on 7/19/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "CardView.h"

@implementation CardView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cornerRadius = 3;
        self.shadowOffsetHeight = 1;
        self.shadowColor = [UIColor grayColor];
        self.shadowOpacity = 0.5f;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.cornerRadius;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:(CGRect)self.bounds cornerRadius:self.cornerRadius];
    
    self.layer.masksToBounds = false;
    self.layer.shadowColor = self.shadowColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(self.shadowOffsetWidth, self.shadowOffsetHeight);
    self.layer.shadowOpacity = self.shadowOpacity;
    self.layer.shadowPath = shadowPath.CGPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
