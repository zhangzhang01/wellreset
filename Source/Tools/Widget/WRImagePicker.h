//
//  WRImagePicker.h
//  rehab
//
//  Created by herson on 2016/10/8.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRImagePicker : NSObject

@property(nonatomic, copy)void(^completion)(UIImage* image);

-(instancetype)initWithController:(UIViewController*)sourceController targetSize:(CGSize)targetSize imageView:(UIImageView *)imageView;

-(void)show;

@end
