//
//  WRBodySelectorController.m
//  rehab
//
//  Created by Matech on 3/22/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRBodySelectorController.h"
#import "WRTreat.h"
#import "WRProTreat.h"
#import "ShareData.h"
#import "JCAlertView.h"

@interface WRBodySelectorController()
{
    NSArray *_codeArray, *_descArray, *_innerViewCodeArray;
    NSMutableArray *_buttonArray;
    NSMutableDictionary *_tipsViewDict;
    
    NSMutableArray *_selectedArray;
}

@end

@implementation WRBodySelectorController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    
    BOOL biPad = [WRUIConfig IsHDApp];
    _buttonArray = [NSMutableArray array];
    _tipsViewDict = [NSMutableDictionary dictionary];
 
    CGFloat x, y, cx = 0, cy = 0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView = scrollView;
    scrollView.backgroundColor = [UIColor wr_bgColor];
    [self.view addSubview:scrollView];
    const CGFloat baseScale = 3;
    CGFloat ratio = biPad ? 2 : 1;
    CGRect frame = scrollView.bounds;
    UIImage *image = [UIImage imageNamed:@"well_img_body"];
    if (ratio != 1) {
        image = [image imageByResizeToSize:CGSizeMake(image.size.width*ratio, image.size.height*ratio)];
    }
    UIView *bodyView = [[UIView alloc] init];
    bodyView.layer.contents = (id)image.CGImage;
    
    cx = image.size.width;
    cy = image.size.height;
    x = (frame.size.width - cx)/2;
    y = (frame.size.height - cy - 64)/2;
    bodyView.frame = CGRectMake(x, y, cx, cy);
    [scrollView addSubview:bodyView];
    
    _innerViewCodeArray = @[@"lumbar", @"hip"];
    
    _codeArray = @[
                      @"head", @"neck", @"shoulder", @"shoulder", @"scapular", @"scapular",
                      @"lumbar",
                      @"elbow", /*@"lowback", @"lowback",*/  @"elbow",
                      @"hand", @"hip", @"hand",
                      @"thigh", @"thigh",
                      @"foot", @"foot"
                      ];
    
    _descArray = @[
                      @"头部", @"颈部", @"肩部", @"肩部", @"肩胛", @"肩胛",
                      @"腰脊",
                      @"手肘", /*@"骶髂关节", @"骶髂关节", */ @"手肘",
                      @"手", @"臀部", @"手",
                      @"大腿", @"大腿",
                      @"足部", @"足部"
                      ];
    NSArray *xVals = @[
                       @(297), @(297), @(175), @(428), @(230), @(373),
                       @(306),
                       @(110), /*@(230), @(382),*/ @(508),
                       @(40), @(306), @(590),
                       @(230), @(392),
                       @(200), @(420)
                       ];
    NSArray *yVals = @[
                       @(1290), @(1200), @(1115), @(1125), @(1044), @(1044),
                       @(875),
                       @(849), /*@(786),@(786),*/ @(872),
                       @(675), @(728), @(680),
                       @(561), @(561),
                       @(100), @(100)
                       ];
    CGFloat circleR = 30*ratio;
    //CGFloat x0 = imageView.frame.origin.x, y0 = imageView.frame.origin.y;
    CGFloat x0 = 0, y0 = 0;
    CGFloat cy0 = bodyView.frame.size.height;
    
    for (NSUInteger index = 0; index < xVals.count; index++) {
        CGFloat x = [xVals[index] floatValue]*ratio/(baseScale);
        CGFloat y = [yVals[index] floatValue]*ratio/(baseScale);
        
        y = y0 + cy0 - y;
        
        UIButton *button = [UIButton wr_lineBorderButtonWithTitle:nil normalColor:[UIColor whiteColor] highLightColor:[UIColor wr_themeColor]];
        button.frame = CGRectMake(0, 0, circleR, circleR);
        button.layer.cornerRadius = circleR/2;
        button.layer.borderColor = [UIColor wr_themeColor].CGColor;
        [bodyView addSubview:button];
        button.center = CGPointMake(x0 + x, y0 + y);
        button.tag = index;
        [button addTarget:self action:@selector(onClickedSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonArray addObject:button];
    }
    [WRNetworkService pwiki:@"人体图"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"选择", nil);
}

