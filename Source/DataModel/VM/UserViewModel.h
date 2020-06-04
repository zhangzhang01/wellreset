//
//  UserViewModel.h
//  rehab
//
//  Created by herson on 8/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRViewModel.h"

@interface UserViewModel : WRViewModel



+(void)fetchPersonDataWithCompletion:(void(^)(NSError*))completion;
+(void)fetchPersonFDataWithCompletion:(void(^)(NSError*))completion;
+(void)fetchExpereseDataWithCompletion:(void(^)(NSError*error, BOOL isChange))completion;

+(void)fetchChallengeInfoDataWithVideoId:(NSString *)videoId time:(NSNumber *)time Completion:(void(^)(NSError *error, NSNumber *value ,NSString *shareUrl))completion;

+(void)fetchLockDataWithCompletion:(void(^)(NSError*))completion;

+(void)checkRehabWidthIndexId:(NSString*)rehabIndexId
             sportTimeSeconds:(NSUInteger)sportTime
                   isProTreat:(BOOL)isProTreat
                   completion:(void(^)(NSError*, id))completion;

+(void)recordChallengeVideo:(NSString *)videoIndexId sportTimeSeconds:(NSUInteger)sportTime completion:(void (^)(NSError *, id))completion;

+(void)fetchSaveShareType:(NSString *)shareType  completion:(void (^)(NSError *, id))completion;

@end
