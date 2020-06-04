//
//  HomeSubPageView.h
//  rehab
//
//  Created by herson on 2016/9/23.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeSubPageView : UIView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titleArray images:(NSArray<NSString*>*)imageArray holderImage:(UIImage*)holderImage title:(NSString*)title icon:(NSString*)icon isLeft:(BOOL)isLeft enableArray:(NSMutableArray *)enableArray;

@property(nonatomic, copy)void(^itemClickEvent)(UIImageView* sender);
@property(nonatomic, copy)void(^moreEvent)();

@property(nonatomic)UIView *alphaView;

@end
