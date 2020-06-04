//
//  PayforIMcontroller.m
//  rehab
//
//  Created by yongen zhou on 2017/6/27.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "PayforIMcontroller.h"
#import "PayImViewModel.h"
//#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
//#import "ChatViewController.h"
#import "PayCenter.h"
#define ORDER_PAY_NOTIFICATION @"wxpay"
@interface PayforIMcontroller ()<WXApiDelegate>
{
    UIScrollView* _ba;
}
@property PayImViewModel* viewModel;
@property NSInteger payType;
@property NSInteger type;
@property UIImageView* typeIm;
@property UIImageView* payTypeIm;
@property NSString* code;
@property BOOL push;
@property UILabel* buy;
@property UITextField * name;
@property UITextField * contact;
@end

@implementation PayforIMcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    self.type = 1;
    self.payType = 101;
    self.viewModel = [PayImViewModel new];
    _ba = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.view.height-64)];
    [self.view addSubview:_ba];
    [self createBackBarButtonItem];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:ORDER_PAY_NOTIFICATION object:nil];
    
    [self.viewModel fetchProductlistcompletion:^(NSError * _Nonnull error) {
        [self.viewModel fetchAlreadyOrdercompletion:^(NSError * _Nonnull error) {
            [self layout];
        }];

    }];
    
}
-(void)layout
{
    [_ba removeAllSubviews];
    CGFloat y =0;
    UIView* type = [self craeteChoosetype];
    [_ba addSubview:type];
    y = type.bottom;
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, y, ScreenW, 5)];
    line.backgroundColor = [UIColor wr_lineColor];
    [_ba addSubview:line];
    y+=5;
    UIView* typepay = [self createMust];
    typepay.y = y;
    [_ba addSubview:typepay];
    
    _ba.contentSize = CGSizeMake(ScreenW, type.bottom);
    
    UIView* bootom = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-42, ScreenW, 42)];
    bootom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bootom];
    
    UILabel* la = [UILabel new];
    la.x =19;
    la.text = (self.type==1)?[NSString stringWithFormat:@"￥%@元/1次",self.viewModel.money1]: [NSString stringWithFormat:@"￥%@元/1月",self.viewModel.money2];
    la.textColor = [UIColor wr_themeColor];
    la.font = [UIFont systemFontOfSize:15];
    [la sizeToFit];
    la.centerY =21;
    [bootom addSubview:la];
    self.buy = la;
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW-114, 0, 114, 42)];
    btn.backgroundColor = [UIColor wr_themeColor];
    [btn setTitle:@"购买" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bootom addSubview:btn];
    
    
    bootom.layer.shadowOpacity = 0.15;// 阴影透明度
    //    card.layer.masksToBounds =YES;
    bootom.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
    
    //    card.layer.borderColor = [UIColor blackColor].CGColor;
    //    card.layer.borderWidth =0.5;
    
    bootom.layer.shadowRadius = 7;// 阴影扩散的范围控制
    
    bootom.layer.shadowOffset  = CGSizeMake(2, 2);
    
    
    [btn bk_whenTapped:^{
        
        if (self.name.text.length>0&&self.contact.text.length>0) {
            WRUserInfo* info = [WRUserInfo selfInfo];
            info.realname = self.name.text;
            info.contact = self.contact.text;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"realname"] = self.name.text;
            params[@"contact"] = self.contact.text;
            
            
            [WRViewModel modifySelfBasicInfo:params completion:^(NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                if (error) {
                    NSString *errorString = error.domain;
                    [AppDelegate show:errorString];
                    
                }
                else
                {
                    [self.viewModel fetchProductlistcompletion:^(NSError * _Nonnull error) {
                        NSString* product;
                        if (self.type ==1) {
                            product=self.viewModel.id1;
                        }
                        else
                        {
                            product=self.viewModel.id2;
                        }
                        [self.viewModel fetchdoOrderWithOrder:product completion:^(NSError * _Nonnull error) {
                            NSString* productId = nil;
                            if (self.type ==1) {
                                productId = @"well_ask_one_OR";
                            }
                            else
                            {
                                productId = @"well_ask_apply";
                            }
                            PayCenter* py = [PayCenter defaultCenter];
                            py.orderId = self.viewModel.orderId;
                            [py payForProductWithIdentify:productId];
                            
                            py.completionBlock = ^{
                                
//                                UIViewController *chatController = nil;
//                                chatController = [[ChatViewController alloc] initWithConversationChatter:@"rudy123" conversationType:0];
//
//                                chatController.hidesBottomBarWhenPushed =YES;
//
//                                [self.navigationController pushViewController:chatController animated:YES];
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
//                                self.push = YES;
                                
                                
                                
                            };
                            
                            
                            
                            
                            
                            //                [self.viewModel fetchdoPayWithorderId:self.viewModel.orderId payType:[NSString stringWithFormat:@"%ld",self.payType-101] completion:^(NSError * _Nonnull error) {
                            //
                            //                    if (self.payType == 102) {
                            //                        NSString *appScheme = @"WELL-health";
                            //                        [[AlipaySDK defaultService] payOrder:self.viewModel.payinfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            //                            NSLog(@"reslut = %@",resultDic);
                            //
                            //
                            //                            NSString*resultStatus=resultDic[@"resultStatus"];
                            //
                            //
                            //
                            //
                            //                        }];
                            //                    }
                            //                    else
                            //                    {
                            //                        NSString* appid=self.viewModel.payinfo[@"appid"];
                            //                        NSString* partnerId = self.viewModel.payinfo[@"partnerid"];
                            //                        NSString* prepayId= self.viewModel.payinfo[@"prepayid"];
                            //                        NSString* package = @"Sign=WXPay";
                            //                        NSString* nonceStr= self.viewModel.payinfo[@"noncestr"];
                            //
                            //
                            //                        PayReq *request = [[PayReq alloc]init];
                            //                        request.openID=appid;
                            //                        request.partnerId =partnerId;
                            //                        request.prepayId= prepayId;
                            //                        request.package = package;
                            //                        request.nonceStr= nonceStr;
                            //                        request.timeStamp = [self.viewModel.payinfo[@"timestamp"] intValue];
                            //                        request.sign= self.viewModel.payinfo[@"sign"];
                            //                        [WXApi sendReq:request];
                            //
                            //                    }
                            //
                            //                }];
                            //
                            //
                        }];
                    }];
                }
            }
                ];
        
        
        
        
        }
        else
        
        {
            [AppDelegate show:@"请输入个人信息"];
        }
        
        
        
        
        
        
    }];
        
    

}


