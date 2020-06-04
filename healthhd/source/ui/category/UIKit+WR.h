//
//  UIKit+WR.h
//  rehab
//
//  Created by Matech on 4/27/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIColor+WR.h"
#import "UIFont+WR.h"
#import "UIView+WR.h"
#import "UIButton+WR.h"
#import "UITextField+WR.h"
#import "UIViewController+WR.h"

@interface UIImageView(WR)

-(void)setImageWithUrlString:(NSString*)url holder:(NSString*)imageName;
-(void)setImageWithUrlString:(NSString*)url holderImage:(UIImage*)image;

@end


@interface UILabel(WR)
-(CGSize)wr_virtualSize;
@end
