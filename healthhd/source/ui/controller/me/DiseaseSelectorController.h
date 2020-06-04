//
//  DiseaseSelectorController.h
//  rehab
//
//  Created by 何寻 on 8/5/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface DiseaseSelectorController : WRTableViewController

@property(nonatomic, copy) void(^completion)();

@end
