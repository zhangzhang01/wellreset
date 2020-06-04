//
//  commentViewModel.h
//  rehab
//
//  Created by yongen zhou on 2017/3/17.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseListViewModel.h"

@interface commentViewModel : WRBaseListViewModel
@property(nonatomic) NSMutableArray * ListArry;
@property(nonatomic) NSInteger totalcount;
-(void)fetchCommentListWithWechat:(NSString*)Wechat completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchAddCommentWithWechat:(NSString*)Wechat context:(NSString*)context completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchDelCommentWithuuid:(NSString*)uuid completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchAddchidCommentWithWechat:(NSString*)Wechat uuid:(NSString*)uuid context:(NSString*)context completion:(ViewModeLoadCompleteBlock)block;

@end