#pragma mark - IBActions
-(IBAction)onClickedSelectButton:(UIButton*)sender{
    __weak __typeof(self) weakSelf = self;
    sender.selected = YES;
    for(UIButton *button in _buttonArray){
        if (button != sender) {
            if([_codeArray[sender.tag] isEqualToString:_codeArray[button.tag]]){
                button.selected = YES;
            }
        }
    }
    if (!sender.selected) {
        //[self removeTip:sender];
    } else {
        [self showTip:sender];
    }
    
    NSUInteger index = sender.tag;
    NSString *code = _codeArray[index];
    
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    [_selectedArray removeAllObjects];
    
    for(WRRehabDisease *disease in [ShareData data].proTreatDisease)
    {
        if ([disease.bodyCode rangeOfString:code].location != NSNotFound) {
            [_selectedArray addObject:disease];
        }
    }
    if (_selectedArray.count > 0) {
        [self actionWithDisease:_selectedArray.firstObject];
    } else {
        for(WRRehabDisease *disease in [ShareData data].treatDisease)
        {
            if ([disease.bodyCode rangeOfString:code].location != NSNotFound) {
                [_selectedArray addObject:disease];
            }
        }
        NSMutableArray *titleArray = [NSMutableArray array];
        [_selectedArray enumerateObjectsUsingBlock:^(WRRehabDisease*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titleArray addObject:obj.diseaseName];
        }];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请选择", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for(WRRehabDisease *disease in _selectedArray)
        {
            [alert addAction:[UIAlertAction actionWithTitle:disease.diseaseName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf actionWithDisease:disease];
            }]];
        }
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel  handler:nil]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}

-(void)showTip:(UIButton*)fromButton {

    NSUInteger index = fromButton.tag;
    NSString *code = _codeArray[index];
    if ([_tipsViewDict objectForKey:code]) {
        return;
    }
    BOOL bInner = NO;
    UIView *containView = fromButton.superview.superview;
    CGRect controlFrame = [fromButton.superview convertRect:fromButton.frame toView:containView];
    
    if ([_innerViewCodeArray containsObject:code])
    {
        bInner = YES;
    }
    else
    {
        if (CGRectGetMinX(controlFrame) < CGRectGetMidX(containView.bounds))
        {
            for(UIButton *button in _buttonArray)
            {
                if (button != fromButton)
                {
                    if([_codeArray[index] isEqualToString:_codeArray[button.tag]])
                    {
                        break;
                    }
                }
            }
        }
    }
    
    NSString *name = _descArray[index];
    UILabel *label = [[UILabel alloc] init];
    label.text = name;
    label.font = [WRUIConfig IsHDApp] ? [UIFont wr_textFont] : [UIFont wr_detailFont];
    label.textColor = [UIColor wr_themeColor];
    [label sizeToFit];
    
    CGFloat offset = WRUILittleOffset;
    CGFloat cx = containView.frame.size.width - CGRectGetMaxX(controlFrame) ;
    if (bInner) {
        cx = CGRectGetMinX(controlFrame);
    }
    cx -= - 2*offset;
    
    CGFloat cy = label.frame.size.height;
    CGFloat x = bInner ? (offset) : (containView.frame.size.width - cx - offset)  ;
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(x , CGRectGetMidY(controlFrame) - label.frame.size.height/2, cx, cy)];
    
    CGFloat x0 = bInner ? (label.frame.size.width + offset) : 0;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x0, CGRectGetMidY(tipView.bounds), tipView.frame.size.width - label.frame.size.width - offset, 1)];
    lineView.backgroundColor = [UIColor wr_themeColor];
    [tipView addSubview:lineView];
    
    x0 = bInner ? 0 : tipView.frame.size.width - label.frame.size.width;
    label.frame = CGRectMake(x0, 0, label.frame.size.width, cy);
    [tipView addSubview:label];
    [_tipsViewDict setObject:tipView forKey:code];
    
    tipView.alpha = 0;
    [containView addSubview:tipView];
    [containView sendSubviewToBack:tipView];
    [UIView animateWithDuration:0.5 animations:^{
        tipView.alpha = 1;
    }];
}

-(void)removeTip:(UIButton*)fromButton {
    NSUInteger index = fromButton.tag;
    NSString *code = _codeArray[index];
    UIView *tipView = [_tipsViewDict objectForKey:code];
    if (tipView) {
        [_tipsViewDict removeObjectForKey:code];
       [UIView animateWithDuration:0.5 animations:^{
           tipView.alpha = 0;
       } completion:^(BOOL finished) {
           [tipView removeFromSuperview];
       }];
    }
}

#pragma mark - 
-(void)actionWithDisease:(WRRehabDisease*)disease
{
    if (disease.state == DiseaseStateComming) {
        NSString *text = [NSString stringWithFormat:@"『%@』 %@", disease.diseaseName, NSLocalizedString(@"即将上线，敬请期待", nil)];
        [Utility alertWithViewController:self.navigationController title:text];
    } else {
        if ([self checkUserLogState:self.navigationController]) {
            if ([disease isPro]) {
                [self pushProTreatRehabWithDisease:disease stage:0];
            } else {
                [self pushTreatRehabWithDisease:disease isTreat:YES];
            }
        }
    }
}
@end
