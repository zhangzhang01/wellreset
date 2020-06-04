
//
//  RehabCalendarController.m
//  rehab
//
//  Created by yefangyang on 2016/9/23.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "RehabCalendarController.h"
#import "IQKeyboardManager.h"

#import "PTRehabMarkView.h"

@interface RehabCalendarController ()<UIScrollViewDelegate>
{
    UIImageView *_bannerImageView;
    UIScrollView *_scrollView;
}
@property(nonatomic)PTRehabMarkView *markView;
@property(nonatomic)WRRehab *rehab;
@end

@implementation RehabCalendarController


-(instancetype)initWithRehab:(id)rehab{
    if(self = [super init]){
        _rehab = rehab;
//        self.navigationItem.title = self.rehab.disease.diseaseName;
        CGRect frame = self.view.bounds;
        CGFloat x, y, cx, cy;
        
        
        
        cx = frame.size.width;
        BOOL biPad = [WRUIConfig IsHDApp];
        
        if (biPad) {
            cy = 0.31 * cx;
        } else {
            cy = 0.56 * cx;
        }
        UIImageView *bannerImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cx, cy)];
        bannerImageView.backgroundColor = [UIColor wr_lightWhite];
        [self.view addSubview:bannerImageView];
        _bannerImageView = bannerImageView;
        
        UIColor *textColor = [UIColor grayColor];
        
        NSArray<NSString*> *weekDays = @[
                              NSLocalizedString(@"星期日", nil),
                              NSLocalizedString(@"星期一", nil),
                              NSLocalizedString(@"星期二", nil),
                              NSLocalizedString(@"星期三", nil),
                              NSLocalizedString(@"星期四", nil),
                              NSLocalizedString(@"星期五", nil),
                              NSLocalizedString(@"星期六", nil),
                              ];
        x = 0;
        cx = frame.size.width/weekDays.count, cy = MIN(30, cx);
        y = 0;
        UILabel *label;
        UIFont *font = [WRUIConfig IsHDApp] ? [UIFont wr_smallTitleFont] : [UIFont wr_textFont];
        
        for(NSInteger index = 0; index < weekDays.count; index++)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
            label.text = [weekDays[index] substringFromIndex:2];
            label.textColor = textColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = font;
            [self.view addSubview:label];
            x = label.right;
        }
        bannerImageView.height = label.bottom;
        
        y = _bannerImageView.bottom ;
        cy = self.view.bottom - y;
        x = 0;
        cx = _bannerImageView.width - 2*x;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"rehab_backgroud" ofType:@"png"];
//        UIImage *bgImage = [UIImage imageWithContentsOfFile:path];
//        scrollView.layer.contents = (id)bgImage.CGImage;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
        scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        
        x = 0;
        y = WRUIOffset;
        cx = _scrollView.frame.size.width;
        NSDate *beginDate = [NSDate dateWithString:self.rehab.createTime];
        NSInteger day;
        day = MAX(self.rehab.count, [Utility getDaysFrom:beginDate To:[NSDate date]]);
        PTRehabMarkView *markView = [[PTRehabMarkView alloc] initWithFrame:CGRectMake(x, y, cx, cy - y) beginDate:beginDate days:day];
//        PTRehabMarkView *markView = [[PTRehabMarkView alloc] initWithFrame:CGRectMake(x, y, cx, 0) beginDate:beginDate days:_rehab.count];
        markView.layer.masksToBounds = YES;
        markView.layer.cornerRadius = 5.f;
        [_scrollView addSubview:markView];
        self.markView = markView;
        NSMutableArray *dateArray = [NSMutableArray array];
        for(NSString *dateString in self.rehab.checkedDate) {
            NSDate *date = [NSDate dateWithString:dateString];
            [dateArray addObject:date];
        }
        if (dateArray.count > 0) {
            [_markView checkForDateArray:dateArray];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBackBarButtonItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *months = @[
                        NSLocalizedString(@"一月", nil),
                        NSLocalizedString(@"二月", nil),
                        NSLocalizedString(@"三月", nil),
                        NSLocalizedString(@"四月", nil),
                        NSLocalizedString(@"五月", nil),
                        NSLocalizedString(@"六月", nil),
                        NSLocalizedString(@"七月", nil),
                        NSLocalizedString(@"八月", nil),
                        NSLocalizedString(@"九月", nil),
                        NSLocalizedString(@"十月", nil),
                        NSLocalizedString(@"十一月", nil),
                        NSLocalizedString(@"十二月", nil),
                        ];
    
    NSDate *beginDate = [NSDate dateWithString:self.rehab.createTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];

    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:beginDate]integerValue];
    NSString *monthString = months[currentMonth - 1];
//    self.navigationItem.title = monthString;
    [IQKeyboardManager sharedManager].enable = NO;
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    UIImage *image = [[WRUIConfig defaultNavImage] imageByResizeToSize:CGSizeMake(bar.width, 1)];
//    [bar setShadowImage:image];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:[WRUIConfig defaultBarImage] forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    [bar lt_setBackgroundColor:[UIColor wr_themeColor]];
//    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [bar setShadowImage:[UIImage new]];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _scrollView.delegate = nil;
    
    [IQKeyboardManager sharedManager].enable = YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
