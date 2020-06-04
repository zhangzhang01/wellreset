//
//  TreatViewModel.h
//  rehab
//
//  Created by 何寻 on 9/1/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRViewModel.h"

@interface TreatViewModel : WRViewModel

+(void)getTreatRehabDetail:(NSString*)indexId completion:(void(^)(NSError* error, id resultObject))completion;
+(void)getChoTreatRehabDetail:(NSString*)indexId completion:(void(^)(NSError* error, id resultObject))completion;

+(void)likeTreatRehab:(NSString*)indexId flag:(BOOL)flag completion:(void(^)(NSError* error))completion;

+(void)repeatTreatRehabWithDiseaseId:(NSString*)diseaseId completion:(void (^)(NSError *, id))completion;

@end
