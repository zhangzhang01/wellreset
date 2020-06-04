//
//  CategoryView.h
//  rehab
//
//  Created by herson on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryView : UIView

@property(nonatomic, copy) void(^itemAction)(NSUInteger index, NSString* title);


-(instancetype)initWithFrame:(CGRect)frame
                      titles:(NSArray<NSString*>*)titleArray
                       icons:(NSArray<NSString*>*)iconNameArray
                     itemWidth:(CGFloat)itemWidth
                     itemHeight:(CGFloat)itemHeight;

@end
