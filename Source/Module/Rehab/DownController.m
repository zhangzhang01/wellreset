//
//  DownController.m
//  rehab
//
//  Created by yongen zhou on 2017/11/20.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "DownController.h"

@interface DownController ()
@property (weak, nonatomic) IBOutlet UIButton *godown;
@property (weak, nonatomic) IBOutlet UILabel *now;
@property (weak, nonatomic) IBOutlet UILabel *candownL;
@property (weak, nonatomic) IBOutlet UILabel *nowlevel;
@property (weak, nonatomic) IBOutlet UILabel *golevel;
@property (weak, nonatomic) IBOutlet UIView *noview;

@end

@implementation DownController
-  (instancetype)init
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"down"];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    self.title = @"方案降阶";
    
    NSUInteger stage = 0;
    if (self.rehab.stageSet.count > 0) {
        WRTreatRehabStage *rehabStage = self.rehab.stageSet.firstObject;
    }
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated

{
    if (self.candown) {
        self.noview.hidden = YES;
        self.godown.hidden = NO;
    }
    else
    {
        self.noview.hidden = NO;
        self.godown.hidden = YES;
    }
    NSUInteger stage = 0;
    if (self.rehab.stageSet.count > 0) {
        WRTreatRehabStage *rehabStage = self.rehab.stageSet.firstObject;
        stage = rehabStage.stage;
    }
    self.now.text = [NSString stringWithFormat:@"目前您%@定制方案处于第%ld阶",self.rehab.disease.diseaseName,stage];
    self.candownL.text = [NSString stringWithFormat:@"〔  可降至第%ld阶  〕",stage-1];
    self.nowlevel.text = [NSString stringWithFormat:@"%ld",stage];
    self.golevel.text = [NSString stringWithFormat:@"%ld",stage-1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)godownre:(UIButton *)sender {
    
    WRRehabDisease *disease = self.rehab.disease;
    
    NSUInteger stage = 0;
    if (self.rehab.stageSet.count > 0) {
        WRTreatRehabStage *rehabStage = self.rehab.stageSet.firstObject;
        stage = rehabStage.stage - 1;
    }
    //    [self generaNewProTreatRehabWithDisease:disease stage:stage fromController:self.navigationController rootViewController:[self.class root]];
    
    [self pushProTreatRehabWithDisease:disease stage:stage upgrade:@"1"];
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
