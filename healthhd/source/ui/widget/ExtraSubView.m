//
//  ExtraSubView.m
//  rehab
//
//  Created by 何寻 on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ExtraSubView.h"

@implementation ExtraSubView

-(instancetype)initWithFrame:(CGRect)frame
                       title:(NSString*)title
                  infoString:(NSString*)infoString
                   textAlign:(NSTextAlignment)textAlign
                    autoSize:(BOOL)autoSize
{
    if (self = [super initWithFrame:frame]) {
        self.infoColor = [UIColor wr_themeColor];
        self.infoFont = [[UIFont wr_titleFont] fontWithBold];
        self.unitString = infoString;
        
        UIFont *font = [UIFont wr_smallFont];
        UILabel *label;
        CGFloat cy = 0;
        
        label = [[UILabel alloc] init];
        label.font = font;
        label.textColor = [UIColor grayColor];
        label.numberOfLines = 1;
        label.text = title;
        label.textAlignment = textAlign;
        if (cy == 0) {
            CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
            cy = size.height;
        }
        label.frame = CGRectMake(0, 0, frame.size.width, cy);
        [self addSubview:label];
        self.titleLabel = label;
        
        label = [[UILabel alloc] init];
        label.font = font;
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 1;
        label.text = infoString;
        label.textAlignment = textAlign;
        CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        label.frame = CGRectMake(0, self.titleLabel.bottom + WRUILittleOffset, self.titleLabel.width, size.height);
        [self addSubview:label];
        self.infoLabel = label;
        
        if (autoSize) {
            self.frame = [Utility resizeRect:frame cx:-1 height:self.infoLabel.bottom];
        }
    }
    return self;
}

-(void)setInfo:(NSString *)info
{
    NSDictionary *dict = @{
                           NSFontAttributeName:self.infoFont,
                           NSForegroundColorAttributeName:self.infoColor
                           };
  
    NSString *text = [NSString stringWithFormat:@"%@%@", info, self.unitString];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:info];
    [string addAttributes:dict range:range];
    self.infoLabel.attributedText = string;
}

@end
