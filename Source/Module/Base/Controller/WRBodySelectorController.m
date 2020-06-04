//
//  WRBodySelectorController.m
//  rehab
//
//  Created by Matech on 3/22/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRBodySelectorController.h"
#import "RehabObject.h"
#import "RehabObject.h"
#import "ShareData.h"
#import "JCAlertView.h"
#import "GuideCoverViewController.h"
#import <YYKit/YYKit.h>
#import "TreatDiseaseController.h"
@interface WRBodySelectorController()
{
    NSArray *_codeArray, *_descArray, *_innerViewCodeArray;
    NSMutableArray *_buttonArray;
    NSMutableDictionary *_tipsViewDict;
    NSDate* _startDate;
    NSMutableArray *_selectedArray;
}
@property (nonatomic) UIButton* currentTip;
@property (nonatomic) NSArray* choosearry;
@property (nonatomic) NSArray* detail;
@property (nonatomic) NSString* firstchoose;
@property (nonatomic) UIButton* nextBtn;
@property (nonatomic) NSString* pamar;
@end

@implementation WRBodySelectorController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    
    
    _buttonArray = [NSMutableArray array];
    _tipsViewDict = [NSMutableDictionary dictionary];
    
   
    
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view removeAllSubviews];
    BOOL biPad = [WRUIConfig IsHDApp];
    [super viewWillAppear:animated];
    _startDate = [NSDate date];
    self.title = NSLocalizedString(@"基本信息（2／4)", nil);
    CGFloat x, y, cx = 0, cy = 0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.width, self.view.height-43-40-64-50)];
    scrollView = scrollView;
    scrollView.backgroundColor = [UIColor wr_bgColor];
    [self.view addSubview:scrollView];
    const CGFloat baseScale = 3;
    CGFloat ratio = biPad ? 2 : 1;
    ratio = iPhone5 ? 0.8:1;
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
    y = 50;
    bodyView.frame = CGRectMake(x, y, cx, cy);
    [scrollView addSubview:bodyView];
    scrollView.contentSize = CGSizeMake(image.size.width,image.size.height+ 50);
    scrollView.scrollEnabled =YES;
    
    _innerViewCodeArray = @[@"lumbar", @"foot",@"thigh",@"knee"];
    NSArray *xVals;
    NSArray *yVals;
    if (!self.isadd) {
        _codeArray = @[
                       @"neck", @"shoulder",
                       @"lumbar",
                       /*@"lowback", @"lowback",*/  @"elbow",
                       @"hip",
                       @"thigh",
                       @"foot"
                       ];
        
        _descArray = @[
                       @"颈椎", @"肩部",
                       @"腰部",
                       /*@"骶髂关节", @"骶髂关节", */ @"肘部",
                       @"手部",
                       @"下肢",
                       @"足部",
                       ];
        xVals = @[
                  @(297), @(428),
                  @(306),
                  /*@(230), @(382),*/ @(508),
                  @(590),
                  @(210),
                  @(200),
                  ];
        yVals = @[
                  @(1200), @(1100),
                  @(875),
                  /*@(786),@(786),*/ @(872),
                  @(680),
                  @(330),
                  @(100),
                  ];
        
    }
    else
    {
        self.title = NSLocalizedString(@"选择康复部位", nil);
        _codeArray = @[
                       @"neck", @"shoulder",
                       @"lumbar",
                       /*@"lowback", @"lowback",*/
                       @"hip",
                       @"thigh"
                       
                       ];
        
        _descArray = @[
                       @"颈椎", @"肩部",
                       @"腰部",
                       /*@"骶髂关节", @"骶髂关节", */
                       @"上肢",
                       @"下肢"
                       
                       ];
        xVals = @[
                  @(297), @(428),
                  @(306),
                  /*@(230), @(382),*/
                  @(590),
                  @(210)
                  
                  ];
        yVals = @[
                  @(1200), @(1100),
                  @(875),
                  /*@(786),@(786),*/
                  @(680),
                  @(330)
                  
                  ];
        
    }
    CGFloat circleR = 50*ratio;
    //CGFloat x0 = imageView.frame.origin.x, y0 = imageView.frame.origin.y;
    CGFloat x0 = 0, y0 = 0;
    CGFloat cy0 = bodyView.frame.size.height;
    
    for (NSUInteger index = 0; index < xVals.count; index++) {
        CGFloat x = [xVals[index] floatValue]*ratio/(baseScale);
        CGFloat y = [yVals[index] floatValue]*ratio/(baseScale);
        
        y = y0 + cy0 - y;
        
        UIButton *button = [UIButton wr_lineBorderButtonWithTitle:nil normalColor:[[UIColor whiteColor]colorWithAlphaComponent:0.4 ] highLightColor:[[UIColor wr_themeColor]colorWithAlphaComponent:0.4 ]];
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
    
    
    UILabel* content = [UILabel new];
    content.text = NSLocalizedString(@"请对照下图，选择您需要康复锻炼的部位。", nil);
    content.font = [UIFont systemFontOfSize:WRDetailFont];
    content.textColor = [UIColor grayColor];
    [content sizeToFit];
    content.y = WRUIBigOffset;
    content.centerX = self.view.centerX;
    [self.view addSubview:content];
    
    UIButton*  nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, YYScreenSize().height-43-40-64, 281, 43)];
    [nextBtn setTitle:NSLocalizedString(@"下一步",nil) forState:0];
    [nextBtn setBackgroundColor:[UIColor wr_buttonDeffaultColor]];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:WRBigButtonFont];
    self.nextBtn = nextBtn;
    self.nextBtn.enabled =NO;
    nextBtn.centerX = self.view.centerX;
    
    
    [self.view addSubview:nextBtn];
    [self.nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)next
{
    if (self.choosearry) {
        
        GuideCoverViewController* gVc =[GuideCoverViewController new];
        gVc.body = _descArray[self.currentTip.tag];
        
        switch (self.currentTip.tag) {
            case 0:
            {
                //锚点
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"jingbu"] attributes:nil counter:duration];            }
                break;
            case 1:
            {
                //锚点
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"jianbu"] attributes:nil counter:duration];            }
                break;
            case 2:
            {
                //锚点
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"yaobu"] attributes:nil counter:duration];            }
                break;
            case 3:
            {
                //锚点
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"shouzhou"] attributes:nil counter:duration];
            }
                break;
            case 4:
            {
                //锚点
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"shouwan"] attributes:nil counter:duration];            }
                break;
            case 5:
            {
                //锚点
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"xigai"] attributes:nil counter:duration];            }
                break;
            case 6:
            {
                //锚点
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"jiaohuai"] attributes:nil counter:duration];
            }
                break;
           

                
                
            default:
                break;
        }
        if (!self.isadd) {
            gVc.titleArry = self.choosearry;
            gVc.detail = self.detail;
            gVc.fist = self.firstchoose;
            [self.navigationController pushViewController:gVc animated:YES];
        }
        else
        {
            TreatDiseaseController* tvc = [TreatDiseaseController new];
            tvc.title = self.pamar;
            tvc.XBParam = self.pamar;
            [self.navigationController pushViewController:tvc animated:YES];
        }
        
    }
}


