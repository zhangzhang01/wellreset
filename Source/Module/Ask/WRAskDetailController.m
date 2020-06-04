//
//  WRAskDetailController.m
//  rehab
//
//  Created by yongen zhou on 2017/4/26.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRAskDetailController.h"
#import "AskDetailViewModel.h"
@interface WRAskDetailController ()
{
    UIScrollView* _ba;
}
@property NSString* content;
@property NSString* content1;
@property (nonatomic)AskDetailViewModel* viewModel;

@property NSString* content2;
@end

@implementation WRAskDetailController
-(instancetype)init
{
    if(self = [super init]){
        //        [self layoutCommentView];
        //        [self.view addSubview:commentView];
        self.viewModel = [AskDetailViewModel new];
        
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    _ba = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_ba];
    
    

    
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{

    [self fetup];
    
}
- (void)layOut
{
    CGFloat y =0;
    UIView* ask =[self createAskView];
    y+=ask.bottom;
    [_ba addSubview:ask];
    UIView*line = [[UIView alloc]initWithFrame:CGRectMake(0,y , ScreenW, 5)];
    line.y = y;
    line.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [_ba addSubview:line];
    y+=5;
    UIView* reply = [self createReplayView];
    reply.y = y;
    y = reply.bottom;
    [_ba addSubview:reply];
    _ba.contentSize = CGSizeMake(ScreenW, y);

        
}

-(void)fetup
{
    [self.viewModel fetchCommentListWithReply:self.model.indexId completion:^(NSError * _Nonnull error) {
        self.content = self.viewModel.content;
        self.content1 = self.viewModel.content1;
        self.content2 = self.viewModel.content2;
        
        [self layOut];
    }];
}

- (UIView*)createAskView
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    CGFloat y = 0;
    y += 24;
    UILabel* asklabel = [UILabel new];
    asklabel.text = @"提问";
    asklabel.y = y;
    asklabel.font = [UIFont boldSystemFontOfSize:15];
    asklabel.textColor = [UIColor colorWithHexString:@"333333"];
    [asklabel sizeToFit];
    asklabel.centerX = self.view.centerX;
    [pannel addSubview:asklabel];
    
    UIImageView* left = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"左"]];
    left.right = asklabel.left-10;
    left.centerY = asklabel.centerY;
    [pannel addSubview:left];
    
    UIImageView* right = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"右"]];
    right.left = asklabel.right+10;
    right.centerY = asklabel.centerY;
    [pannel addSubview:right];
    
//    UIImageView* head = [UIImageView new];
//    head.x = WRUIBigOffset;
//    head.y = 46;
//    head.width = head.height = 22;
//    [head setImageWithURL:[NSURL URLWithString:self.model.headImage] placeholder:[WRUIConfig defaultHeadImage]];
//    [_ba addSubview:head];
    
