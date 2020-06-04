//
//  AskImIndexController.m
//  rehab
//
//  Created by yongen zhou on 2017/6/26.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "AskImIndexController.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "ImlistController.h"
#import "PayforIMcontroller.h"
#import "PayImViewModel.h"
#import <Photos/Photos.h>
//#import "ChatViewController.h"
#import "JCAlertView.h"
@interface AskImIndexController ()
{
    UIScrollView* _ba;
    JCAlertView* jc;
}
@property UIGestureRecognizer *longPressGestureEWM;
@property PayImViewModel* viewModel;
@end

@implementation AskImIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"咨询服务";
    _ba = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.view.height-64)];
    [self.view addSubview:_ba];
    self.viewModel = [PayImViewModel new];
    [self layout];
    [self createBackBarButtonItem];
   
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.viewModel fetchProductlistcompletion:^(NSError * _Nonnull error) {
       [self layout];
    }];
    
    
}
-(void)saveImageClick{
    
     [jc dismissWithCompletion:nil];
    // 0.创建上下文
    [SVProgressHUD showWithStatus:@"保存中..."];
    
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:[UIImage imageNamed:@"二维码"]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
           
        } else {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
    }];
    
    
    
    
//    CIContext *context = [[CIContext alloc] init];
//
//    // 1.创建一个探测器
//    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
//
//    // 2.直接开始识别图片,获取图片特征
//    CIImage *imageCI = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"二维码.png"]];
//    NSArray *features = [detector featuresInImage:imageCI];
//    CIQRCodeFeature *codef = (CIQRCodeFeature *)features.firstObject;
//
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"识别图中二维码" message:nil preferredStyle:UIAlertControllerStyleAlert];
//
//    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    NSLog(@"取消");
//        }]];
//    __weak typeof (self)weakSelf = self;
//    [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//
//        }]];
//    [self presentViewController:alertC animated:YES completion:nil];

}
-(void)layout
{
    [_ba removeAllSubviews];
    CGFloat height = 0;
    UIImageView* im = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 305.5)];
    [im setImage:[UIImage imageNamed:@"咨询"]];
    [_ba addSubview:im];
    height = im.bottom;
    
    UIView* titleV = [self createTitle];
    titleV.y = height;
    [_ba addSubview:titleV];
    height = titleV.bottom;
    
    NSArray* imgs = @[@"im1",@"im2",@"im3",@"im4"];
    for (int i = 0;i<4 ; i++) {
        UIImageView* im = [[UIImageView alloc]initWithFrame:CGRectMake(0, height, ScreenW, 180)];
        [im setImage:[UIImage imageNamed:imgs[i]]];
        [_ba addSubview:im];
        height = im.bottom;
        
        height+=3;
    }
    
    UIView* DetailV = [self createHealthCard];
    DetailV.y = height;
    [_ba addSubview:DetailV];
    height = DetailV.bottom;
    
    UIView* comment = [self createCommentView];
    comment.y = height;
    [_ba addSubview:comment];
    height = comment.bottom;
    
    _ba.contentSize = CGSizeMake(ScreenW, height+50);
    
    UIButton* gobuy = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height-50, ScreenW, 50)];
    gobuy.backgroundColor = [UIColor colorWithHexString:@"4fd8ff"];
    [gobuy setTitle:@"立即咨询" forState:0];
    [gobuy setTitleColor:[UIColor whiteColor] forState:0];
    gobuy.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:gobuy];
    
    
    UIView* back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 301, 391)];
    back.backgroundColor = [UIColor whiteColor];
    back.layer.cornerRadius = 10;
    back.layer.masksToBounds = YES;
    UIImageView* imb = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 301,205)];
    [imb setImage:[UIImage imageNamed:@"背景.png"]];
    [back addSubview:imb];
    
    UILabel* la = [UILabel new];
    la.y = 57;
    la.text = @"您好，如想定制【线上专家咨询服务】";
    la.font = [UIFont boldSystemFontOfSize:WRDetailFont];
    la.textAlignment = NSTextAlignmentCenter;
    [la sizeToFit];
    
    la.textColor = [UIColor whiteColor];
    la.centerX = back.width*1.0/2;
    [back addSubview:la];
    
    UILabel* la2 = [UILabel new];
    la2.y = la.bottom + 24;
    la2.text = @"请添加助手微信：WELL-one";
    la2.font = [UIFont boldSystemFontOfSize:16];
    la2.textAlignment = NSTextAlignmentCenter;
    [la2 sizeToFit];
    
    la2.textColor = [UIColor whiteColor];
    la2.centerX = back.width*1.0/2;
    [back addSubview:la2];
    
    UIImageView* arim = [UIImageView new];
    arim.width = 140;
    arim.height = 140;
    arim.center = CGPointMake(back.width*1.0/2, back.height*1.0/2);
    [arim setImage:[UIImage imageNamed:@"二维码.png"]];
    [back addSubview:arim];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.width = 140;
    button.height = 140;
    button.center = CGPointMake(back.width*1.0/2, back.height*1.0/2);
    [button addTarget:self action:@selector(saveImageClick) forControlEvents:UIControlEventTouchUpInside];
