//
//  ArticleListController.h
//  rehab
//
//  Created by herson on 6/3/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBannerViewController.h"
#import "WRObject.h"

@interface ArticleListController : WRTableViewController

@property(nonatomic)WRCategory *category;
@property(nonatomic, weak) NSArray<WRArticle*> *dataList;
@property(nonatomic, weak) UIViewController *rootController;
@property (nonatomic, assign) BOOL isRecommand;

@end
