//
//  RehabFeedbackController.m
//  rehab
//
//  Created by Matech on 4/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "RehabFeedbackController.h"
#import "ProTreatViewModel.h"
#import "WRSlider.h"
#import "EFCircularSlider.h"
#import <YYKit/YYKit.h>
#import "CCHStepSizeSlider.h"
@interface RehabFeedbackController ()
{
    NSArray *_questionArray;
    NSMutableDictionary *_userAnswerDict;
    NSString *_proTreatRehabId;
    ProTreatFinishedState _finishedState;
    NSMutableArray *_sliderArray;
    UIImageView* center;
    UILabel* statela;
    NSMutableArray* arr;
    CCHStepSizeSlider* slider;
}
@end

@implementation RehabFeedbackController

-(instancetype)initWithQuestions:(NSArray *)questionArray proTreatRehabId:(NSString *)indexId finishedState:(ProTreatFinishedState)state {
    if (self = [super init]) {
        _proTreatRehabId = indexId;
        _sliderArray = [NSMutableArray array];
        _userAnswerDict = [NSMutableDictionary dictionary];
        _questionArray = questionArray;
        _finishedState = state;
        arr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"康复效果反馈", nil);
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    [WRNetworkService pwiki:@"康复效果反馈"];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.scrollView.frame = CGRectMake(24, 75+64, ScreenW-24*2, self.view.height-75-93-64);
    self.scrollView.layer.borderColor = [UIColor colorWithHexString:@"F1F1F1"].CGColor;
    self.scrollView.layer.borderWidth = 1;
    if (_sliderArray.count == 0) {
        [self layout];
    }
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(24, self.scrollView.bottom+38, ScreenW-24*2, 51)];
    btn.backgroundColor = [UIColor wr_themeColor];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn setTitle:@"确认" forState:0];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btn wr_roundBorder];
    [btn bk_whenTapped:^{
        
        [self onClickedSubmitButton:btn];
        
    }];
    [self.view addSubview:btn];

}

#pragma mark - IBActions
-(IBAction)onSliderValueChanged:(UISlider*)sender {
    WRProTreatRehabFeedbackQuestion *question = _questionArray[sender.tag];
    _userAnswerDict[question.indexId] = @((int)(sender.value));
}

-(IBAction)onClickedSubmitButton:(UIButton*)sender {
    
    
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:nil];
    [ProTreatViewModel userProTreatSubmitNewFeedbackWithCompletion:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        
        if (error) {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"反馈失败", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"重试", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf onClickedSubmitButton:sender];
            }]];
            [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf close];
            }]];
            [weakSelf presentViewController:controller animated:YES completion:nil];
        } else {
            [weakSelf close];
        }
    } answers:arr pain:[NSString stringWithFormat:@"%.0f",slider.value*10] rehabid:self.rehab.indexId];
}

