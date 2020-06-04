//
//  WRZanButton.m
//  rehab
//
//  Created by Matech on 4/6/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRZanButton.h"

const CGFloat WRZanButtonMargin = 5;

@implementation WRZanButton

-(void) sizeToFit {
    const CGFloat offset = WRZanButtonMargin;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat cx = 0;
    UIImage *image = [self imageForState:UIControlStateNormal];
    if (image) {
        cx += image.size.width + offset;
    }
    cx += size.width + 2*offset;
    CGFloat cy = MAX(image.size.height, size.height) + 2*offset;
    self.frame = [Utility resizeRect:self.frame cx:cx height:cy];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    const CGFloat offset = WRZanButtonMargin;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat x = offset, y = 0;
    CGFloat contentWidth = 0;
    
    UIImage *image = [self imageForState:UIControlStateNormal];
    if (image) {
        contentWidth += image.size.width + offset;
    }
    contentWidth += size.width;
    x = (bounds.size.width - contentWidth)/2;
    if (image) {
        y = (bounds.size.height - image.size.height) /2;
        self.imageView.frame = CGRectMake(x, y, image.size.width, image.size.height);
        x = CGRectGetMaxX(self.imageView.frame) + offset;
    }
    CGFloat cx = bounds.size.width - offset - x;
    y = (bounds.size.height - size.height)/2;
    self.titleLabel.frame = CGRectMake(x, y, cx, size.height);
}

@end
