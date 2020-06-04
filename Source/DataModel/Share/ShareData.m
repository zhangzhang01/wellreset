//
//  ShareData.m
//  rehab
//
//  Created by herson on 8/17/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ShareData.h"

@implementation ShareData

#pragma mark - Static funtion
+(instancetype)data
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init {
    if (self = [super init]) {
        self.bodyCodeArray = @[
                       @"head", @"neck", @"shoulder", @"shoulder", @"scapular", @"scapular",
                       @"lumbar",
                       @"elbow", /*@"lowback", @"lowback",*/  @"elbow",
                       @"hand", @"hip", @"hand",
                       @"thigh", @"thigh",
                       @"foot"
                       ];
        
        self.bodyCodeDescArray = @[
                       @"头部", @"颈部", @"肩部", @"肩部", @"肩胛", @"肩胛",
                       @"腰脊",
                       @"手肘", /*@"骶髂关节", @"骶髂关节", */ @"手肘",
                       @"手", @"臀部", @"手",
                       @"大腿", @"足部"
                       ];
    }
    return self;
}

-(NSString *)descFromBodyCode:(NSString *)code
{
    NSInteger index = [self.bodyCodeArray indexOfObject:code];
    if (index != NSNotFound) {
        return self.bodyCodeDescArray[index];
    }
    return nil;
}

-(WRTreatRehabStage *)getStageWithVideoId:(NSString *)indexId
{
    for(ChallengeGroup *group in self.challengeGroupArray)
    {
        for(WRTreatRehabStage *obj in group.videos)
        {
            if ([obj.videoId isEqualToString:indexId]) {
                return obj;
            }
        }
    }
    return nil;
}

@end
