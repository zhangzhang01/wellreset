//
//  UIViewController+WR.h
//  rehab
//
//  Created by Matech on 3/18/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRApp.h"
#import "WRTreat.h"

@interface UIViewController(WR)

+(UIViewController*)root;

-(BOOL)checkUserLogState:(UIViewController*)fromController;
-(void)wr_pushControllerFromRoot:(UIViewController *)viewController;

-(void)showSelfInfo;

-(void)presentTreatRehabWithDisease:(id)data isTreat:(BOOL)isTreat;
-(void)pushTreatRehabWithDisease:(id)data isTreat:(BOOL)isTreat;


-(IBAction)onClickedBackButton:(UIBarButtonItem*)sender;
-(IBAction)createBackBarButtonItem;

-(void)presentProTreatRehabWithDisease:(WRRehabDisease*)disease stage:(NSInteger)stage;
-(void)pushProTreatRehabWithDisease:(WRRehabDisease*)disease stage:(NSInteger)stage;
-(void)generaNewProTreatRehabWithDisease:(WRRehabDisease*)disease
                                   stage:(NSInteger)stage
                          fromController:(UIViewController*)viewController
                      rootViewController:(UIViewController*)rootController;

-(void)showSexSelectorWithCompletion:(void(^)(NSInteger sex))completion sourceView:(UIView*)sourceView sourceRect:(CGRect)sourceRect;

@end