#pragma mark - 
-(void)layout {
    [self.scrollView removeAllSubviews];
    
    UIView *container = self.scrollView;
    CGRect frame = container.bounds;
    CGFloat offset = WRUIOffset,  x = offset, y = x, cx = 0;
    NSInteger tag = 0;
    for(WRProTreatRehabFeedbackQuestion *question in _questionArray) {
        x = offset;
        cx = frame.size.width - 2*x;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        label.text = [NSString stringWithFormat:@"%d. %@", (int)(tag + 1), question.question];
        label.font = [UIFont wr_tinyFont];
        label.textColor = [UIColor darkGrayColor];
        label.numberOfLines = 0;
        [label sizeToFit];
//        [container addSubview:label];
        y = CGRectGetMaxY(label.frame) + offset;
        
        /*
        UISlider *slider = [[WRSlider alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        slider.tag = tag;
        slider.maximumValue = question.maxValue;
        slider.minimumValue = question.minValue;
        [slider sizeToFit];
        slider.frame = [Utility resizeRect:slider.frame cx:cx height:-1];
        [slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
         */
        cx = 120;
        x = (frame.size.width - cx)/2;
        EFCircularSlider *slider = [[EFCircularSlider alloc] initWithFrame:CGRectMake(x, y, cx, cx)];
        slider.tag = tag;
        slider.maximumValue = question.maxValue;
        slider.minimumValue = question.minValue;
        slider.currentValue = slider.minimumValue;
        slider.labelFont = [[UIFont wr_bigTitleFont] fontWithBold];
        slider.handleType = semiTransparentWhiteCircle;
        slider.filledColor = [UIColor wr_themeColor];
        slider.unfilledColor = [UIColor wr_lightGray];
        slider.labelColor = [UIColor wr_themeColor];
        slider.handleColor = [UIColor orangeColor];
        slider.snapToLabels = NO;
        slider.lineWidth = 15;
//        [container addSubview:slider];
        [_sliderArray addObject:slider];
//        slider  =slider;
        y = CGRectGetMaxY(slider.frame) + offset;
        tag++;
    }
    cx = MIN(320, frame.size.width);

    UIButton *button = [UIButton wr_lineBorderButtonWithTitle:NSLocalizedString(@"提交", nil)];
    CGFloat cy = WRUIButtonHeight;
    y = MAX(y, container.height - offset - cy - 64);
    cx = cx - 2*WRUIOffset;
    x = (frame.size.width - cx)/2;
    button.frame = CGRectMake(x, y, cx, cy);
    [button addTarget:self action:@selector(onClickedSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
//    [container addSubview:button];
    y = button.bottom + offset;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, MAX(y, self.scrollView.height - 64));
    UILabel * title = [UILabel new];
    title.y = 35+64;
    title.text = @"恭喜你完成本次锻炼";
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor colorWithHexString:@"707070"];
    [title sizeToFit];
    title.centerX = self.view.centerX;
    [self.view addSubview:title];
    
    
    UILabel * sctitle = [UILabel new];
    sctitle.y = 30;
    sctitle.text = @"本次锻炼结束疼痛度为";
    sctitle.font = [UIFont systemFontOfSize:15];
    sctitle.textColor = [UIColor colorWithHexString:@"333333"];
    [sctitle sizeToFit];
    sctitle.centerX = container.width*1.0/2;
    [container addSubview:sctitle];
    
    UILabel * state = [UILabel new];
    state.y = sctitle.bottom+22;
    state.text = @"未选择";
    state.font = [UIFont systemFontOfSize:13];
    state.textColor = [UIColor colorWithHexString:@"333333"];
    [state sizeToFit];
    state.centerX = container.width*1.0/2;
    [container addSubview:state];
    statela = state;
    
    CCHStepSizeSlider *slider1 = [[CCHStepSizeSlider alloc] initWithFrame:CGRectMake(28, state.bottom+34, container.width-28*2, 50)];
    //    slider1.backgroundColor = [UIColor orangeColor];
    slider1.value = 0;
    slider1.thumbSize = CGSizeMake(20, 20);
    slider1.sliderOffset = 0;
    slider1.thumbImage = [UIImage imageNamed:@"滑动状态"];
    slider1.lineWidth = 4;
    slider1.minTrackColor = [UIColor wr_rehabBlueColor];
    slider1.maxTrackColor = [UIColor colorWithHexString:@"E6F9FF"];
    slider1.continuous = NO;
    
    slider1.type = CCHStepSizeSliderTypeNormal;
    slider =slider1;
    [slider1 addTarget:self action:@selector(valueChangeAction:) forControlEvents:UIControlEventValueChanged];
    [container addSubview:slider1];
    
    UIImageView* stege1 = [UIImageView new];
    [stege1 setImage:[UIImage imageNamed:@"步骤1"]];
    stege1.width = 10;
    stege1.height = 10;
    stege1.centerX = slider1.x+30;
    stege1.centerY = slider1.centerY;
    [container addSubview:stege1];
    
    UILabel* count1= [UILabel new];
    count1.text = @"0";
    count1.textColor = [UIColor colorWithHexString:@"707070"];
    count1.font = [UIFont systemFontOfSize:11];
    count1.y = 12+stege1.bottom;
    [count1 sizeToFit];
    count1.centerX =stege1.centerX;
    [container addSubview:count1];
    
    
    UIImageView* stege2 = [UIImageView new];
    [stege2 setImage:[UIImage imageNamed:@"步骤23"]];
    stege2.width = 10;
    stege2.height = 10;
    stege2.centerX = slider1.centerX;
    stege2.centerY = slider1.centerY;
    [container addSubview:stege2];
    center= stege2;
    
    UILabel* count2= [UILabel new];
    count2.text = @"5";
    count2.textColor = [UIColor colorWithHexString:@"707070"];
    count2.font = [UIFont systemFontOfSize:11];
    count2.y = 12+stege2.bottom;
    [count2 sizeToFit];
    count2.centerX =stege2.centerX;
    [container addSubview:count2];
    
    UIImageView* stege3 = [UIImageView new];
    [stege3 setImage:[UIImage imageNamed:@"步骤23"]];
    stege3.width = 10;
    stege3.height = 10;
    stege3.centerX = slider1.right-30;
    stege3.centerY = slider1.centerY;
    [container addSubview:stege3];
    
    UILabel* count3= [UILabel new];
    count3.text = @"10";
    count3.textColor = [UIColor colorWithHexString:@"707070"];
    count3.font = [UIFont systemFontOfSize:11];
    count3.y = 12+stege3.bottom;
    [count3 sizeToFit];
    count3.centerX =stege3.centerX;
    [container addSubview:count3];
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(18, count3.bottom+28, container.width-18*2, 1)];
    line.backgroundColor = [UIColor wr_lineColor];
    [container addSubview:line];
    
    UILabel * witch = [UILabel new];
    witch.y = 28+line.bottom;
    witch.text = @"感觉哪个动作无法完成？";
    witch.font = [UIFont systemFontOfSize:15];
    witch.textColor = [UIColor colorWithHexString:@"333333"];
    [witch sizeToFit];
    witch.centerX = container.width*1.0/2;
    [container addSubview:witch];
    
    CGFloat by = witch.bottom+28;
    for (int i=0; i<self.rehab.stageSet.count; i++) {
        WRTreatRehabStage* stage = self.rehab.stageSet[i];
        WRTreatRehabStageVideo* vstage = stage.mtWellVideoInfo;
        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, by, container.width, 63)];
        [container addSubview:v];
        
        UIImageView * im = [[UIImageView alloc]initWithFrame:CGRectMake(28, 9, 74, 45)];
        [im setImageURL:[NSURL URLWithString:vstage.thumbnailUrl]];
        [v addSubview:im];
        
        UILabel* name = [UILabel new];
        name.text = [NSString stringWithFormat:@"· %@",vstage.videoName];
        name.font = [UIFont systemFontOfSize:12];
        name.textColor = [UIColor colorWithHexString:@"707070"];
        name.x = 26+im.right;
        name.width = container.width-128-28-23-20;
        name.height = 12;
