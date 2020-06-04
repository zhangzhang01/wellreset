//
//  WRScene.m
//  rehab
//
//  Created by herson on 2016/11/16.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRScene.h"
#import "RehabObject.h"

@implementation WRScene

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
        NSMutableArray<WRTreatRehabStageVideo*> *dataArray = [NSMutableArray array];
        NSArray *array = dict[@"videos"];
        if ([array isKindOfClass:[NSArray class]])
        {
            for(NSDictionary *object in array)
            {
                WRTreatRehabStageVideo *video = [[WRTreatRehabStageVideo alloc] initWithDictionary:object];
                [dataArray addObject:video];
            }
        }
        _videos = dataArray;
    }
    return self;
}

@end
