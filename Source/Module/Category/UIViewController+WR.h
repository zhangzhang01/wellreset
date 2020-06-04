//
//  UIViewController+WR.h
//  rehab
//
//  Created by Matech on 3/18/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRApp.h"
#import "RehabObject.h"

@interface UIViewController(WR)<UINavigationControllerDelegate>

+(UIViewController*)root;
@property NSString* umstr;
-(BOOL)checkUserLogState:(UIViewController*)fromController;
-(void)wr_pushControllerFromRoot:(UIViewController *)viewController;

-(void)showSelfInfo;
-(void)showNOquestionProTreatRehab:(WRRehab*)disease stage:(NSInteger)stage;
-(void)showTestRehabWithDisease:(id)data stage:(NSInteger)stage completion:(void(^)(UIViewController* controller))completion;

-(void)presentTreatRehabWithDisease:(id)data isTreat:(BOOL)isTreat;
-(void)pushTreatRehabWithDisease:(id)data isTreat:(BOOL)isTreat;


-(IBAction)onClickedBackButton:(UIBarButtonItem*)sender;
-(IBAction)createBackBarButtonItem;
-(void)createTitleViewWithTitle:(NSString *)title;

-(void)presentProTreatRehabWithDisease:(WRRehabDisease*)disease stage:(NSInteger)stage upgrade:(NSString*)upgrade;
-(void)pushProTreatRehabWithDisease:(WRRehabDisease*)disease stage:(NSInteger)stage upgrade:(NSString*)upgrade;
-(void)generaNewProTreatRehabWithDisease:(WRRehabDisease*)disease
                                   stage:(NSInteger)stage
                                 upgrade:(NSString*)upgrade
                          fromController:(UIViewController*)viewController
                      rootViewController:(UIViewController*)rootController;

-(void)showSexSelectorWithCompletion:(void(^)(NSInteger sex))completion sourceView:(UIView*)sourceView sourceRect:(CGRect)sourceRect;
-(void)showDataTreatData:(NSString*)data IndexId:(NSString*)indexId;
-(void)showCreateTreat;
@end