#pragma mark - IBActions
-(IBAction)onClickedSelectButton:(UIButton*)sender{
    
    //清除选择信息
    self.currentTip.selected = NO;
    for(UIButton *button in _buttonArray){
        if (button != sender) {
            if([_codeArray[sender.tag] isEqualToString:_codeArray[button.tag]]){
                button.selected = NO;
            }
        }
    }
    [self removeTip:self.currentTip];

    __weak __typeof(self) weakSelf = self;
    UIView *sourceView = nil;
    CGRect sourceRect = CGRectZero;
    sourceView = sender.superview;
    sourceRect = sender.frame;
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
        self.currentTip = sender;
    }
    
    NSUInteger index = sender.tag;
    self.currentTip = sender;
    NSString *code = _codeArray[index];
    
    _codeArray = @[
                   @"neck", @"shoulder",
                   @"lumbar",
                   /*@"lowback", @"lowback",*/  @"elbow",
                   @"hip",
                   @"thigh",
                   @"foot"
                   ];
    if ([code isEqualToString:@"neck"])
    {
        self.pamar = @"颈部";
    self.choosearry = @[@"定制方案",@"颈椎疼痛",@"头痛"];
        self.detail = @[@"定制方案：\n根据您个人的情况定制具有针对性的锻炼方案。",@"颈椎：\n如果您有颈椎疼痛现象，这个方案可以帮您快速缓解哦。",@"头痛：\n如果您伴有头痛症状，这个方案可以帮您快速缓解哦。"];
        self.firstchoose = @"欢迎您使用颈部方案\n请选择适合您的方案。";
    }
    else if([code isEqualToString:@"shoulder"])
    {
        self.pamar = @"肩部";
    self.choosearry = @[@"定制方案",@"肩周炎",@"高低肩"];
        self.detail = @[@"定制方案：\n根据您个人的情况定制具有针对性的锻炼方案。",@"高低肩：\n如果您有高低肩症状，那么您应该试试这个方案。",@"肩周炎：\n如果您患有肩周炎，这个方案可以快速缓解疼痛哦。"];
        self.firstchoose = @"欢迎您使用肩部方案\n请选择适合您的方案。";
    }
    else if([code isEqualToString:@"lumbar"])
    {
        self.pamar = @"腰部";
    self.choosearry = @[@"定制方案",@"腰背疼痛",@"坐骨神经痛"];
        self.detail = @[@"定制方案：\n根据您个人的情况定制具有针对性的锻炼方案。",@"要背疼痛：\n如果您感觉腰背疼痛，这个方案可以帮您快速缓解哦。",@"坐骨神经痛：\n如果您有坐骨神经痛，这个方案可以帮您快速缓解哦。"];
        self.firstchoose = @"欢迎您使用腰部方案\n请选择适合您的方案。";
    }
    else if([code isEqualToString:@"elbow"])
    {
    self.choosearry = @[@"网球肘"];
        self.detail = @[@"手肘：\n如果您肘关节外侧疼痛，这个方案可以帮您快速缓解哦。"];
     self.firstchoose = @"欢迎您使用网球肘方案\nWELL健康真诚为您效劳。";
    }
    else if([code isEqualToString:@"hip"])
    {
        self.pamar = @"上肢";
    self.choosearry = @[@"鼠标手"];
        self.detail = @[@"鼠标手：\n如果你有手指麻木、疼痛等症状，那么您应该试试这个方案。"];
        self.firstchoose = @"欢迎您使用手部方案\nWELL健康真诚为您效劳。";
    }
    else if([code isEqualToString:@"thigh"])
    {
        self.pamar = @"下肢";
    self.choosearry = @[@"膝关节疼痛",@"O型腿",@"X型腿"];
        self.detail = @[@"膝关节：\n如果您有膝关节疼痛，这个方案可以帮您快速缓解哦。",@"O：\n助您纠正o型腿，美腿早日练成~",@"X：\n助您纠正x型腿，美腿早日练成~"];
        self.firstchoose = @"欢迎您使用腿部方案\nWELL健康真诚为您效劳。";
    }
    else if([code isEqualToString:@"foot"])
    {
    self.choosearry = @[@"扁平足"];
        self.detail = @[@"扁平足：\n如您有扁平足症状，这个方案能助您早日远离疼痛哦~"];
        self.firstchoose = @"欢迎您使用脚部方案\nWELL健康真诚为您效劳。";
    }

    self.nextBtn.backgroundColor = [UIColor wr_themeColor];
    self.nextBtn.enabled =YES;


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
    label.font = [WRUIConfig IsHDApp] ? [UIFont wr_textFont] : [UIFont systemFontOfSize:[UIFont systemFontSize]+1];
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
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(x , CGRectGetMidY(controlFrame) - label.frame.size.height/2-63, cx, cy+63)];
    tipView.clipsToBounds = YES;
    if (bInner) {
        tipView.right = controlFrame.origin.x+controlFrame.size.width/2.0;
        tipView.bottom = controlFrame.origin.y+controlFrame.size.height/2.0;
    }
    else
    {
    tipView.left = controlFrame.origin.x+controlFrame.size.width/2.0;
    tipView.bottom = controlFrame.origin.y+controlFrame.size.height/2.0;
    }
    
    
    CGFloat x0 = bInner ? (label.frame.size.width + offset)+3 : +54-3;
    CGFloat w = bInner ? tipView.frame.size.width - label.frame.size.width - offset-54 : tipView.frame.size.width - label.frame.size.width - offset-40+20;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x0, 30, w, 1)];
    lineView.backgroundColor = [UIColor wr_themeColor];
    [tipView addSubview:lineView];
    
    x0 = bInner ? 0 : tipView.frame.size.width - label.frame.size.width;
    
    

    
    label.frame = CGRectMake(x0, lineView.bottom+1, w, cy);
    [label sizeToFit];
    label.x += bInner ? 10:-10;
    [tipView addSubview:label];
    [_tipsViewDict setObject:tipView forKey:code];
    if (bInner) {
        label.left = lineView.left;
    }
    else
    {
        label.right = lineView.right;
    }
    
    
    CGFloat angle = M_PI*2.0*(1/8.0);
    float needAngle = angle - 0*M_PI_2;
    CGFloat  y = 50 - cosf(needAngle)*50;
    CGFloat  xsin = y;
    UIView *BlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 1)];
    
    
    BlineView.width -= 30;
    if (!bInner) {
        BlineView.x += 30;
    }
    BlineView.centerX = bInner ? (tipView.width-y+lineView.right)/2.0:(xsin+lineView.left)/2.0;
    BlineView.centerY = ( tipView.height-y+lineView.centerY )/2.0;
    
    
//    BlineView.centerX += 40;
//    BlineView.centerY += 40;
    BlineView.backgroundColor = [UIColor wr_themeColor];
    [tipView addSubview:BlineView];
    BlineView.transform = bInner? CGAffineTransformMakeRotation(M_PI_4):CGAffineTransformMakeRotation(-M_PI_4);
    tipView.alpha = 0;
    
    
    [containView addSubview:tipView];
    [containView bringSubviewToFront:fromButton];
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
                [self pushProTreatRehabWithDisease:disease stage:0 upgrade:@"0"];
            } else {
                [self pushTreatRehabWithDisease:disease isTreat:YES];
            }
        }
    }
}
@end