//    button.backgroundColor = [UIColor redColor];
    [back addSubview:button];
    
    UILabel* la5 = [UILabel new];
    la5.y = MaxY(arim);
    la5.x = 5;
    la5.height = 30;
    la5.width = WIDTH(back)-10;
    la5.text = @"点击二维码，保存图片";
    la5.font = [UIFont boldSystemFontOfSize:WRDetailFont];
    la5.textAlignment = NSTextAlignmentCenter;
//    [la5 sizeToFit];
    [back addSubview:la5];
    
    CALayer *shadowLayer0 = [[CALayer alloc] init];
    shadowLayer0.frame = arim.bounds;
    shadowLayer0.shadowColor = [UIColor colorWithRed:0.0f/255.0f green:182.0f/255.0f blue:254.0f/255.0f alpha:0.17f].CGColor;
    shadowLayer0.shadowOpacity = 1;
    shadowLayer0.shadowOffset = CGSizeMake(0, 4);
    shadowLayer0.shadowRadius = 3.925;
    CGFloat shadowSize0 = 0.15;
    CGRect shadowSpreadRect0 = CGRectMake(-shadowSize0, -shadowSize0, arim.bounds.size.width+shadowSize0*2, arim.bounds.size.height+shadowSize0*2);
    CGFloat shadowSpreadRadius0 =  arim.layer.cornerRadius == 0 ? 0 : arim.layer.cornerRadius+shadowSize0;
    UIBezierPath *shadowPath0 = [UIBezierPath bezierPathWithRoundedRect:shadowSpreadRect0 cornerRadius:shadowSpreadRadius0];
    shadowLayer0.shadowPath = shadowPath0.CGPath;
   // [arim.layer addSublayer:shadowLayer0];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"联系电话：13022007084\n地       址：广东省广州市天河区元岗路310号\n                 智汇park创业园E座6楼"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1.0f] range:NSMakeRange(0, 5)];
    
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:255.0f/255.0f alpha:1.0f] range:NSMakeRange(5, 11)];
    
    UILabel* detail = [UILabel new];
    detail.font = [UIFont systemFontOfSize:11];
    
   // [UILabel changeLineSpaceForLabel:detail WithSpace:10];
    
    detail.numberOfLines = 0;
    detail.width =238;
    detail.textColor = [UIColor colorWithHexString:@"#5a5a5a"];
    detail.attributedText = attributedString;
    [detail sizeToFit];
    detail.centerX = back.width*1.0/2;
    detail.y = 305;
    [back addSubview:detail];
    
    UIImageView* close = [UIImageView new];
    close.height = 17;
    close.width = 17;
    close.x = 266;
    close.y = 19;
    [close setImage:[UIImage imageNamed:@"关闭"]];
    [back addSubview:close];
    
    UIButton* closebtn = [UIButton new];
    closebtn.x = 266-18;
    closebtn.y = 1;
    closebtn.height = 17+18;
    closebtn.width = 17+18;
    [back addSubview:closebtn];
    
    
