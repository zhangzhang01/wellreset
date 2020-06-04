//
//  TreatNameController.m
//  rehab
//
//  Created by yongen zhou on 2017/11/20.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "TreatNameController.h"

@interface TreatNameController ()<UITextFieldDelegate>
@property UITextField* name;
@end

@implementation TreatNameController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.view removeAllSubviews
     ];
    self.title = @"完成自建方案";
    UILabel* la1 = [UILabel new];
    la1.y = 57;
    la1.text = @"请为您的自建方案命名";
    la1.font = [UIFont systemFontOfSize:15];
    la1.textColor = [UIColor wr_titleTextColor];
    [la1 sizeToFit];
    la1.centerX = ScreenW*1.0/2;
    [self.view addSubview:la1];
    
    
    UILabel* la2 = [UILabel new];
    la2.y = la1.bottom+8;
    la2.text = @"（最多6个字）";
    la2.font = [UIFont systemFontOfSize:15];
    la2.textColor = [UIColor wr_detailTextColor];
    [la2 sizeToFit];
    la2.centerX = ScreenW*1.0/2;
    [self.view addSubview:la2];
    
    UITextField* textf = [UITextField new];
    textf.x = 32;
    textf.y = 40+la2.bottom;
    textf.width = ScreenW-32*2;
    textf.height = 44;
    textf.layer.cornerRadius = 2;
    textf.layer.borderColor = [UIColor wr_detailTextColor].CGColor;
    textf.layer.borderWidth = 1;
    [self.view addSubview:textf];
    textf.text = self.namel.length>0?self.namel:@"";
    self.name =  textf;
    textf.delegate = self;
    
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0,YYScreenSize().height-57-64, ScreenW, 57)];
    [btn setTitle:@"完成" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.backgroundColor = [UIColor wr_themeColor];
    
    [self.view addSubview:btn];
    
    
    
    [btn bk_whenTapped:^{
        if (textf.text.length!=0) {
            
        NSMutableDictionary* date = [NSMutableDictionary dictionary];
        date[@"rehabName"] = self.name.text;
        
        NSMutableArray* arr = [NSMutableArray array];
        for (FavorContent* con in self.arry ) {
            NSMutableDictionary* info = [NSMutableDictionary dictionary];
            info[@"contentId"] = con.contentId;
            info[@"type"] = [NSString stringWithFormat:@"%@",con.type];
            [arr addObject:info];
            
        }
        date[@"info"] = arr;
            if (self.indexid&&[[NSUserDefaults standardUserDefaults]objectForKey:self.indexid]) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:self.indexid];
        }
        
        [self showDataTreatData:[date jsonStringEncoded] IndexId:self.indexid];
        
        }
        else
        {
            [AppDelegate show:@"方案名称不能为空"];
        }
        
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[textField.text stringByReplacingCharactersInRange:range withString:string] length]>6) {
        return NO;
    }
    else
    {
        return YES;
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
