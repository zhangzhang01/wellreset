//
//  TreatViewModel.h
//  rehab
//
//  Created by herson on 9/1/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRViewModel.h"

@interface TreatViewModel : WRViewModel

+(void)getTreatRehabDetail:(NSString*)indexId completion:(void(^)(NSError* error, id resultObject))completion;
+(void)getChoTreatRehabDetail:(NSString*)indexId completion:(void(^)(NSError* error, id resultObject))completion;
+(void)repeatTreatRehabWithDiseaseId:(NSString*)diseaseId completion:(void (^)(NSError *, id))completion;

@end
