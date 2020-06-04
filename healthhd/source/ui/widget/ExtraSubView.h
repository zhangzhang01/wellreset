//
//  ExtraSubView.h
//  rehab
//
//  Created by 何寻 on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtraSubView : UIView

-(instancetype)initWithFrame:(CGRect)frame
                       title:(NSString*)title
                  infoString:(NSString*)infoString
                   textAlign:(NSTextAlignment)textAlign
                    autoSize:(BOOL)autoSize;
-(void)setInfo:(NSString *)info;

@property(nonatomic) UILabel *titleLabel, *infoLabel;
@property(nonatomic) UIColor *infoColor;
@property(nonatomic) UIFont *infoFont;
@property(nonatomic, copy) NSString *unitString;
@end
