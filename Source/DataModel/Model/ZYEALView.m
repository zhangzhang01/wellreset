//
//  ZYEALView.m
//  rehab
//
//  Created by yongen zhou on 2017/10/25.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "ZYEALView.h"
#define W 281.f
#define H 217.f
#define opkey @"well@health-cn.*(validate)^-!"
#import "DES3Util.h"
@implementation ZYEALView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame]) {
        
        
    }
    return self;
}
-(instancetype)init
{
    
     self = [self initWithFrame:CGRectMake(0, 0, W, H)];
    
    return self;
}
- (instancetype)initwithPhone:(NSString*)phone type:(NSString*)type;

{
    if (self == [super initWithFrame:CGRectMake(0, 0, W, H)]) {
        
        _phone = phone;
        _type = type;
        [self layout];
    }
    return self;
}


-(void)layout
{
    UILabel* title = [UILabel new];
    title.y = 20;
    title.width = W;
    title.x = 0;
    title.height = 16;
    title.font = [UIFont boldSystemFontOfSize:15];
    title.text = @"获取短信验证码";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor wr_titleTextColor];
    
    [self addSubview:title];
    self.title = title;
    
    UIView* bac = [UIView new];
    bac.width = 200;
    bac.height = 48;
    bac.top = self.title.bottom+20;
    bac.centerX = W/2;
    bac.layer.borderColor = [UIColor colorWithHexString:@"dcdcdc"].CGColor;
    bac.layer.borderWidth = 1;
    [self addSubview:bac];
    self.bacview = bac;
    [self getcode];
    
    UITextField* field = [UITextField new];
    field.y = 20+bac.bottom;
    field.x = 30;
    field.height = 33;
    field.width = W-60;
    field.placeholder = @"请输入图片验证码";
    field.font = [UIFont systemFontOfSize:WRDetailFont];
    self.textfield = field;
    [self addSubview:field];
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(30, field.bottom, W-60, 1)];
    line.backgroundColor =[UIColor wr_lineColor];
    [self addSubview:line];
    
    UIButton* close = [[UIButton alloc]initWithFrame:CGRectMake(0, H-60, W/2, 60)];
    [close setTitle:@"取消" forState:0];
    [close setTitleColor:[UIColor colorWithHexString:@"313131"] forState:0];
    close.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:close];
    [close bk_whenTapped:^{
        self.clossBlock();
    }];
    
    UIButton* sure = [[UIButton alloc]initWithFrame:CGRectMake(W/2, H-60, W/2, 60)];
    [sure setTitle:@"确定" forState:0];
    [sure setTitleColor:[UIColor wr_themeColor] forState:0];
    sure.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:sure];
    [sure bk_whenTapped:^{
        [SVProgressHUD showWithStatus:nil]; self.completionBlock(self.textfield.text,_codeid);
    }];
    
    UIView* linemid = [[UIView alloc]initWithFrame:CGRectMake(W/2, sure.top+22.5, 1, 15)];
    linemid.backgroundColor =[UIColor wr_lineColor];
    [self addSubview:linemid];
    
    
    
}
- (void)getcode
{
    
    [WRViewModel requestavCodeWithPhone:_phone type:_type completion:^(NSError * _Nonnull eror, NSString * _Nonnull codeAes, NSString * _Nonnull Id) {
        [SVProgressHUD dismiss];
        if (eror) {
            [AppDelegate show:eror.domain];
        }
        else
        {
            self.codeid = Id;
            if (!self.codeview) {
                NSString* str = [codeAes lowercaseString];
                SDauthCode* codeview = [[SDauthCode alloc]initWithFrame:self.bacview.bounds authCodeString:[DES3Util decryptUseDES:str key:opkey]];
                
                NSString* ce = [DES3Util decryptUseDES:str key:opkey];
            
                [self.bacview addSubview:codeview];
                self.codeview = codeview;
                [codeview bk_whenTapped:^{
                    [self getcode];
                }];
                
            }
            else
            {
                NSString* str = [codeAes lowercaseString];
                self.codeview.authCodeString = [DES3Util decryptUseDES:str key:opkey];
                [self.codeview reloadAuthCodeView];
            }
            
        }
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
