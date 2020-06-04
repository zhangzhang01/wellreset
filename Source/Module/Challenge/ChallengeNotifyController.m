//
//  ChallengeNotifyController.m
//  rehab
//
//  Created by 何寻 on 2016/12/2.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "ChallengeNotifyController.h"
#import <YYKit/YYKit.h>
#import "WRObject.h"

@interface ChallengeNotifyController ()

@end

@implementation ChallengeNotifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setData:(id)data
{
    WRTreatRehabStage *stage = data;
    
    [self.scrollView removeAllSubviews];
    
    UIView *container = self.scrollView;
    
    CGFloat offset = WRUIOffset, x = 0, y = x + 20;
    
    UIView *panel = [self createNotesPanelWithTitle:NSLocalizedString(@"目标", nil) notes:@[stage.explanation] maxWidth:container.frame.size.width];
    panel.top = y;
    [container addSubview:panel];
    y = panel.bottom + offset;
    
    panel = [self createNotesPanelWithTitle:NSLocalizedString(@"注意", nil) notes:@[stage.harm] maxWidth:container.frame.size.width];
    panel.top = y;
    [container addSubview:panel];
    y = panel.bottom + offset;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, y);
}

#pragma mark -
-(UIView*)createPointView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.width/2;
    return view;
}

-(UIView*)createNotesPanelWithTitle:(NSString*)title notes:(NSArray<NSString*>*)notes maxWidth:(CGFloat)maxWidth
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 0)];
    UILabel *label;
    CGFloat offset = WRUIOffset, x = offset, y = 0, cx = container.width - 2*x, cy;
    CGSize size;
    CGFloat pointYOffset = 3, pointXOffset = 5;
    
    BOOL iPad = [WRUIConfig IsHDApp];
    
    UIFont *subTitleFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_smallFont];
    UIFont *textFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_smallFont];
    UIColor *subTitleColor = [UIColor blackColor];
    UIColor *textColor = [UIColor darkGrayColor];
    UIColor *lineColor = [UIColor lightGrayColor];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
    label.textColor = subTitleColor;
    label.text = title;
    label.font = subTitleFont;
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:x y:y];
    [container addSubview:label];
    y = label.bottom + offset;
    
    for(NSString *text in notes)
    {
        UIView *point = [self createPointView];
        [container addSubview:point];
        point.left = offset;
        point.top = y + pointYOffset;
        
        x = point.right + pointXOffset;
        label = [[UILabel alloc] init];
        label.textColor = textColor;
        label.text = text;
        label.font = textFont;
        label.numberOfLines = 0;
        size = [label sizeThatFits:CGSizeMake(container.width - x - offset, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y, size.width, size.height);
        [container addSubview:label];
        y = label.bottom + offset;
    }
    x = offset;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, container.width - 2*x, 1)];
    lineView.backgroundColor = lineColor;
    [container addSubview:lineView];
    y = lineView.bottom;
    container.height = y;
    return container;
}
@end
