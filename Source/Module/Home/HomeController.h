//
//  HomeController.h
//  rehab
//
//  Created by herson on 8/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface HomeController : WRViewController

@property(nonatomic)void(^clickedEvent)(UIView *sender);

-(void)loadData;

-(void)showAnimation;

@end