- (UIView*)craeteChoosetype
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    UILabel* title = [UILabel new];
    title.x = 18;
    title.y = 13;
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UIColor wr_titleTextColor];
    title.text = @"请选择服务";
    [title sizeToFit];
    [pannel addSubview:title];
    CGFloat y = title.bottom;
    UIView* line =[[UIView alloc]initWithFrame:CGRectMake(0, y+10, ScreenW, 1)];
    line.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:line];
    y= line.bottom;
    UIImageView* sinim = [UIImageView new];
    sinim.x = 18;
    sinim.y = 11+y;
    sinim.width = sinim.height = 60;
    [pannel addSubview:sinim];
    [sinim setImage:[UIImage imageNamed:@"在线咨询服务"]];
    UILabel* sinlabel = [UILabel new];
    sinlabel.x = sinim.right+10;
    sinlabel.y =19+y;
    sinlabel.text = [NSString stringWithFormat:@"单次在线咨询    ￥%@元 / 次",self.viewModel.money1];
    sinlabel.textColor = [UIColor wr_titleTextColor];
    sinlabel.font = [UIFont systemFontOfSize:13];
    
    [pannel addSubview:sinlabel];
    [sinlabel sizeToFit];
    UILabel* sindetail = [UILabel new];
    sindetail.x = sinim.right+10;
    sindetail.y = sinlabel.bottom+14;
    sindetail.text = @"可在线以文字、图片、语音的方式咨询";
    sindetail.textColor = [UIColor wr_detailTextColor];
    sindetail.font = [UIFont systemFontOfSize:13];
    [pannel addSubview:sindetail];
    [sindetail sizeToFit];

    UIImageView* chooseim = [UIImageView new];
    chooseim.width = chooseim.height = 13;
    chooseim.right = ScreenW-18;
    chooseim.y = 19+y;
    [pannel addSubview:chooseim];
    [chooseim setImage:[UIImage imageNamed:@"勾选点"]];
    y = sinim.bottom+15;
    self.typeIm = chooseim;
    
    line = [[UIView alloc]initWithFrame:CGRectMake(0, y, ScreenW, 1)];
    line.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:line];

    UIButton* sinbtn = [[UIButton alloc]initWithFrame:CGRectMake(0,35 , ScreenW, line.bottom-35)];
    [pannel addSubview:sinbtn];
    [sinbtn bk_whenTapped:^{
        [self.typeIm setImage:[UIImage imageNamed:@"默认点-1"]];
        [chooseim setImage:[UIImage imageNamed:@"勾选点"]];
        self.typeIm = chooseim ;
        self.type =1;
        self.buy.text = (self.type==1)?[NSString stringWithFormat:@"￥%@元/1次",self.viewModel.money1]: [NSString stringWithFormat:@"￥%@元/1月",self.viewModel.money2];
    }];
    if (self.canpay == 1) {
        chooseim.hidden = YES;
    }

    if (self.canpay == 2) {
        chooseim.hidden = YES;
        sinim.hidden= YES;
        sinlabel.hidden= YES;
        sinbtn.hidden =YES;
        sindetail.hidden =YES;
        line.hidden = YES;
        y = 35;
    }
    
    
    
    
    UIImageView* longim = [UIImageView new];
    longim.x = 18;
    longim.y = 11+y;
    longim.width = longim.height = 60;
    [longim setImage:[UIImage imageNamed:@"私人专家"]];
    [pannel addSubview:longim];
    UILabel* longlabel = [UILabel new];
    longlabel.x = sinim.right+10;
    longlabel.y = 19+y;
    longlabel.text = [NSString stringWithFormat:@"签约私人专家    ￥%@元 / 月",self.viewModel.money2];
    longlabel.textColor = [UIColor wr_titleTextColor];
    longlabel.font = [UIFont systemFontOfSize:13];
    [pannel addSubview:longlabel];
    [longlabel sizeToFit];
    UILabel* longdetail = [UILabel new];
    longdetail.x = longim.right+10;
    longdetail.y = longlabel.bottom+14;
    longdetail.numberOfLines =0;
    longdetail.text = @"可在线以文字、图片、语音的方式咨询\n签约私人专家后\n·  签约期间内不限咨询次数\n·  可获得专家回访";
    longdetail.textColor = [UIColor wr_detailTextColor];
    longdetail.font = [UIFont systemFontOfSize:13];
    [longdetail sizeToFit];
    [pannel addSubview:longdetail];
    
    
    UIImageView* longchooseim = [UIImageView new];
    longchooseim.width = longchooseim.height = 13;
    longchooseim.right = ScreenW-18;
    longchooseim.y = y + 19;
    [longchooseim setImage:[UIImage imageNamed:@"默认点-1"]];
    [pannel addSubview:longchooseim];

    y = longdetail.bottom+15;
    
    
    line =[[UIView alloc]initWithFrame:CGRectMake(0, y, ScreenW, 1)];
    line.backgroundColor = [UIColor wr_lineColor];
