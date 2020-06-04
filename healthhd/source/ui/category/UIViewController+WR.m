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
#import "WRProTreatQuestionsIndexController.h"
#import "WRProTreatViewModel.h"
#import "WRTreat.h"
#import "WRUserInfo.h"
#import "MessageLoginTool.h"
#import "FloatLoginView.h"


static WRPerfectView *perfect;
static MessageLoginTool *messageLoginTool;
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
//        LoginController *viewController = [[LoginController alloc] init];
//        UINavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];
//        if ([WRUIConfig IsHDApp]) {
//            nav.modalPresentationStyle = UIModalPresentationFormSheet;
//            nav.providesPresentationContextTransitionStyle = YES;
//            nav.definesPresentationContext = YES;
//            nav.preferredContentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width*0.7f, [[UIScreen mainScreen] bounds].size.height*0.7f);
//        }
//        [fromController presentViewController:nav animated:YES completion:nil];
    
        
//        if (messageLoginTool == nil) {
//            messageLoginTool = [[MessageLoginTool alloc] init];
//        }
//        [messageLoginTool showMessageLoginView];
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
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedBackButton:)];
    self.navigationItem.leftBarButtonItem = item;
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
        if ([Utility IsEmptyString:rehab.indexId])
        {
            error = [NSError errorWithDomain:NSLocalizedString(@"获取数据失败", nil) code:-1 userInfo:nil];
        }
        if (error)
        {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:error.domain completion:^{
                [weakSelf showTreatRehabWithDisease:disease isTreat:isTreat completion:completion];
            }];
        }
        else
        {
            if (completion) {
                rehab.disease.isProTreat = NO;
                RehabController *viewController = [[RehabController alloc] initWithRehab:rehab];
                completion(viewController);
            }
        }
    };
    
    [SVProgressHUD showWithStatus:nil];
    [TreatViewModel getTreatRehabDetail:disease.indexId completion:block];
}

-(void)presentTreatRehabWithDisease:(id)data isTreat:(BOOL)isTreat {
    __weak __typeof(self) weakSelf = self;
    [self showTreatRehabWithDisease:data isTreat:isTreat completion:^(UIViewController *controller) {
        UINavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:controller];
        [[weakSelf.class root] presentViewController:nav animated:YES completion:nil];
    }];
}

-(void)pushTreatRehabWithDisease:(id)data isTreat:(BOOL)isTreat {
    __weak __typeof(self) weakSelf = self;
    [self showTreatRehabWithDisease:data isTreat:isTreat completion:^(UIViewController *controller) {
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
}

-(void)showProTreatRehabWithDisease:(WRRehabDisease*)disease stage:(NSInteger)stage completion:(void(^)(UIViewController* controller))completion
{
    if (![self checkUserLogState:nil]) {
        return;
    }
    if(([WRUserInfo selfInfo].height == 0 || [WRUserInfo selfInfo].weight == 0 || [WRUserInfo selfInfo].age == 0 || ([WRUserInfo selfInfo].sex != GenderFemale && [WRUserInfo selfInfo].sex != GenderMale))) {
        if (perfect == nil) {
            perfect = [[WRPerfectView alloc] init];
        }
        __weak __typeof(self)weakself = self;
        perfect.completionBlock = ^{
            [weakself showProTreatRehabWithDisease:disease stage:stage completion:completion];
        };
        [perfect showChooseSexViewWithViewControlllr:self];
    } else
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在获取数据", nil)];
        WRProTreatViewModel *model = [[WRProTreatViewModel alloc] init];
        __weak __typeof(self) weakSelf = self;
        [model fetchQuestionsWithCompletion:^(NSError * _Nonnull error, id object) {
            [SVProgressHUD dismiss];
            WRRehab *rehab = object;
            
            __strong __typeof(model) strongModel = model;
            if (error) {
                [Utility retryAlertWithViewController:self title:NSLocalizedString(@"定制方案失败", nil) completion:^{
                    [weakSelf showProTreatRehabWithDisease:disease stage:stage completion:completion];
                }];
            } else {
                if (rehab) {
                    rehab.disease.isProTreat = YES;
                    RehabController *viewController = [[RehabController alloc] initWithRehab:rehab];
                    viewController.title = [NSString stringWithFormat:@"%@ %@", disease.diseaseName, NSLocalizedString(@"定制方案", nil)];
                    if (completion) {
                        completion(viewController);
                    }
                } else {
                    WRProTreatQuestionsIndexController *viewController = [[WRProTreatQuestionsIndexController alloc] initWithProTreatViewModel:strongModel proTreatDisease:disease];
                    viewController.stage = stage;
                    viewController.title = [NSString stringWithFormat:@"%@%@", disease.diseaseName, NSLocalizedString(@"诊断", nil)];
                    if (completion) {
                        completion(viewController);
                    }
                }
                
            }
        } specialtyId:disease.specialtyId diseaseId:disease.indexId stage:stage];
    }
}

-(void)presentProTreatRehabWithDisease:(WRRehabDisease*)disease stage:(NSInteger)stage
{
    __weak __typeof(self) weakSelf = self;
    [self showProTreatRehabWithDisease:disease stage:stage completion:^(UIViewController *controller) {
        
        UINavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:controller];
        nav.interactivePopGestureRecognizer.enabled = NO;
        [[weakSelf.class root] presentViewController:nav animated:YES completion:nil];
    }];
}

-(void)generaNewProTreatRehabWithDisease:(WRRehabDisease*)disease
                                   stage:(NSInteger)stage
                          fromController:(UIViewController*)viewController
                      rootViewController:(UIViewController*)rootController
{
    [self showProTreatRehabWithDisease:disease stage:stage completion:^(UIViewController *controller) {
        [viewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
            UINavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:controller];
            nav.interactivePopGestureRecognizer.enabled = NO;
            [rootController presentViewController:nav animated:YES completion:nil];
        }];
    }];
}

-(void)pushProTreatRehabWithDisease:(WRRehabDisease*)disease stage:(NSInteger)stage
{
    __weak __typeof(self) weakSelf = self;
    [self showProTreatRehabWithDisease:disease stage:stage completion:^(UIViewController *controller) {
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
