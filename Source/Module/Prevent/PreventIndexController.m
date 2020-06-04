 //
//  PreventIndexController.m
//  rehab
//
//  Created by herson on 2016/11/15.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "PreventIndexController.h"

#import "PreventViewModel.h"

#import "PreventVideosController.h"



#import <YYKit/YYKit.h>
#import "NetworkNotifier.h"
@interface PreventIndexController ()

@property(nonatomic)UIScrollView *scrollView;
@property(nonatomic)PreventViewModel *viewModel;
@property(nonatomic)BOOL isLoadedData;
@property(nonatomic)NSArray *imageColors;
@property(nonatomic)NetworkNotifier* networkNotifier;
@end

@implementation PreventIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isLoadedData = NO;
    self.scrollView.frame = self.view.bounds;
    self.imageColors = @[[UIColor colorWithHexString:@"ff892f"], [UIColor colorWithHexString:@"004eff"], [UIColor colorWithHexString:@"ed1e79"], [UIColor colorWithHexString:@"47c0ff"]];
    [WRNetworkService pwiki:@"预防"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
    
    self.title = NSLocalizedString(@"预防", nil);
    if (!self.isLoadedData) {
        [self loadData];
    }
}


#pragma mark - getter & setter
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

-(PreventViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PreventViewModel alloc] init];
    }
    return _viewModel;
}


#pragma mark - action
-(IBAction)onClickedItem:(id)sender {
    UIImageView *imageView = sender;
    
    NSInteger index = imageView.tag;
    if (index < self.viewModel.scenes.count) {
        WRScene *scene = self.viewModel.scenes[index];
        NSLog(@"scene.name%@",scene.name);
        PreventVideosController *viewController = [[PreventVideosController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController setScene:scene banner:[UIImage imageNamed:[NSString stringWithFormat:@"prevent_banner_%d",(int)(index%self.imageColors.count + 1)]] mostColor:self.imageColors[index%self.imageColors.count]];
    }
}

#pragma mark - layout
-(UIView*)createItemWithTitle:(NSString*)title image:(UIImage*)image {
    CGFloat offset = WRUIOffset;
    CGFloat x = offset;
    CGFloat cx = self.scrollView.width - 2*x, cy = (image.size.height*cx)/image.size.width;
    UIImageView *itemView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, cx, cy)];
    itemView.image = image;
    itemView.userInteractionEnabled = YES;
    
    x = 0;
    UILabel *label = [UILabel new];
    label.font = [UIFont wr_smallTitleFont];
    label.numberOfLines = 1;
    label.backgroundColor = [UIColor wr_rehabBlueColor];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.width = label.width*1.2;
    label.height = label.height*1.4;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = [Utility moveRect:label.frame x:cx - label.width - offset y:offset];
    [itemView addSubview:label];

    //itemView.layer.shadowColor = [UIColor blackColor].CGColor;
    //itemView.layer.shadowOffset = CGSizeMake(2, 2);
    //itemView.layer.shadowOpacity = 1;
    //itemView.layer.shadowRadius = 5.0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prevent_title_bg"]];
    [itemView addSubview:imageView];
    
    UILabel *siteLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 0, itemView.width, itemView.height)];
    siteLabel.numberOfLines = 2;
    siteLabel.textColor = [UIColor whiteColor];
    siteLabel.text = NSLocalizedString(@" 康复运动地点选择\n Sites for exercise rehabilitation", nil);
    [siteLabel sizeToFit];
    [imageView addSubview:siteLabel];
    imageView.frame = CGRectMake(0, cy - siteLabel.height, cx, siteLabel.height);
    
    UIImage *siteImage = [UIImage imageNamed:@"prevent_site"];
    UIImageView *siteImageView = [[UIImageView alloc] initWithImage:siteImage];
    siteImageView.frame = CGRectMake(cx - siteImage.size.width - offset, (imageView.height - siteImage.size.height)/2, siteImage.size.width, siteImage.size.height);
    [imageView addSubview:siteImageView];
    
    itemView.layer.masksToBounds = YES;
    itemView.layer.cornerRadius = 5.f;
    
    return itemView;
}

-(void)layout {
    [self.scrollView removeAllSubviews];
    
    int index = 0;
    CGFloat y = 0, offset = 0;
    __weak __typeof(self) weakSelf = self;
//    NSString *text = NSLocalizedString(@"请根据您目前身处的场景，\n选择适合自己的康复运动，\n来锻炼自己的深层肌肉、预防慢病吧！", nil);
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:8];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
//    UILabel *alarmLabel = [[UILabel alloc] initWithFrame:CGRectMake(WRUIOffset, WRUIOffset, cx, 0)];
//    alarmLabel.font = [UIFont wr_textFont];
//    alarmLabel.numberOfLines = 0;
//    alarmLabel.backgroundColor = [UIColor whiteColor];
//    alarmLabel.attributedText = attributedString;
//    alarmLabel.textColor = [UIColor grayColor];
//    [alarmLabel sizeToFit];
//    alarmLabel.width = cx;
//    alarmLabel.textAlignment = NSTextAlignmentLeft;
//    alarmLabel.frame = [Utility resizeRect:alarmLabel.frame cx:alarmLabel.width height:alarmLabel.height];
//    [self.scrollView addSubview:alarmLabel];
//    y = alarmLabel.bottom + WRUIOffset;
    for(WRScene *object in self.viewModel.scenes)
    {
        NSString *imageName = [NSString stringWithFormat:@"prevent_%d", (index%3 + 1)];
        UIView *itemView = [self createItemWithTitle:object.name image:[UIImage imageNamed:imageName]];
        if (y == 0) {
            y = itemView.left;
            offset = y;
        }
        itemView.frame = CGRectMake(itemView.left, y, itemView.width, itemView.height);
        itemView.tag = index;
        [self.scrollView addSubview:itemView];
        
        y = itemView.bottom + WRUIOffset/2;
        
        [itemView bk_whenTapped:^{
            [weakSelf onClickedItem:itemView];
        }];
        
        index++;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, MAX(y, self.scrollView.height));
}

#pragma mark - data
-(void)loadData {
    __weak __typeof(self) weakSelf = self;
    [self.viewModel fetchDataWithCompletion:^(NSError *error) {
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
                [weakSelf loadData];
            }];
        } else {
            weakSelf.isLoadedData = YES;
            [weakSelf layout];
        }
    }];
}

#pragma mark - test
-(void)initTestData {
    NSArray *array = @[NSLocalizedString(@"在家", nil), NSLocalizedString(@"工作中", nil), NSLocalizedString(@"变强", nil), NSLocalizedString(@"行走中", nil)];
    int index = 0;
    CGFloat y = 0, offset = 0;
    for(NSString *title in array)
    {
        NSString *imageName = [NSString stringWithFormat:@"prevent_%d", (index%3 + 1)];
        UIView *itemView = [self createItemWithTitle:title image:[UIImage imageNamed:imageName]];
        if (y == 0) {
            y = itemView.left;
            offset = y;
        }
        itemView.frame = CGRectMake(itemView.left, y, itemView.width, itemView.height);
        [self.scrollView addSubview:itemView];
        
        y = itemView.bottom + offset;
        
        index++;
    }
}

@end