//    [pannel addSubview:line];
   UIButton*  longbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, sinim.bottom+15, ScreenW, line.bottom-(sinim.bottom+15))];
    [pannel addSubview:longbtn];
    [longbtn bk_whenTapped:^{
        [self.typeIm setImage:[UIImage imageNamed:@"默认点-1"]];
        [longchooseim setImage:[UIImage imageNamed:@"勾选点"]];
        self.typeIm = longchooseim ;
        self.type =2;
        self.buy.text = (self.type==1)?[NSString stringWithFormat:@"￥%@元/1次",self.viewModel.money1]: [NSString stringWithFormat:@"￥%@元/1月",self.viewModel.money2];
    }];
    
    if (self.canpay == 2) {
        longchooseim.hidden = YES;
        longbtn.hidden = YES;
        self.type = 2;
    }
    
    
    
    UILabel* timeline = [UILabel new];
    timeline.x = 18;
    timeline.y = 12+y;
    
    pannel.height = y+10;
    
    
    int i =0;
    NSDate * enddate = [NSDate new];
    NSDate* todate = [NSDate new];
    NSString* to = nil;
    for (NSDictionary* dic in self.viewModel.orderlist) {
        if ([dic[@"type"] intValue] ==2) {
            i = 1;
            to = dic[@"endDate"];
            enddate= [NSDate dateWithString:dic[@"createTime"]];
             todate = [NSDate dateWithString:dic[@"endDate"]];
        }
    }
    
    if (!to) {
        todate = [enddate dateByAddingMonths:1];
    }
    
    NSDateFormatter* format =[NSDateFormatter new];
    [format setDateFormat:@"YYYY.MM.dd"];

    
    timeline.text = [NSString stringWithFormat: @"签约期：%@~%@",[format stringFromDate:enddate],[format stringFromDate:todate]];
    timeline.textColor = [UIColor wr_detailTextColor];
    timeline.font = [UIFont systemFontOfSize:13];
