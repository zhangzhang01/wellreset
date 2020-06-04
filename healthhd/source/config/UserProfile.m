//
//  UserProfile.m
//  rehab
//
//  Created by 何寻 on 6/28/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

+(instancetype)defaultProfile {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserProfile alloc] init];
    });
    return instance;
}


-(BOOL)notAutoPlayBgm {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"notAutoPlayBgm"];
}

-(void)setNotAutoPlayBgm:(BOOL)notAutoPlayBgm {
    [[NSUserDefaults standardUserDefaults] setBool:notAutoPlayBgm forKey:@"notAutoPlayBgm"];
}

-(BOOL)donotShowTreatRehabDetail {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"donotShowTreatRehabDetail"];
}

-(void)setDonotShowTreatRehabDetail:(BOOL)donotShowTreatRehabDetail {
    [[NSUserDefaults standardUserDefaults] setBool:donotShowTreatRehabDetail forKey:@"donotShowTreatRehabDetail"];
}

@end
