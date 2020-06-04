//
//  WRSlider.m
//  rehab
//
//  Created by Matech on 4/1/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRSlider.h"

@implementation WRSlider

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setThumbImage:[UIImage imageNamed:@"well_slider_track"] forState:UIControlStateNormal];
        [self setThumbImage:[UIImage imageNamed:@"well_slider_track_focus"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGRect t = [self trackRectForBounds: [self bounds]];
    float v = [self minimumValue] + ([[touches anyObject] locationInView: self].x - t.origin.x - 4.0) * (([self maximumValue]-[self minimumValue]) / (t.size.width - 8.0));
    [self setValue: v];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [super touchesBegan: touches withEvent: event];
}

//Method to be called to set gradient color to slider bar.
-(void)setGradientWithColors:(NSArray*)colorArray
{
    UISlider *slider = self;
    UIView *view=(UIView*)[slider.subviews objectAtIndex:0];
    UIImageView *max_trackImageView=(UIImageView*)[view.subviews objectAtIndex:0];
    
    //setting gradient to max track image view.
    
    CAGradientLayer* max_trackGradient = [CAGradientLayer layer];
    
    CGRect rect=max_trackImageView.frame;
    rect.origin.x=view.frame.origin.x;
    
    max_trackGradient.frame=rect;
    max_trackGradient.colors = colorArray;
    
    [max_trackGradient setStartPoint:CGPointMake(0.0, 0.5)];
    [max_trackGradient setEndPoint:CGPointMake(1.0, 0.5)];
    
    [view.layer setCornerRadius:5.0];
    [max_trackImageView.layer insertSublayer:max_trackGradient atIndex:0];
    
    
    //Setting gradient to min track ImageView.
    
    CAGradientLayer* min_trackGradient = [CAGradientLayer layer];
    UIImageView *min_trackImageView=(UIImageView*)[slider.subviews objectAtIndex:1];
    
    rect=min_trackImageView.frame;
    rect.size.width = max_trackImageView.frame.size.width;
    rect.origin.y = 0;
    rect.origin.x = 0;
    
    min_trackGradient.frame = rect;
    min_trackGradient.colors = colorArray;
    [min_trackGradient setStartPoint:CGPointMake(0.0, 0.5)];
    [min_trackGradient setEndPoint:CGPointMake(1.0, 0.5)];
    
    [min_trackImageView.layer setCornerRadius:5.0];
    [min_trackImageView.layer insertSublayer:min_trackGradient atIndex:0];
}

@end
