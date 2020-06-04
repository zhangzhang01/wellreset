//
//  UIViewController+WR.m
//  rehab
//
//  Created by Matech on 3/18/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "JCAlertView.h"
#import "LoginController.h"
#import "RehabController.h"
#import "TreatViewModel.h"
#import "UIViewController+WR.h"
#import "UserBasicInfoController.h"
#import "UserProfile.h"
#import "WRBaseViewController.h"
#import "WRPerfectView.h"
#import "QuestionareIndexController.h"
#import "ProTreatViewModel.h"
#import "RehabObject.h"
#import "WRUserInfo.h"
#import "FloatLoginView.h"
#import "QuestionController.h"
#import "WRTestBaseViewController.h"
#import "ShareData.h"
#import "CreatTreatController.h"
#import "ShareUserData.h"
static WRPerfectView *perfect;

@implementation UIViewController(WR)

+(UIViewController *)root {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(BOOL)checkUserLogState:(UIViewController *)fromController {
    if (fromController == nil) {
        fromController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    BOOL result = [[WRUserInfo selfInfo] isLogged];
    if (!result) {
        FloatLoginView *floatView = [[FloatLoginView alloc] initWithFrame:fromController.view.bounds];
        floatView.clickMoreBlock = ^{
            
            
        
            LoginController *viewController = [[LoginController alloc] init];
            UINavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];
            if ([WRUIConfig IsHDApp]) {
                nav.modalPresentationStyle = UIModalPresentationFormSheet;
                nav.providesPresentationContextTransitionStyle = YES;
                nav.definesPresentationContext = YES;
                nav.preferredContentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width*0.7f, [[UIScreen mainScreen] bounds].size.height*0.7f);
            }
            [fromController presentViewController:nav animated:YES completion:nil];
        
        };
        
        [Utility viewAddToSuperViewWithAnimation:floatView superView:fromController.view completion:nil];
    }
    return result;
}

-(void)wr_pushControllerFromRoot:(UIViewController *)viewController {
    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nc = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nc pushViewController:viewController animated:YES];
}

-(void)showSelfInfo {
    UIViewController *viewController = [[UserBasicInfoController alloc] init];
    WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];

    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
-(void)actionWithTreat:(id)data {
    
}


-(void)onClickedBackButton:(UIBarButtonItem *)sender {
    UIViewController *viewController = [self.navigationController popViewControllerAnimated:YES];
    if (viewController == nil)
    {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)createBackBarButtonItem {
    NSLog(@"????");
    
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 47)];
    [clearButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(onClickedBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    self.navigationItem.leftBarButtonItem = item;

}

-(void)createTitleViewWithTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:30];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    self.navigationItem.titleView = titleLabel;
}


#pragma mark - rehab
-(void)showTreatRehabWithDisease:(id)data isTreat:(BOOL)isTreat completion:(void(^)(UIViewController* controller))completion
{
    if (![self checkUserLogState:self.navigationController]) {
        return;
    }
    
    WRRehabDisease *disease = data;
    
    __weak __typeof(self) weakSelf = self;
    void (^block)(NSError *, id) = ^(NSError * error, id resultObject) {
        [SVProgressHUD dismiss];
        WRRehab *rehab  = resultObject;
       
        if ([Utility IsEmptyString:rehab.indexId] && rehab)
            {
                error = [NSError errorWithDomain:NSLocalizedString(@"获取数据失败", nil) code:-1 userInfo:nil];
            }
 
      
        if (error)
        {
//            12.22 fixbug
            if ([error.domain isEqualToString:@"没有权限"]) {
                [Utility alertWithViewController:weakSelf.navigationController title:error.domain buttonText:NSLocalizedString(@"购买", nil) completion:^{
                    
                }];
            } else{
                [Utility retryAlertWithViewController:weakSelf.navigationController title:error.domain completion:^{
                    [weakSelf showTreatRehabWithDisease:disease isTreat:isTreat completion:completion];
                }];
            }
        }
        else
        {
            if (completion) {
                rehab.disease.isProTreat = NO;
                RehabController *viewController = [[RehabController alloc] initWithRehab:rehab];
                viewController.umstr  = self.umstr;
                completion(viewController);
            }
        }
    };
    
    [SVProgressHUD showWithStatus:nil];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [TreatViewModel getTreatRehabDetail:disease.indexId completion:block];
}

-(void)presentTreatRehabWithDisease:(id)data isTreat:(BOOL)isTreat {
    __weak __typeof(self) weakSelf = self;
    [self showTreatRehabWithDisease:data isTreat:isTreat completion:^(UIViewController *controller) {
        UINavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:controller];
        [nav.navigationBar setTranslucent:NO];
        [[weakSelf.class root] presentViewController:nav animated:YES completion:nil];
    }];
}

