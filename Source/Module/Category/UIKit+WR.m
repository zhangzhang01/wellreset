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
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.clipsToBounds =YES;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.clipsToBounds =YES;
    }
    return self;
}
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
+(instancetype)wr_AttributedWithColorRange:(NSRange)colorRange Color:(UIColor*)color FontRange:(NSRange)fontRange Font:(UIFont*)font InitTitle:(NSString*)initTitle
{
    UILabel * labal = [UILabel new];
    NSMutableAttributedString *atti = [[NSMutableAttributedString alloc] initWithString: initTitle];
    if (color) {
    [atti addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
    }
    if (font) {
    [atti addAttribute:NSFontAttributeName value:font range:fontRange];
    }
    
    labal.attributedText = atti;
    return labal;
}
+(instancetype)wr_AttributedWithColorRange:(NSRange)colorRange Color:(UIColor*)color InintTitle:(NSString*)InitTitle
{
    return  [UILabel wr_AttributedWithColorRange:colorRange Color:color FontRange:NSMakeRange(0, 0) Font:nil InitTitle:InitTitle];
}
+(instancetype)wr_AttributedWithFontRange:(NSRange)fontRange Font:(UIFont*)font InitTitle:(NSString*)initTitle
{
    return [UILabel wr_AttributedWithColorRange:NSMakeRange(0, 0) Color:nil FontRange:fontRange Font:font InitTitle:initTitle];
}
-(void)setWr_AttributedWithColorRange:(NSRange)colorRange Color:(UIColor*)color FontRange:(NSRange)fontRange Font:(UIFont*)font InitTitle:(NSString*)initTitle
{
    
    NSMutableAttributedString *atti = [[NSMutableAttributedString alloc] initWithString: initTitle];
    if (color) {
        [atti addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
    }
    if (font) {
        [atti addAttribute:NSFontAttributeName value:font range:fontRange];
    }
    
    self.attributedText = atti;
}
-(void)setWr_AttributedWithColorRange:(NSRange)colorRange Color:(UIColor*)color InintTitle:(NSString*)InitTitle
{
      [self setWr_AttributedWithColorRange:colorRange Color:color FontRange:NSMakeRange(0, 0) Font:nil InitTitle:InitTitle];
}
-(void)setWr_AttributedWithFontRange:(NSRange)fontRange Font:(UIFont*)font InitTitle:(NSString*)initTitle
{
     [self setWr_AttributedWithColorRange:NSMakeRange(0, 0) Color:nil FontRange:fontRange Font:font InitTitle:initTitle];
}
@end

