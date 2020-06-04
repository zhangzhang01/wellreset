//
//  OrderDetailController.m
//  rehab
//
//  Created by yongen zhou on 2017/6/30.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "OrderDetailController.h"
#import "PayImViewModel.h"
#import "PayforIMcontroller.h"
@interface OrderDetailController ()
@property (weak, nonatomic) IBOutlet UIImageView *orderStateIm;
@property (weak, nonatomic) IBOutlet UILabel *pruductNae;
@property (weak, nonatomic) IBOutlet UILabel *productType;
@property (weak, nonatomic) IBOutlet UILabel *cout2;
@property (weak, nonatomic) IBOutlet UILabel *cout;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *sn;
@property (weak, nonatomic) IBOutlet UILabel *detai;
@property (weak, nonatomic) IBOutlet UITableViewCell *Longcell;
@property (nonatomic)WRImOrder * order;
@property PayImViewModel * viewModel;
@end

@implementation OrderDetailController
-(instancetype)init
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"orderdetail"];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [PayImViewModel new];
     [self createBackBarButtonItem];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.viewModel fetchOrderDetailWithorderId:self.orderId completion:^(NSError * _Nonnull error) {
        self.order = self.viewModel.detail;
        switch (self.order.status) {
            case 0:
                [self.orderStateIm setImage:[UIImage imageNamed:@"待付款"]];
                break;
            case 1:
                [self.orderStateIm setImage:[UIImage imageNamed:@"已付款"]];
                break;
            case 2:
                [self.orderStateIm setImage:[UIImage imageNamed:@"已完成"]];
                break;
                
                
            default:
                break;
        }
        self.pruductNae.text =self.order.productName;
        self.sn.text = [NSString stringWithFormat:@"订单编号：%@\n",self.order.orderNo];
        NSMutableString* detail = [NSMutableString string];
        [detail appendFormat:@"%@", [NSString stringWithFormat:@"订单时间：%@\n",self.order.createTime]];
        if (![self.order.payTime isKindOfClass:[NSNull class]]&&![self.order.createTime isEqualToString:@""]) {
            [detail appendFormat:@"%@", [NSString stringWithFormat:@"付款时间：%@\n",self.order.createTime]];
            
        }
        if (self.order.type == 1) {
            self.productType.text = @"单次";
            self.cout2.text = [NSString stringWithFormat:@"单次在线咨询    ￥%ld元 / 次",self.order.productPrice];
            
            if (![self.order.finishTime isKindOfClass:[NSNull class]]&&![self.order.finishTime isEqualToString:@""]) {
                [detail appendFormat:@"%@", [NSString stringWithFormat:@"结束时间：%@\n",self.order.finishTime]];
                
            }
            else
            {
                [detail appendString:@"服务中..."];
            }
            
            
        }
        else
        {
            self.productType.text = @"签约";
            self.cout.text = [NSString stringWithFormat:@"签约私人专家    ￥%ld元 / 月",self.order.productPrice];
            NSDateFormatter* format =[NSDateFormatter new];
            [format setDateFormat:@"YYYY.MM.dd"];
            NSDate* timestar = [NSDate dateWithString:self.order.startDate];
            NSDate* timeend = [NSDate dateWithString:self.order.endDate];
            
            self.date.text = [NSString stringWithFormat:@"签约期限：%@~%@",[format stringFromDate:timestar],[format stringFromDate:timeend]];

        }
        self.detai.text = detail;
        self.price.text = [NSString stringWithFormat:@"订单金额：￥%ld",self.order.productPrice];
        if (self.order.status ==0) {
            self.btn.hidden =NO;
            self.btn.layer.cornerRadius = 5;
            self.btn.layer.masksToBounds =YES;
            self.btn.layer.borderColor = [UIColor colorWithHexString:@"ca1521"].CGColor;
            self.btn.layer.borderWidth =1;
            [self.btn bk_whenTapped:^{
                PayforIMcontroller* py = [PayforIMcontroller new];
                py.canpay = self.order.type;
                [self.navigationController pushViewController:py animated:YES];
            }];
            
        }
        else
        {
            self.btn.hidden =YES;
        }
        [self.tableView reloadData];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.Listorder.type ==1) {
        if (indexPath.row==1||indexPath.row==3) {
            return 0;
        }
    }
    else
    {
        if (indexPath.row==2) {
            return 0;
        }
    }
    
    switch (indexPath.row) {
        case 0:
            return 37;
        case 1:
            return 133;
        case 2:
            return 89;
        case 3:
            return 41;
        case 4:
            return 41;
        case 5:
            return 200;
  
            
            break;
            
        default:
            return 0;
            break;
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
