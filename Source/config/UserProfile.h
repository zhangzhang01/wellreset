//
//  UserProfile.h
//  rehab
//
//  Created by herson on 6/28/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

+(instancetype)defaultProfile;

@property(nonatomic) BOOL notAutoPlayBgm, donotShowTreatRehabDetail;
@property(nonatomic) NSDate *lastUserHomeDate;

@end
