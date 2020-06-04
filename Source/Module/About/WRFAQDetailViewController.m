//
//  WRFAQDetailViewController.m
//  health
//
//  Created by Matech on 4/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRFAQDetailViewController.h"
#import "WRObject.h"

@implementation WRFAQDetailViewController

-(instancetype)initWithFAQ:(id)faq {
    self = [super init];
    if (self) {

        BOOL biPad = [WRUIConfig IsHDApp];
        
        WRFAQ *faqInfo = faq;
        CGFloat offset = WRUIOffset,  x = offset, y = x, cx = self.scrollView.bounds.size.width - 2*x;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        label.text = faqInfo.question;
        label.font = biPad ? [UIFont wr_bigTitleFont] : [UIFont wr_titleFont];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        //CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        [self.scrollView addSubview:label];
        [label sizeToFit];
        label.frame = CGRectMake(offset, y, cx, label.frame.size.height);
        y = CGRectGetMaxY(label.frame) + offset;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        label.text = faqInfo.answer;
        label.font = biPad ? [UIFont wr_titleFont] : [UIFont wr_textFont];
        label.textColor = [UIColor grayColor];
        label.numberOfLines = 0;
        [self.scrollView addSubview:label];
        [label sizeToFit];
        y = CGRectGetMaxY(label.frame) + offset;
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, y);
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [WRNetworkService pwiki:@"FAQ详情"];
}

@end
