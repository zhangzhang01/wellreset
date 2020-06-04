//
//  Challenge.m
//  rehab
//
//  Created by 何寻 on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "Challenge.h"

@implementation ChallengeGroup

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        
        self.isLocked = [dict[@"isLock"] isEqualToString:@"yes"];
        
        NSArray *array = dict[@"videos"];
        NSMutableArray *dataArray = [NSMutableArray array];
        for(NSDictionary *itemDict in array)
        {
            WRTreatRehabStage *stage = [[WRTreatRehabStage alloc] initWithDictionary:itemDict];
            [dataArray addObject:stage];
        }
        self.videos = dataArray;
    }
    return self;
}

@end