//    [self.viewModel fetchAlreadyOrdercompletion:^(NSError * _Nonnull error) {
//        for (NSDictionary*dic in self.viewModel.orderlist) {
//            if ([dic[@"type"] integerValue]==2) {
//                UIButton* right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30+4, 15)];
//                [right setTitle:@"续约" forState:0];
//                [right setTitleColor:[UIColor wr_rehabBlueColor] forState:0];
//                [right bk_whenTapped:^{
//                    PayforIMcontroller* pv =[PayforIMcontroller new];
//                    pv.canpay =2;
//                    [self.navigationController pushViewController:pv animated:YES];
//                }];
//                right.titleLabel.font = [UIFont systemFontOfSize:WRTitleFont];
//                UIBarButtonItem* item  = [[UIBarButtonItem alloc]initWithCustomView:right];
//                self.navigationItem.rightBarButtonItem = item;
//            }
//        }
//    }];
    
     jc = [[JCAlertView alloc]initWithCustomView:back dismissWhenTouchedBackground:YES];
    [gobuy bk_whenTapped:^{
//        [self.viewModel fetchAlreadyOrdercompletion:^(NSError * _Nonnull error) {
//            if (self.viewModel.orderlist.count==0) {
//                PayforIMcontroller * vc = [PayforIMcontroller new];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//            else
//            {
//                ChatViewController *chatController = nil;
//                            chatController = [[ChatViewController alloc] initWithConversationChatter:@"rudy123" conversationType:0];
////                chatController.hideBottom = YES;
//
//                chatController.hidesBottomBarWhenPushed =YES;
//
//                [self.navigationController pushViewController:chatController animated:YES];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
//
//            }
//
//
//        }];
        
        
        [jc show];
        
        
        
    }];
    [closebtn bk_whenTapped:^{
        [jc dismissWithCompletion:nil];
    }];
    

}
- (UIView* )createTitle
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 62)];
    UIImageView * Lim = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 74, 62)];
    [Lim setImage:[UIImage imageNamed:@"左叶子"]];
    [pannel addSubview:Lim];
    UIImageView * Rim = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW-36, 0, 36, 62)];
    [Rim setImage:[UIImage imageNamed:@"右叶子"]];
    [pannel addSubview:Rim];
    
    UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(21+74, (62-16)*1.0/2, ScreenW-21-74-7-36, 16)];
    title.numberOfLines =1;
    title.adjustsFontSizeToFitWidth =YES;
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"运动康复过程中您是否有以下疑问？";
    [pannel addSubview:title];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = CGRectMake(title.x, title.y+305.5, title.width, title.height);
    // 设置渐变层的颜色，随机颜色渐变
    gradientLayer.colors = @[(id)[UIColor colorWithHexString:@"4fd8ff"].CGColor, (id)[UIColor colorWithHexString:@"52a8f7"].CGColor];  // 疑问:渐变层能不能加在label上
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.mask = title.layer;
    [_ba.layer addSublayer:gradientLayer];
    title.frame = gradientLayer.bounds;
    
    
    
    return pannel;
}

