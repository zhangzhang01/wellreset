//
//  UIKit+WR.m
//  rehab
//
//  Created by Matech on 4/27/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "UIKit+WR.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"

@implementation UIImageView(WR)

-(void)setImageWithUrlString:(NSString*)url holderImage:(UIImage*)image {
    __weak __typeof(self) weakSelf = self;
    [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                placeholderImage:image
                         success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        UIImageView *strongImageView = weakSelf; // make local strong reference to protect against race conditions
        if (!strongImageView) return;
        
        [UIView transitionWithView:strongImageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            strongImageView.image = image;
                        }
                        completion:NULL];
    } failure:nil];
}

-(void)setImageWithUrlString:(NSString*)url holder:(NSString *)imageName {
    UIImage *holder;
    if (imageName) {
        holder = [UIImage imageNamed:imageName];
    }
    [self setImageWithUrlString:url holderImage:holder];
}

@end


@implementation UILabel (WR)

-(CGSize)wr_virtualSize
{
    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

@end

