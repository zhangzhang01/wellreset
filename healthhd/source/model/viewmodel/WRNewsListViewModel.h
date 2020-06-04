//
//  WRNewsListViewModel.h
//  rehab
//
//  Created by 何寻 on 6/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBaseListViewModel.h"

@interface WRNewsListViewModel : WRBaseListViewModel

-(void)fetchNewsListWithTypeId:(NSString*)typeId completion:(ViewModeLoadCompleteBlock)block;

@end