- (UIView*)createHealthCard
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    CGFloat y = 13;
    UIView* card = [[UIView alloc]initWithFrame:CGRectMake(6, 7, ScreenW-12, 0)];
    [pannel addSubview:card];
    
    UILabel* title = [UILabel new];
    title.x = 33+6;
    title.y = 15;
    title.text = @"咨询项目";
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor wr_titleTextColor];
    [pannel addSubview:title];
    [title sizeToFit];
    y= 44;
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(6, y, card.width, 0.5)];
    line.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:line];
    //分类
    UIImageView* jim = [UIImageView new];
    jim.y = y+15;
    jim.x = 6;
    jim.width = 17;
    jim.height = 39 ;
    y = jim.bottom+11;
    
    [pannel addSubview:jim];
    UILabel* jtitle = [UILabel new];
    jtitle.x = 32+6;
    jtitle.y = y;
    jtitle.text = @"颈肩腰腿痛康复";
    jtitle.textColor = [UIColor wr_titleTextColor];
    jtitle.font = [UIFont systemFontOfSize:13];
    [pannel addSubview:jtitle];
    [jtitle sizeToFit];
    y = jtitle.bottom+13;
    UILabel* jdetail = [UILabel new];
    jdetail.x = 24+6;
    jdetail.y = y;
    jdetail.text = @"·颈椎病、颈源性头痛\n·鼠标手、肩周炎、肩袖损伤\n·腰肌劳损、腰椎间盘突出症\n·膝关节炎";
    jdetail.numberOfLines = 0;
    jdetail.font = [UIFont systemFontOfSize:12];
    if (ScreenW<375) {
       jdetail.font = [UIFont systemFontOfSize:10];
    }
    
    jdetail.textColor = [UIColor wr_detailTextColor];
    
    [jdetail sizeToFit];
    [pannel addSubview:jdetail];
    jim.centerX = jtitle.centerX;
    [jim setImage:[UIImage imageNamed:jtitle.text]];
    
    UIImageView* yim = [UIImageView new];
    yim.y = 44+15;
    yim.x = 0;
    yim.width = 37;
    yim.height = 33 ;
    y = jim.bottom+11;
    [pannel addSubview:yim];
    UILabel* ytitle = [UILabel new];
    ytitle.x = 32+6;
    ytitle.y = y;
    ytitle.text = @"体态姿势调整";
    ytitle.textColor = [UIColor wr_titleTextColor];
    ytitle.font = [UIFont systemFontOfSize:13];
    [pannel addSubview:ytitle];
    [ytitle sizeToFit];
    y = jtitle.bottom+13;
    ytitle.right = card.width-35+6;
    UILabel* ydetail = [UILabel new];
    ydetail.x = 24+6;
    ydetail.y = y;
    ydetail.text = @"头前伸、驼背·\n高低肩、圆背·\n骨盆前倾、脊柱侧弯·";
    ydetail.textAlignment = NSTextAlignmentRight;
    ydetail.numberOfLines = 0;
    ydetail.font = [UIFont systemFontOfSize:12];
    if (ScreenW<375) {
        ydetail.font = [UIFont systemFontOfSize:10];
    }
    ydetail.textColor = [UIColor wr_detailTextColor];
    [ydetail sizeToFit];
    [pannel addSubview:ydetail];
    ydetail.right = card.width - 27+6;
    yim.centerX = ytitle.centerX;
    [yim setImage:[UIImage imageNamed:ytitle.text]];
    
    

    UILabel* tdetail = [UILabel new];
    tdetail.x = 24+6;
    tdetail.y = y;
    tdetail.text = @"·骨折、关节扭伤\n·韧带撕裂、半月板损伤\n·滑囊炎、足底筋膜炎";
    tdetail.numberOfLines = 0;
    tdetail.font = [UIFont systemFontOfSize:12];
    if (ScreenW<375) {
        tdetail.font = [UIFont systemFontOfSize:10];
    }
    tdetail.textColor = [UIColor wr_detailTextColor];
    [tdetail sizeToFit];
    [UILabel changeLineSpaceForLabel:tdetail WithSpace:7];
    [tdetail sizeToFit];
    [pannel addSubview:tdetail];
    tdetail.bottom = 355+44 - 17;
    y= tdetail.top-13;
    UILabel* ttitle = [UILabel new];
    ttitle.x = 32+6;
    ttitle.y = y;
    ttitle.text = @"运动损伤康复";
    ttitle.textColor = [UIColor wr_titleTextColor];
    ttitle.font = [UIFont systemFontOfSize:13];
    [pannel addSubview:ttitle];
    [ttitle sizeToFit];
    ttitle.bottom = y;
    y = ttitle.top-11;
    UIImageView* tim = [UIImageView new];
    tim.y = y+15;
    tim.x = 0;
    tim.width = 41;
    tim.height = 39 ;
    [pannel addSubview:tim];
    tim.bottom = y;
    tim.centerX = ttitle.centerX;
    [tim setImage:[UIImage imageNamed:ttitle.text]];
    
    UILabel* sdetail = [UILabel new];
    sdetail.x = 24+6;
    sdetail.y = y;
    sdetail.text = @"颈、肩、腰、膝等\n各部位肌肉骨骼疾病\n手术后康复";
    sdetail.numberOfLines = 0;
    sdetail.textAlignment = NSTextAlignmentRight;
    sdetail.font = [UIFont systemFontOfSize:12];
    if (ScreenW<375) {
        tdetail.font = [UIFont systemFontOfSize:10];
    }
    sdetail.textColor = [UIColor wr_detailTextColor];
    [sdetail sizeToFit];
    [UILabel changeLineSpaceForLabel:sdetail WithSpace:7];
    [sdetail sizeToFit];
    [pannel addSubview:sdetail];
    sdetail.bottom = 355+44 - 17;
    sdetail.right = card.width-35+6;
    y= sdetail.top-13;
    UILabel* stitle = [UILabel new];
    stitle.x = 32;
    stitle.y = y;
    stitle.text = @"术后康复";
    stitle.textColor = [UIColor wr_titleTextColor];
    stitle.font = [UIFont systemFontOfSize:13];
    [pannel addSubview:stitle];
    [stitle sizeToFit];
    stitle.bottom = y;
    stitle.right = card.width-35+6;
    y = stitle.top-11;
    UIImageView* sim = [UIImageView new];
    sim.y = y+15;
    sim.x = 0;
    sim.width = 53;
    sim.height = 40 ;
    [pannel addSubview:sim];
    sim.bottom = y;
    sim.centerX = stitle.centerX;

    y = 355+44;
    [sim setImage:[UIImage imageNamed:stitle.text]];
    UIView* grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, y, card.width, 5)];
    grayLine.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:grayLine];
    
    [UILabel changeLineSpaceForLabel:jdetail WithSpace:7];
    
    [UILabel changeLineSpaceForLabel:ydetail WithSpace:7];
    

    
    
    
    //详情
    UILabel* timeTitle = [UILabel new];
    timeTitle.x= 33+6;
    timeTitle.y= y+16;
    timeTitle.text = @"服务时间";
    timeTitle.font = [UIFont systemFontOfSize:15];
    timeTitle.textColor = [UIColor wr_titleTextColor];
    [pannel addSubview:timeTitle];
    [timeTitle sizeToFit];
    y += 5+44;
    UIView* smallLine = [[UIView alloc]initWithFrame:CGRectMake(10, y, card.width-10, 1)];
    smallLine.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:smallLine];
    y = smallLine.bottom;
    UILabel* timeDetail = [UILabel new];
    timeDetail.x= 33+6;
    timeDetail.y= y+15;
    timeDetail.text = @"周一到周五：\n上午10：00-12：00/下午2：00-5：00\n其它咨询时间：专家咨询页面，留下最空闲的三个时间段与联系方式。专家确认咨询时间后，将以短信的方式通知您";
    timeDetail.numberOfLines = 0;
    timeDetail.font = [UIFont systemFontOfSize:13];
    timeDetail.textColor = [UIColor wr_titleTextColor];
    [pannel addSubview:timeDetail];
    timeDetail.width = card.width - 35*2+6;
     [UILabel changeLineSpaceForLabel:timeDetail WithSpace:7];
    [timeDetail sizeToFit];
    y = timeDetail.bottom+15;
    grayLine = [[UIView alloc]initWithFrame:CGRectMake(6, y, card.width, 5)];
    grayLine.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:grayLine];
    y += 5;
    