//        [name sizeToFit];
        name.centerY = im.centerY;
        [v addSubview:name];
        
        UIImageView* choose = [UIImageView new];
        choose.tag = i;
        choose.image = [UIImage imageNamed:@"有效2"];
        choose.width = choose.height = 23;
        choose.right = container.width-28;
        choose.centerY = im.centerY;
        [v addSubview:choose];
        
    
        by= v.bottom;
        v.userInteractionEnabled =YES;
        [v bk_whenTapped:^{
            NSInteger index = title.tag;
            
            //            [self pushtonext];
            if (![arr containsObject:vstage.indexId]) {
                
                
                [choose setImage:[UIImage imageNamed:@"有效"]];
                [arr addObject:vstage.indexId];
            }
            else
            {
                
                
                [choose setImage:[UIImage imageNamed:@"有效2"]];
                [arr removeObject:vstage.indexId];
                
            }
        }];

    }

    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, MAX(by, self.scrollView.height - 64));
    
    
}
- (void)valueChangeAction:(CCHStepSizeSlider *)sender {
    NSLog(@"sender :%@,value :%f,index :%ld",sender,sender.value,(long)sender.index);
    if (sender.value*10<4) {
        statela.text= @"基本不疼";
        [statela sizeToFit];
        statela.centerX = self.scrollView.width*1.0/2;
    }
    else if(sender.value*10>=4&&sender.value*10<8)
    {
        statela.text= @"有点疼";
        [statela sizeToFit];
        statela.centerX = self.scrollView.width*1.0/2;
    }
    else if(sender.value*10<=10&&sender.value*10>=8)
    {
        statela.text= @"特别疼";
        [statela sizeToFit];
        statela.centerX = self.scrollView.width*1.0/2;
    }
}
-(void)close {
    __weak __typeof(self) weakSelf = self;
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.completion) {
            weakSelf.completion();
        }
    }];
}
@end
