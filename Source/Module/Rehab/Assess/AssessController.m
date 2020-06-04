//
//  AssessController.m
//  rehab
//
//  Created by herson on 2016/11/23.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "AssessController.h"


@interface AssessController (){
    NSDate *_startDate;
}
@property(nonatomic, weak) NSArray<WRAssess*> *assessArray;
@end

@implementation AssessController

- (void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForRehabAssess:self.title duration:duration];
}

-(instancetype)initWithAssess:(NSArray *)assessInfo
{
    if (self = [super init]) {
        _assessArray = assessInfo;
        _startDate = [NSDate date];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [WRNetworkService pwiki:@"自我检测"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    [bar lt_setBackgroundColor:[UIColor whiteColor]];
//    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    UIImage *image = [[WRUIConfig defaultNavImage] imageByResizeToSize:CGSizeMake(bar.width, 1)];
//    [bar setShadowImage:image];
    if (self.scrollView.subviews.count == 0)
    {
        UIView *container = self.scrollView;
        CGFloat offset = WRUIOffset, x = offset, y = x, cx = container.width - 2*x, cy;
        UIImage *holderImage = [UIImage imageNamed:@"well_default_video"];
        
        for(WRAssess *object in _assessArray)
        {
            
            NSString *text = object.content;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            [paragraphStyle setLineSpacing:8];//调整行间距
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
            
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
//            label.text = object.content;
            label.attributedText = attributedString;
            label.font = [UIFont wr_textFont];
            label.numberOfLines = 0;
            CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
            cy = size.height;
            label.frame = CGRectMake(x, y, cx, cy);
            [container addSubview:label];
            
            y = label.bottom + offset;
            cy = cx * holderImage.size.height / holderImage.size.width;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
            [container addSubview:imageView];
            y = imageView.bottom + offset;
            [imageView setImageWithURL:[NSURL URLWithString:object.imageUrl] placeholderImage:holderImage];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, container.width, 1)];
            line.backgroundColor = [UIColor wr_lightGray];
            [container addSubview:line];
            y = line.bottom + offset;
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, y);
        
        [self createBackBarButtonItem];
    }
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
