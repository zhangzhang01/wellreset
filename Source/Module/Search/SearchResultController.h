//
//  SearchResultController.h
//  rehab
//
//  Created by herson on 2016/10/7.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"
#import "SearchViewModel.h"

@interface SearchResultController : WRTableViewController

-(nonnull instancetype)initWithViewModel:(nonnull SearchViewModel*)viewModel keyword:(nonnull NSString *)keyword;

@end
