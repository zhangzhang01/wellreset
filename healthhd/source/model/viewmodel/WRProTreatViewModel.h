//
//  WRProTreatViewModel
//  rehab
//
//  Created by Matech on 3/14/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRViewModel.h"
#import "WRProTreat.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRProTreatViewModel : WRViewModel

@property(nonatomic) NSString *indexId;
@property(nonatomic) NSMutableArray *questionArray;
@property(nonatomic) NSMutableArray *userAnswerArray;

-(void)fetchQuestionsWithCompletion:(void (^)(NSError *, id))completion
                        specialtyId:(NSString *)specialtyId
                          diseaseId:(NSString*)diseaseId
                              stage:(NSUInteger)stage ;

-(void)getProTreatRehabWithCompletion:(void (^)(NSError *, id))completion
                      stage:(NSUInteger)stage
                  diseaseId:(NSString *)diseaseId
                specialtyId:(NSString*)specialtyId;

-(void)setAnswer:(NSString*)answer
           index:(NSUInteger)index;

+(void)userGetProTreatDetailWithData:(WRRehab*)data
                          completion:(void (^)(NSError * _Nullable, id _Nullable))completion;

+(void)userCheckRehab:(NSString*)rehabId state:(NSInteger)state
           completion:(void (^)(NSError * _Nullable, id _Nullable))completion;

+(void)userGetProTreatFeedbackQuestionsWithDiseaseId:(NSString*)diseaseId
                                          completion:(void (^)(NSError * _Nullable error, id _Nullable questionArray))completion;

+(void)userProTreatSubmitFeedbackWithCompletion:(void (^)(NSError * _Nullable))completion answers:(NSDictionary*)answersDict
                                proTreatRehabId:(NSString*)indexId;

+(void)repeatProTreatRehabWithDiseaseId:(NSString*)diseaseId completion:(void (^)(NSError *, id))completion;

+(void)userGetWellWithCompletion:(void(^)(NSError* error))completion;
+(void)userGetProTreatWithCompletion:(void (^)(NSError * _Nonnull, id _Nonnull))completion;

@end

NS_ASSUME_NONNULL_END