//#ifndef debug
//    self.viewModel.once1 = @"0";
//    self.viewModel.once2 = @"0";
//#endif
    
    UILabel* countTitle = [UILabel new];
    countTitle.x= 33+6;
    countTitle.y= y+16;
    countTitle.text = @"服务资费";
    countTitle.font = [UIFont systemFontOfSize:15];
    countTitle.textColor = [UIColor wr_titleTextColor];
    [pannel addSubview:countTitle];
    [countTitle sizeToFit];
    y=countTitle.bottom+14;
    
    smallLine = [[UIView alloc]initWithFrame:CGRectMake(16, y, card.width-20, 1)];
    smallLine.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:smallLine];
    y = smallLine.bottom;
    UILabel* sinTitle = [UILabel new];
    sinTitle.x= 20+6;
    sinTitle.y= y+33;
    sinTitle.text =[NSString stringWithFormat:@"·  单次在线咨询"] ;
    sinTitle.font = [UIFont boldSystemFontOfSize:13];
    sinTitle.textColor = [UIColor wr_titleTextColor];
    [pannel addSubview:sinTitle];
    [sinTitle sizeToFit];
    y= sinTitle.bottom;
    
    UILabel* sinTitle1 = [UILabel new];
    sinTitle1.x= 30+6;
    sinTitle1.y= y+13;
    sinTitle1.text =[NSString stringWithFormat:@"原价：￥%@元 / 次",self.viewModel.moneyTotal1] ;
    if ([self.viewModel.once1 intValue]==0) {
        sinTitle1.text =[NSString stringWithFormat:@"售价：￥%@元 / 次",self.viewModel.moneyTotal1] ;
    }
    sinTitle1.font = [UIFont systemFontOfSize:13];
    sinTitle1.textColor = [UIColor wr_themeColor];
    
    NSMutableAttributedString* att = [[NSMutableAttributedString alloc]initWithString:sinTitle1.text];
    [att setAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
    NSStrikethroughColorAttributeName:[UIColor wr_themeColor]} range:NSMakeRange(3,sinTitle1.text.length-3 )];
   
    if ([self.viewModel.once1 intValue]!=0) {
         sinTitle1.attributedText = att;
    }
    
   
    
    
    [pannel addSubview:sinTitle1];
    [sinTitle1 sizeToFit];
    y= sinTitle1.bottom;
    
    UILabel* sinTitle2 = [UILabel new];
    sinTitle2.x= 30+6;
    sinTitle2.y= y+11;
    sinTitle2.text =[NSString stringWithFormat:@"优惠价：￥%@元 / 次 \n%@,剩下%d个名额。",self.viewModel.money1,self.viewModel.des1,[self.viewModel.once1 intValue]] ;
    sinTitle2.numberOfLines = 0;
    sinTitle2.font = [UIFont boldSystemFontOfSize:13];
    sinTitle2.textColor = [UIColor wr_themeColor];
    if ([self.viewModel.once1 intValue]!=0) {
        [pannel addSubview:sinTitle2];
        [sinTitle2 sizeToFit];
        y= sinTitle2.bottom;
    }
    
    
    
    
    
    
    UILabel* sinDetail = [UILabel new];
    sinDetail.x= 30+6;
    sinDetail.y= y+14;
    sinDetail.text = @"可在线以文字、图片、语音的方式咨询我们的专家";
    sinDetail.font = [UIFont systemFontOfSize:13];
    sinDetail.textColor = [UIColor wr_titleTextColor];
     [UILabel changeLineSpaceForLabel:sinDetail WithSpace:7];
    [pannel addSubview:sinDetail];
    [sinDetail sizeToFit];
    y = sinDetail.bottom;
    y+=26;
    smallLine = [[UIView alloc]initWithFrame:CGRectMake(10, y, card.width-10, 1)];
    smallLine.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:smallLine];
    
    
    UILabel* longTitle = [UILabel new];
    longTitle.x= 20+6;
    longTitle.y= y+23;
    longTitle.text = [NSString stringWithFormat:@"·  签约私人专家",self.viewModel.money2];
    longTitle.font = [UIFont boldSystemFontOfSize:13];
    longTitle.textColor = [UIColor wr_titleTextColor];
    [pannel addSubview:longTitle];
    [longTitle sizeToFit];
    y= longTitle.bottom;
    
    
    UILabel* longTitle1 = [UILabel new];
    longTitle1.x= 30+6;
    longTitle1.y= y+13;
    longTitle1.text =[NSString stringWithFormat:@"原价：￥%@元 / 月",self.viewModel.moneyTotal2] ;
    if ([self.viewModel.once2 intValue]==0) {
        longTitle1.text =[NSString stringWithFormat:@"售价：￥%@元 / 月",self.viewModel.moneyTotal2];
    }
    longTitle1.font = [UIFont systemFontOfSize:13];
    longTitle1.textColor = [UIColor wr_themeColor];
    att = [[NSMutableAttributedString alloc]initWithString:longTitle1.text];
    [att setAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                         NSStrikethroughColorAttributeName:[UIColor wr_themeColor]} range:NSMakeRange(3,longTitle1.text.length-3 )];
    
    if ([self.viewModel.once2 intValue]!=0) {
        longTitle1.attributedText = att;
    }
    
    
    
    
    [pannel addSubview:longTitle1];
    [longTitle1 sizeToFit];
    y= longTitle1.bottom;
    
    UILabel* longTitle2 = [UILabel new];
    longTitle2.x= 30+6;
    longTitle2.y= y+11;
    longTitle2.text =[NSString stringWithFormat:@"优惠价：￥%@元 / 月 \n%@,剩下%d个名额。",self.viewModel.money2,self.viewModel.des2,[self.viewModel.once2 intValue]] ;
    longTitle2.numberOfLines = 0;
    longTitle2.font = [UIFont boldSystemFontOfSize:13];
    longTitle2.textColor = [UIColor wr_themeColor];
    if ([self.viewModel.once2 intValue]!=0) {
        [pannel addSubview:longTitle2];
        [longTitle2 sizeToFit];
        y= longTitle2.bottom;
    }
    

    
    
    
    
    UILabel* longDetail = [UILabel new];
    longDetail.x= 30+6;
    longDetail.y= y+14;
    longDetail.text = @"可在线以文字、图片、语音的方式咨询我们的专家\n签约私人专家后\n·  签约期间内不限咨询次数\n·  可获得专家回访";
    longDetail.numberOfLines = 0;
    longDetail.font = [UIFont systemFontOfSize:13];
    
    longDetail.textColor = [UIColor wr_titleTextColor];
    [UILabel changeLineSpaceForLabel:longDetail WithSpace:7];
    [pannel addSubview:longDetail];
    [longDetail sizeToFit];
    y = longDetail.bottom;
    y+=26;
    
    card.height = y;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 5;
    card.layer.shadowOpacity = 0.15;// 阴影透明度
