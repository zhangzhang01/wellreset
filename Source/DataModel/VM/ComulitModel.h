//
//  ComulitModel.h
//  rehab
//
//  Created by yongen zhou on 2018/8/9.
//  Copyright © 2018年 WELL. All rights reserved.
//

#import "WRViewModel.h"
#import "WRObject.h"
#import "reportViewModel.h"
#import "resultModel.h"
@interface ComulitModel : WRViewModel
@property NSMutableArray* bannerArr;
@property NSMutableArray* circleArr;
@property NSMutableArray* myCircleArr;
@property NSMutableArray* articleArr;
@property NSMutableArray* CommentArr;
@property NSMutableArray* messageArr;
@property WRCircle * circle;
-(void)getBannerCompletion:(void (^)(NSError * _Nonnull ))completion;
-(void)getCirclesCompletion:(void (^)(NSError * _Nonnull ,NSArray*  crArry))completion;
-(void)getarticleSort:(NSString*)sort page:(int)page rows:(int)rows circleId:(NSString*)circleId isown:(NSString*)isown articleId:(NSString*)articleId   Completion:(void (^)(NSError * _Nonnull ))completion;
-(void)getCommentlistSort:(NSString*)sort ariticleId:(NSString*)articleId Completion:(void (^)(NSError * _Nonnull ))completion;
-(void)sendCommentArticleId:(NSString*)ArticleId parentId:(NSString*)parentId text:(NSString*)text Completion:(void (^)(NSError * _Nonnull ))completion;
-(void)getCircleDetail:(NSString*)circleId Completion:(void (^)(NSError * _Nonnull ))completion;
-(void)deletComentId:(NSString*)uuid Completion:(void (^)(NSError * _Nonnull ))completion;
-(void)deletArticle:(NSString*)uuid Completion:(void (^)(NSError * _Nonnull ))completion;
-(void)getMessageCompletion:(void (^)(NSError * _Nonnull ))completion;
-(void)deletMessage:(NSString*)uuid Completion:(void (^)(NSError * _Nonnull ))completion;
-(void)upvoteArticle:(NSString*)uuid Completion:(void (^)(NSError * _Nonnull ))completion;
-(void)joinCircle:(NSString*)circle isJoin:(NSString*)isjoin  Completion:(void (^)(NSError * _Nonnull ))completion;
-(void)getreportuserId:(NSString *)userId region:(NSString *)region tag:(NSString *)tag block:(void(^)(bool success,NSMutableArray *blockArray))block;

-(void)submitGrade:(NSString *)jsonStr  block:(void(^)(bool success,NSString *msg))block;
-(void)submitresultWithuserId:(NSString *)userId withpartCode:(NSString *)partCode  block:(void(^)(bool success,resultModel *mdoel))block;
-(void)submitadminWithuserId:(NSString *)userId   block:(void(^)(bool success,NSString *result))block;
@end