//    UILabel* name = [UILabel new];
//    name.text = self.model.userName;
//    name.font = [UIFont systemFontOfSize:WRDetailFont];
//    name.textColor = [UIColor colorWithHexString:@"333333"];
//    [name sizeToFit];
//    name.x = head.x+12;
//    name.centerY = head.centerY;
//    [_ba addSubview:name];
    
    UILabel* time = [UILabel new];
    time.text = self.model.askTime;
    time.font = [UIFont systemFontOfSize:WRDetailFont];
    time.textColor = [UIColor colorWithHexString:@"b5b5b5"];
    [time sizeToFit];
    time.x = WRUIBigOffset;
    time.y = 46;
    [pannel addSubview:time];
    
    UIView*line = [[UIView alloc]initWithFrame:CGRectMake(0,time.bottom+10 , ScreenW, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    [pannel addSubview:line];
    
    UILabel* arti = [UILabel new];
    arti.numberOfLines =0;
    arti.text = self.model.question;
    arti.y = line.bottom+12;
    arti.x = WRUIBigOffset;
    arti.font = [UIFont systemFontOfSize:WRDetailFont];
    arti.textColor = [UIColor colorWithHexString:@"333333"];
    arti.width = ScreenW-2*WRUIBigOffset;
    [arti sizeToFit];
    [pannel addSubview:arti];
    
    pannel.height+= arti.bottom+17;
    
    
    
    return pannel;
}

- (UIView*)createReplayView
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    CGFloat y = 0;
    y += 24;
    UILabel* asklabel = [UILabel new];
    asklabel.text = @"专家问答";
    asklabel.y = y;
    asklabel.font = [UIFont boldSystemFontOfSize:15];
    asklabel.textColor = [UIColor colorWithHexString:@"333333"];
    [asklabel sizeToFit];
    asklabel.centerX = self.view.centerX;
    [pannel addSubview:asklabel];
    
    UIImageView* left = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"左"]];
    left.right = asklabel.left-10;
    left.centerY = asklabel.centerY;
    [pannel addSubview:left];
    
    UIImageView* right = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"右"]];
    right.left = asklabel.right+10;
    right.centerY = asklabel.centerY;
    [pannel addSubview:right];
    
    
    
    if (_content&&![self.content isEqualToString:@""]) {
     
        UILabel* arti = [UILabel new];
        arti.numberOfLines =1;
        arti.text = self.model.content;
        arti.y = asklabel.bottom+18;
        arti.x = WRUIBigOffset;
        arti.font = [UIFont boldSystemFontOfSize:WRDetailFont];
        arti.textColor = [UIColor colorWithHexString:@"333333"];
        arti.width = ScreenW-2*WRUIBigOffset;
        
        [pannel addSubview:arti];
        arti.text = @"【第一次回复】";
        [arti sizeToFit];
        UILabel* arti1 = [UILabel new];
        arti1.numberOfLines =0;
        arti1.text = self.model.content;
        arti1.y = arti.bottom+5;
        arti1.x = WRUIBigOffset;
        arti1.font = [UIFont systemFontOfSize:WRDetailFont];
        arti1.textColor = [UIColor colorWithHexString:@"333333"];
        arti1.width = ScreenW-2*WRUIBigOffset;
        
        [pannel addSubview:arti1];
        arti1.text =self.content;
        [arti1 sizeToFit];
        y = arti1.bottom;
        
        if (self.content1&&![self.content1 isEqualToString:@""]) {
            UIView*line = [[UIView alloc]initWithFrame:CGRectMake(0,y+15 , ScreenW, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"ededed"];
            [pannel addSubview:line];
            
            y = line.bottom;
            
            UILabel* arti2 = [UILabel new];
            arti2.numberOfLines =0;
            arti2.text = self.model.content;
            arti2.y = y+15;
            arti2.x = WRUIBigOffset;
            arti2.font = [UIFont boldSystemFontOfSize:WRDetailFont];
            arti2.textColor = [UIColor colorWithHexString:@"333333"];
            arti2.width = ScreenW-2*WRUIBigOffset;
            
            [pannel addSubview:arti2];
            arti2.text = @"【第二次回复】";
            [arti2 sizeToFit];
            UILabel* arti3 = [UILabel new];
            arti3.numberOfLines =0;
            arti3.text = self.model.content;
            arti3.y = arti2.bottom+5;
            arti3.x = WRUIBigOffset;
            arti3.font = [UIFont systemFontOfSize:WRDetailFont];
            arti3.textColor = [UIColor colorWithHexString:@"333333"];
            arti3.width = ScreenW-2*WRUIBigOffset;
            
            [pannel addSubview:arti3];
            arti3.text =self.content1;
            [arti3 sizeToFit];
            y = arti3.bottom;

            
            
        
        if (self.content2&&![self.content2 isEqualToString:@""]) {
            UIView*line = [[UIView alloc]initWithFrame:CGRectMake(0,y+15 , ScreenW, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"ededed"];
            [pannel addSubview:line];
            
            y = line.bottom;
            
            UILabel* arti4 = [UILabel new];
            arti4.numberOfLines =1;
            arti4.text = self.model.content;
            arti4.y = y+15;
            arti4.x = WRUIBigOffset;
            arti4.font = [UIFont boldSystemFontOfSize:WRDetailFont];
            arti4.textColor = [UIColor colorWithHexString:@"333333"];
            arti4.width = ScreenW-2*WRUIBigOffset;
            
            [pannel addSubview:arti4];
            arti4.text = @"【第三次回复】";
            [arti4 sizeToFit];
            UILabel* arti5 = [UILabel new];
            arti5.numberOfLines =0;
            arti5.text = self.model.content;
            arti5.y = arti4.bottom+5;
            arti5.x = WRUIBigOffset;
            arti5.font = [UIFont systemFontOfSize:WRDetailFont];
            arti5.textColor = [UIColor colorWithHexString:@"333333"];
            arti5.width = ScreenW-2*WRUIBigOffset;
            
            [pannel addSubview:arti5];
            arti5.text =self.content2;
            [arti5 sizeToFit];
            y = arti3.bottom;

        }
        
        }
        
        
    }
    else
    {
        UILabel* arti = [UILabel new];
        arti.numberOfLines =0;
        arti.text = self.model.content;
        arti.y = asklabel.bottom+18;
        arti.x = WRUIBigOffset;
        arti.font = [UIFont systemFontOfSize:WRDetailFont];
        arti.textColor = [UIColor colorWithHexString:@"333333"];
        arti.width = ScreenW-2*WRUIBigOffset;
        
        [pannel addSubview:arti];
        
        arti.text = @"我们的专家将在24时内尽快回复您。";
        [arti sizeToFit];
        y = arti.bottom;
    }
    
    
    pannel.height = y+15;
    return pannel;
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