//    card.layer.masksToBounds =YES;
    card.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
    
//    card.layer.borderColor = [UIColor blackColor].CGColor;
//    card.layer.borderWidth =0.5;
    
    card.layer.shadowRadius = 7;// 阴影扩散的范围控制
    
    card.layer.shadowOffset  = CGSizeMake(2, 2);// 阴影的范围
    pannel.height = card.height+14;
    

    return pannel;
}

- (UIView*)createCommentView
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    UIView* card = [[UIView alloc]initWithFrame:CGRectMake(6, 7, ScreenW-12, 0)];
    [pannel addSubview:card];
    CGFloat y = 0;
    UILabel* title = [UILabel new];
    title.x = 33+6;
    title.y = 15;
    title.text = @"用户反馈";
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor wr_titleTextColor];
    [pannel addSubview:title];
    [title sizeToFit];
    y= 44;

    UIView * line  = [[UIView alloc]initWithFrame:CGRectMake(6, y, card.width, 0.5)];
    line.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:line];

    NSDictionary* commetArr = @[
                          @{@"name":@"用户：Ddz",@"time":@"2017-07-21",@"type":@"单次在线咨询服务",@"content":@"价格还行，很值。我咨询的时间比较长，但专家有问必答，很有耐心，而且说得让我容易理解，能解决我的问题。还推荐过app给朋友，他也说不错。"
                              },
                          @{@"name":@"用户：ZhEng",@"time":@"2017-07-26",@"type":@"签约私人专家服务",@"content":@"价格实惠，很划算，非常满意。我咨询的时候专家非常有耐心，能解决我的问题。继续用一段时间，效果好的话还会推荐给别人。"
                            },
                          @{@"name":@"用户：罗先生",@"time":@"2017-07-31",@"type":@"单次在线咨询服务",@"content":@"还可以，价格也不算贵，物有所值吧。因为专家解答得很明白也挺及时的，下次有问题还会来咨询。练一段时间，效果好的话就推荐给朋友。"
                            },
                          @{@"name":@"用户：Shalala",@"time":@"2017-07-27",@"type":@"签约私人专家服务",@"content":@"优惠价就挺好，只是原价有点小贵。效果好的话，还会推荐给朋友。只是晚上不能咨询，有点遗憾，毕竟白天要上班，晚上也能咨询的话会更好。"
                            }
  ];
    
     y = 45;
    for (NSDictionary* comment in commetArr) {
        y += 13;
        UIView* cardsin = [[UIView alloc]initWithFrame:CGRectMake(10, y,
                                                                  
                                                                  card.width-20, 0)];
        [card addSubview:cardsin];
        cardsin.backgroundColor = [UIColor whiteColor];
        cardsin.layer.cornerRadius = 5;
        cardsin.layer.shadowOpacity = 0.15;// 阴影透明度
        //    card.layer.masksToBounds =YES;
        cardsin.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
        
        //    card.layer.borderColor = [UIColor blackColor].CGColor;
        //    card.layer.borderWidth =0.5;
        
        cardsin.layer.shadowRadius = 7;// 阴影扩散的范围控制
        
        cardsin.layer.shadowOffset  = CGSizeMake(2, 2);
        
        UILabel* title = [UILabel new];
        title.x = 16;
        title.y = 14;
        title.text = comment[@"name"];
        title.font = [UIFont systemFontOfSize:15];
        title.textColor = [UIColor wr_titleTextColor];
        [cardsin addSubview:title];
        [title sizeToFit];
        
        UILabel* type = [UILabel new];
        type.x = 16;
        type.y = title.bottom+10;
        type.text = comment[@"type"];
        type.font = [UIFont systemFontOfSize:13];
        type.textColor = [UIColor wr_detailTextColor];
        [cardsin addSubview:type];
        [type sizeToFit];
        
        UILabel* time = [UILabel new];
        time.y = title.bottom+10;
        time.text = comment[@"time"];
        time.font = [UIFont systemFontOfSize:13];
        time.textColor = [UIColor wr_detailTextColor];
       // [cardsin addSubview:time];
        [time sizeToFit];
        time.right = cardsin.width- 16;

        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(10, time.bottom+14, cardsin.width-20, 0.5)];
        line.backgroundColor = [UIColor wr_lineColor];
        [cardsin addSubview:line];
        y= line.bottom;
        
        UILabel* longDetail = [UILabel new];
        longDetail.x= 14;
        longDetail.y= y+12;
        longDetail.text = comment[@"content"];
        longDetail.numberOfLines = 0;
        longDetail.font = [UIFont systemFontOfSize:13];
        longDetail.width = cardsin.width-16*2;
        longDetail.textColor = [UIColor wr_titleTextColor];
        [UILabel changeLineSpaceForLabel:longDetail WithSpace:7];
        [cardsin addSubview:longDetail];
        [longDetail sizeToFit];
       cardsin.height = longDetail.bottom+16;
        
        y = cardsin.bottom;
        
        
        
    }
    
    y+=13;
    
    card.height = y;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 5;
    card.layer.shadowOpacity = 0.15;// 阴影透明度
    //    card.layer.masksToBounds =YES;
    card.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
    
    //    card.layer.borderColor = [UIColor blackColor].CGColor;
    //    card.layer.borderWidth =0.5;
    
    card.layer.shadowRadius = 7;// 阴影扩散的范围控制
    
    card.layer.shadowOffset  = CGSizeMake(2, 2);// 阴影的范围
    pannel.height = card.height+14;
    
    return pannel;
    
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