//    [pannel addSubview:timeline];
    [timeline sizeToFit];
    NSString* text = longdetail.text;
    NSMutableString* str = [NSMutableString stringWithString:longdetail.text];
    [str appendFormat:@"\n签约期：%@~%@",[format stringFromDate:enddate],[format stringFromDate:todate]];
    
    longdetail.text = str;
    [longdetail sizeToFit];
    pannel.height = y+10;
    
    
    
    if (self.canpay == 1) {
        chooseim.hidden = YES;
        longchooseim.hidden =YES;
        longbtn.hidden = YES;
        longlabel.hidden = YES;
        longim.hidden =YES;
        longdetail.hidden = YES;
        timeline.hidden = YES;
        pannel.height = sindetail.bottom+15;
        self.type = 1;
        
    }
    
    return pannel;
}

- (UIView*)createMust
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    UILabel* title = [UILabel new];
    title.x = 18;
    title.y = 13;
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UIColor wr_titleTextColor];
    title.text = @"请确认个人信息";
    [title sizeToFit];
    [pannel addSubview:title];
    CGFloat y = title.bottom;
    UIView* line =[[UIView alloc]initWithFrame:CGRectMake(0, y+10, ScreenW, 1)];
    line.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:line];
    y= line.bottom;
    
    UILabel* name = [UILabel new];
    name.x = 27;
    name.y = y;
    name.height = 44;
    name.width = 122;
    name.text = @"姓名*";
    name.font = [UIFont systemFontOfSize:WRDetailFont];
    name.textColor = [UIColor wr_titleTextColor];
    
    [pannel addSubview:name];
    
    UITextField* namef = [UITextField new];
    namef.x = 122;
    namef.y = y;
    namef.height = 44;
    namef.width = ScreenW-122-16;
    namef.font = [UIFont systemFontOfSize:13];
    namef.placeholder = @"请输入您的姓名";
    namef.text = [WRUserInfo selfInfo].realname;
    [pannel addSubview:namef];
    self.name = namef;
    
    line =[[UIView alloc]initWithFrame:CGRectMake(18, namef.bottom, ScreenW, 1)];
    line.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:line];
    y= line.bottom;
    
    name = [UILabel new];
    name.x = 27;
    name.y = y;
    name.height = 44;
    name.width = 122;
    name.text = @"联系方式*";
    name.font = [UIFont systemFontOfSize:WRDetailFont];
    name.textColor = [UIColor wr_titleTextColor];
    
    [pannel addSubview:name];
    
    UITextField* conf = [UITextField new];
    conf.x = 122;
    conf.y = y;
    conf.height = 44;
    conf.width = ScreenW-122-16;
    conf.font = [UIFont systemFontOfSize:13];
    conf.placeholder = @"请输入您的手机号码";
    conf.text = [WRUserInfo selfInfo].contact.length>0?[WRUserInfo selfInfo].contact:[WRUserInfo selfInfo].phone;
    [pannel addSubview:conf];
    self.contact = conf;
    
    line =[[UIView alloc]initWithFrame:CGRectMake(0, conf.bottom, ScreenW, 1)];
    line.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:line];
    y= line.bottom;
    pannel.height = line.bottom;
    
    

    return pannel;
}
- (UIView*)createPayType
{
     UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    UILabel* title = [UILabel new];
    title.x = 18;
    title.y = 13;
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UIColor wr_titleTextColor];
    title.text = @"支付方式";
    [title sizeToFit];
    [pannel addSubview:title];
    CGFloat y = title.bottom;
    UIView* line =[[UIView alloc]initWithFrame:CGRectMake(0, y+10, ScreenW, 1)];
    line.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:line];
    y= line.bottom;
    
    NSArray* pays =@[@"苹果支付"];
    int i=0;
    for (NSString* str in  pays) {
        UIImageView* im = [[UIImageView alloc]initWithImage:[UIImage imageNamed:pays[i]]];
        im.x = 19;
        im.centerY = y+47*1.0/2;
        [pannel addSubview:im];
        UILabel* title = [UILabel new];
        title.x = im.right+14;
        
        title.font = [UIFont systemFontOfSize:13];
        title.textColor = [UIColor wr_titleTextColor];
        title.text = pays[i];
        [title sizeToFit];
        title.centerY = im.centerY;
        [pannel addSubview:title];
        UIImageView* chooseim = [UIImageView new];
        chooseim.tag = 101+i;
        chooseim.width = chooseim.height = 13;
        chooseim.right = ScreenW-18;
        chooseim.centerY = title.centerY;
        [pannel addSubview:chooseim];
        [chooseim setImage:[UIImage imageNamed:@"默认点-1"]];
        if (_payType == chooseim.tag) {
            [chooseim setImage:[UIImage imageNamed:@"勾选点"]];
            self.payTypeIm = chooseim;
        }
        line = [[UIView alloc]initWithFrame:CGRectMake(0, y, ScreenW, 1)];
        line.backgroundColor = [UIColor wr_lineColor];
        [pannel addSubview:line];

        
        UIButton* sinbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, y, ScreenW, 47)];
        //[pannel addSubview:sinbtn];
        [sinbtn bk_whenTapped:^{
            [self.payTypeIm setImage:[UIImage imageNamed:@"默认点-1"]];
            [chooseim setImage:[UIImage imageNamed:@"勾选点"]];
            self.payTypeIm = chooseim ;
            self.payType =101+i;
        }];
        y+=47;
        i++;
        
        
        
        
    }
    pannel.height = y;
    

    return pannel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.push =NO;
}
-(void)getOrderPayResult:(NSNotification*)sender
{
    if (!self.push) {
        if ([sender.object isEqualToString:@"success"]||[sender.object isEqualToString:@"9000"])
        {
//            UIViewController *chatController = nil;
//            chatController = [[ChatViewController alloc] initWithConversationChatter:@"rudy123" conversationType:0];
//
//            chatController.hidesBottomBarWhenPushed =YES;
//
//            [self.navigationController pushViewController:chatController animated:YES];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
//            self.push = YES;
            
        }
        else
        {
            [AppDelegate show:@"购买失败"];
            
        }
    }
        
        
    
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
