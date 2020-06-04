//
//  ArticleListViewModel.h
//  rehab
//
//  Created by herson on 6/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBaseListViewModel.h"

@interface ArticleListViewModel : WRBaseListViewModel

-(void)fetchNewsListWithTypeId:(NSString*)typeId completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchNewsIndexcompletion:(ViewModeLoadCompleteBlock)block;
@property(nonatomic)NSInteger pageNOPublic;
@end
