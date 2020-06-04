//
//  ProTreatViewModel
//  rehab
//
//  Created by Matech on 3/14/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRViewModel.h"
#import "RehabObject.h"
#import "WRObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProTreatViewModel : WRViewModel

@property(nonatomic) NSString *indexId;
@property(nonatomic) NSMutableArray *questionArray;
@property(nonatomic) NSMutableArray *userAnswerArray;
@property(nonatomic) NSMutableArray <WRTestInfo *>* lastarry;
@property(nonatomic) WRTestInfo *UserHealthStage;
@property(nonatomic) NSArray* desc;
@property(nonatomic) NSString*  Ttitle;


-(void)fetchQuestionsWithCompletion:(void (^)(NSError *, id))completion
                        specialtyId:(NSString *)specialtyId
                          diseaseId:(NSString*)diseaseId
                              stage:(NSUInteger)stage indexId:(NSString *)indexId upgrde:(NSString *)upgrade;

-(void)getProTreatRehabWithCompletion:(void (^)(NSError *, id, NSInteger, NSString*))completion
                      stage:(NSUInteger)stage
                  diseaseId:(NSString *)diseaseId
                specialtyId:(NSString*)specialtyId;

-(void)setAnswer:(NSString*)answer
           index:(NSUInteger)index;

+(void)userGetProTreatDetailWithData:(WRRehab*)data
                          completion:(void (^)(NSError * _Nullable, id _Nullable))completion;

+(void)userCheckRehab:(NSString *)rehabId state:(NSInteger)state interver:(NSInteger)interver completion:(void (^)(NSError * _Nonnull, id _Nonnull))completion;

+(void)userGetProTreatFeedbackQuestionsWithDiseaseId:(NSString *)diseaseId isPro:(BOOL)isPro completion:(nonnull void (^)(NSError * _Nonnull, id _Nonnull))completion;

+(void)userProTreatSubmitFeedbackWithCompletion:(void (^)(NSError * _Nullable))completion answers:(NSDictionary*)answersDict
                                proTreatRehabId:(NSString*)indexId;

+(void)repeatProTreatRehabWithDiseaseId:(NSString*)diseaseId completion:(void (^)(NSError *, id))completion;

+(void)userGetWellWithCompletion:(void(^)(NSError* error))completion;
+(void)userGetProTreatWithCompletion:(void (^)(NSError * _Nonnull, id _Nonnull))completion;
- (void)userGetProTreatStageWithCompletion:(void (^)(NSError * _Nonnull, id _Nonnull))completion;

+(void)userProTreatSubmitNewFeedbackWithCompletion:(void (^)(NSError * _Nullable))completion answers:(NSArray *)answersDict pain:(NSString *)pain rehabid:(NSString *)rehabid;
+(void)userGetTreatWithdate:(NSString*)data indexid:(NSString*)indexid Completion:(void (^)(NSError * _Nonnull, id _Nonnull))completion;
+(void)userGetCustomTreatWithCompletion:(void (^)(NSError * _Nonnull, id _Nonnull))completion ;
@end

NS_ASSUME_NONNULL_END
