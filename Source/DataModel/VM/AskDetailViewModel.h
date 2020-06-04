//
//  AskDetailViewModel.h
//  rehab
//
//  Created by yongen zhou on 2017/5/4.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRViewModel.h"

@interface AskDetailViewModel : WRViewModel
@property(nonatomic) NSMutableArray * ListArry;
@property(nonatomic) NSInteger totalcount;
@property(nonatomic) NSInteger isshow;
@property(nonatomic) NSString * question;
@property(nonatomic) NSString * content;
@property(nonatomic) NSString * content1;
@property(nonatomic) NSString * content2;
@property(nonatomic) BOOL ifUpvoted;
-(void)fetchAddvoteWithReaplyid:(NSString*)Reaplyid  completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchAddCommentWithReply:(NSString*)reply context:(NSString*)context completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchCommentListWithReply:(NSString*)Reply completion:(ViewModeLoadCompleteBlock)block;

@end
