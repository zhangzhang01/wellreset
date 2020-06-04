//
//  WRSheetView.h
//  rehab
//
//  Created by Matech on 3/16/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WRSheetViewCompletion)();

@interface WRSheetView : UIView

@property(nonatomic, copy) WRSheetViewCompletion completion;
@property(nonatomic, weak, readonly) UIButton *leftButton, *rightButton;

-(instancetype)initWithCustomView:(UIView*)view;
-(void)show;
-(void)dismiss;

+(void)showWithCustomView:(UIView*)customView completion:(void (^)())completion;

@end
