//
//  WRBodySelectorController.h
//  rehab
//
//  Created by Matech on 3/22/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRBaseViewController.h"

@interface WRBodySelectorController : WRViewController

@property(nonatomic, copy) void(^completion)(NSSet<NSString*> *codesSet); //will pass code sets
@property BOOL isadd;
@end
