//
//  UserViewModel.h
//  rehab
//
//  Created by 何寻 on 8/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRViewModel.h"

@interface UserViewModel : WRViewModel

+(void)fetchPersonDataWithCompletion:(void(^)(NSError*))completion;

+(void)fetchLockDataWithCompletion:(void(^)(NSError*))completion;

+(void)checkRehabWidthIndexId:(NSString*)rehabIndexId
             sportTimeSeconds:(NSUInteger)sportTime
                   isProTreat:(BOOL)isProTreat
                   completion:(void(^)(NSError*, id))completion;

+(void)recordChallengeVideo:(NSString *)videoIndexId sportTimeSeconds:(NSUInteger)sportTime completion:(void (^)(NSError *, id))completion;

+(void)askForRehab:(NSString*)content completion:(void(^)(NSError*))completion;;

@end
