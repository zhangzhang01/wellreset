//
//  WRToolView.h
//  rehab
//
//  Created by Matech on 5/17/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRToolView : UIView

@property(nonatomic) UIButton *previousButton, *nextButton;
@property(nonatomic) UIButton *centerButton;
-(void)layout;
-(void)layoutw;
@end