-(void)pushTreatRehabWithDisease:(id)data isTreat:(BOOL)isTreat {
    __weak __typeof(self) weakSelf = self;
    [self showTreatRehabWithDisease:data isTreat:isTreat completion:^(UIViewController *controller) {
        controller.hidesBottomBarWhenPushed=YES;
        RehabController* vc = controller;
        
           vc.umstr  = self.umstr; 
        
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}
-(void)showTestRehabWithDisease:(id)data completion:(void(^)(UIViewController* controller))completion
{
    ProTreatViewModel *model = [[ProTreatViewModel alloc] init];

    [model fetchQuestionsWithCompletion:^(NSError * _Nonnull error, id object) {
        __strong __typeof(model) strongModel = model;
        if (error) {
            [AppDelegate show:error.domain];
        } else {
            
            QuestionController *viewController = [[QuestionController alloc] initWithProTreatViewModel:strongModel proTreatDisease:nil style:QuestionControllerDefault];
            viewController.newquestion =YES;
            viewController.stage = 0;
            viewController.proTreatDisease = nil;
            

                if (completion) {
                    completion(viewController);
                }
            }

        
        
    } specialtyId:@"dc20c10b-85f8-45fd-b485-fade4805b88c" diseaseId:@"cb888cb9-af32-47a8-8f69-2824b85d7e79" stage:0 indexId:nil upgrde:@"1"];
}
-(void)showProTreatRehabWithDisease:(WRRehabDisease*)disease stage:(NSInteger)stage upgrade:(NSString*)upgrade completion:(void(^)(UIViewController* controller))completion
{
    if (![self checkUserLogState:nil]) {
        return;
    }
    
    WRUserInfo *userInfo = [WRUserInfo selfInfo];
    NSString *emptyValueString = NSLocalizedString(@"未填写", nil);
    NSString *birthDay = userInfo.birthDay;
    NSLog(@"birthDay%@",birthDay);
    if ([Utility IsEmptyString:birthDay])
    {
        birthDay = emptyValueString;
    }
//    if((userInfo.height == 0 || userInfo.weight == 0 || [birthDay isEqualToString:emptyValueString]  || (userInfo.sex != GenderFemale && userInfo.sex != GenderMale))) {
//        if (perfect == nil) {
//            perfect = [[WRPerfectView alloc] init];
//        }
//        __weak __typeof(self)weakself = self;
//        perfect.completionBlock = ^{
//            [weakself showProTreatRehabWithDisease:disease stage:stage completion:completion];
//        };
//        [perfect showChooseSexViewWithViewControlllr:self];
//    } else
    
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在获取数据", nil)];
    
    BOOL isnew = false;

    BOOL cannew = false;
    for (WRRehabDisease* dis in [ShareData data].proTreatDisease)
    {
        if ([dis.indexId isEqualToString:@"cb888cb9-af32-47a8-8f69-2824b85d7e79"]) {
            cannew = YES;
        }
        
    }
    
    static BOOL have =NO;
    [[ShareUserData userData].proTreatRehab enumerateObjectsUsingBlock:^(WRRehab * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WRRehab* yao = obj;
        if ([yao.disease.indexId isEqualToString:@"cb888cb9-af32-47a8-8f69-2824b85d7e78"]) {
            
            
            have = YES;
        }
    }];
    
    
//    if ((([disease.indexId isEqualToString:@"cb888cb9-af32-47a8-8f69-2824b85d7e78"])&&(!have||stage>1))||([disease.indexId isEqualToString: @"cb888cb9-af32-47a8-8f69-2824b85d7e79"])) {
//        disease.indexId = @"cb888cb9-af32-47a8-8f69-2824b85d7e79";
//        isnew = YES;
//    }
    //5.0.3
        isnew = NO;
        ProTreatViewModel *model = [[ProTreatViewModel alloc] init];
        __weak __typeof(self) weakSelf = self;
        [model fetchQuestionsWithCompletion:^(NSError * _Nonnull error, id object) {
            [SVProgressHUD dismiss];
            WRRehab *rehab = object;
            
            __strong __typeof(model) strongModel = model;
            if (error) {
                [AppDelegate show:error.domain];
            } else {
                if (rehab) {
                    rehab.disease.isProTreat = YES;
                    RehabController *viewController = [[RehabController alloc] initWithRehab:rehab];
                    
                     viewController.umstr  = self.umstr;
                    viewController.title = [NSString stringWithFormat:@"%@ %@", disease.diseaseName, NSLocalizedString(@"定制方案", nil)];
                    if (completion) {
                        completion(viewController);
                    }
                } else {
                    
                        WRTestBaseViewController *viewController = [WRTestBaseViewController new];
                        viewController.stage = stage;
                        viewController.title = [NSString stringWithFormat:@"%@%@", disease.diseaseName, NSLocalizedString(@"定制", nil)];
                    viewController.proTreatDisease =disease;
                        viewController.viewmodel = model;
                        viewController.isnew =isnew;
                        if (completion) {
                            completion(viewController);
                        }
                        
                    
                    
                    
                }
                
            }
        } specialtyId:disease.specialtyId diseaseId:disease.indexId stage:stage indexId:@"" upgrde:upgrade];
    
}

-(void)showNOquestionProTreatRehab:(WRRehab*)disease stage:(NSInteger)stage  
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在获取数据", nil)];
    [ProTreatViewModel userGetProTreatDetailWithData:disease completion:^(NSError * error, id proTreatRehabDetailDict) {
        [SVProgressHUD dismiss];
        if (error) {
            [Utility retryAlertWithViewController:[self.class root] title:NSLocalizedString(@"获取数据失败", nil) completion:^{
                [self showNOquestionProTreatRehab:disease stage:0];
            }];
        } else {
            NSDictionary *dict = proTreatRehabDetailDict;
            WRRehab *rehab = [[WRRehab alloc] initWithDictionary:dict];
            rehab.disease.isProTreat = YES;
            RehabController *controller = [[RehabController alloc] initWithRehab:rehab];
            controller.umstr  = self.umstr;
            controller.hidesBottomBarWhenPushed =YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
            
        }
    }];
    
    
}


-(void)showDataTreatData:(NSString*)data IndexId:(NSString*)indexId
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在获取数据", nil)];
    
    [ProTreatViewModel userGetTreatWithdate:data indexid:indexId Completion:^(NSError * _Nonnull error, id _Nonnull rehab) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",rehab);
        if (error) {
            
        }
        else
        {
       

            if (rehab) {
                NSLog(@"%@",rehab);
                RehabController *controller = [[RehabController alloc] initWithRehab:rehab];
                controller.umstr  = self.umstr;
                controller.hidesBottomBarWhenPushed =YES;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }
        
        }
    }];
    
            
            
    
    
    
}

