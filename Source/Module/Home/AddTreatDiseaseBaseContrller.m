//
//  AddTreatDiseaseBaseContrller.m
//  rehab
//
//  Created by yongen zhou on 2017/3/3.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "AddTreatDiseaseBaseContrller.h"
#import "TreatDiseaseController.h"
#import "TreatDiseaseSelectorController.h"
#import "UIViewController+WR.h"
@implementation AddTreatDiseaseBaseContrller
- (instancetype)init{
    
    
    
    
    
    
    
    if (self = [super initWithTagViewHeight:35]) {
        
        
    }
    
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationItem.hidesBackButton = YES;
    [self createBackBarButtonItem];
    self.title =@"添加方案";
    self.tagItemSize = CGSizeMake(self.view.width*1.0/4, 35);
    self.normalTitleFont=[UIFont systemFontOfSize:13];
    self.selectedTitleFont=[UIFont systemFontOfSize:13];
    self.selectedTitleColor = [UIColor wr_themeColor];
    

    
    NSArray *titleArray = @[
                            @"腰部",
                            @"颈部",
                            @"肩部",
                            @"四肢"
                           
                            
                            
                            
                            ];
    
    NSArray *classNames = @[
                            
                            [TreatDiseaseController  class],
                            [TreatDiseaseController class],
                            [TreatDiseaseController class],
                            [TreatDiseaseController class]
                            
                            ];
    self.titlearr=titleArray;
    
    self.selectedIndicatorSize=CGSizeMake(self.view.width/4.0, 2);
    self.selectedIndicatorColor=[UIColor wr_themeColor];
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:@[@"腰",@"颈",@"肩",@"四肢"]];
    
    // Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated
{[super viewDidAppear:YES];
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