-(void)showCreateTreat;
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在获取数据", nil)];
    
    [ProTreatViewModel userGetCustomTreatWithCompletion:^(NSError * _Nonnull error, id _Nonnull rehab)  {
        [SVProgressHUD dismiss];
        if (error) {
            
        }
        else
        {
            
            if (rehab) {
                RehabController *controller = [[RehabController alloc] initWithRehab:rehab];
                controller.umstr  = self.umstr;
                controller.hidesBottomBarWhenPushed =YES;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                CreatTreatController* controller = [CreatTreatController new];
                controller.hidesBottomBarWhenPushed =YES;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }
            
        }
    }];
    
    
    
    
    
    
}



-(void)presentProTreatRehabWithDisease:(WRRehabDisease*)disease stage:(NSInteger)stage upgrade:(NSString*)upgrade
{
    __weak __typeof(self) weakSelf = self;
    [self showProTreatRehabWithDisease:disease stage:stage upgrade:upgrade completion:^(UIViewController *controller) {
        
        WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:controller];
        nav.interactivePopGestureRecognizer.enabled = NO;
        [[weakSelf.class root] presentViewController:nav animated:YES completion:nil];
    }];
}

-(void)generaNewProTreatRehabWithDisease:(WRRehabDisease*)disease
                                   stage:(NSInteger)stage
                                 upgrade:(NSString*)upgrade
                          fromController:(UIViewController*)viewController
                      rootViewController:(UIViewController*)rootController
{
    [self showProTreatRehabWithDisease:disease stage:stage upgrade:upgrade completion:^(UIViewController *controller) {
        [viewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
            UINavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:controller];
            nav.interactivePopGestureRecognizer.enabled = NO;
            [rootController presentViewController:nav animated:YES completion:nil];
        }];
    }];
}

-(void)pushProTreatRehabWithDisease:(WRRehabDisease*)disease stage:(NSInteger)stage upgrade:(NSString*)upgrade
{
    __weak __typeof(self) weakSelf = self;
    [self showProTreatRehabWithDisease:disease stage:stage upgrade:upgrade completion:^(UIViewController *controller) {
        controller.hidesBottomBarWhenPushed =YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
}

-(void)showSexSelectorWithCompletion:(void(^)(NSInteger sex))completion sourceView:(UIView*)sourceView sourceRect:(CGRect)sourceRect
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"选择性别", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:[WRApp genderDescription:GenderMale] style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        completion(GenderMale);
    }];
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:[WRApp genderDescription:GenderFemale] style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        completion(GenderFemale);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:maleAction];
    [controller addAction:femaleAction];
    [controller addAction:cancelAction];
    if (IPAD_DEVICE) {
        controller.popoverPresentationController.sourceView = sourceView;
        controller.popoverPresentationController.sourceRect = sourceRect;
    }
    
    [self presentViewController:controller animated:YES completion:nil];
}
@end
