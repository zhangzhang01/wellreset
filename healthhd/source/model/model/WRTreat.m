//
//  WRTreat.m
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "WRTreat.h"

@implementation WRTreatRehabStageVideo
-(instancetype)initWithDictionary:(NSDictionary *)dc {
    if (self = [super initWithDictionary:dc]) {
        NSArray *array = dc[@"images"];
        if(array.count > 0){
            NSMutableArray *data = [NSMutableArray array];
            for(NSDictionary *dict in array)
            {
                WRTreatRehabStageVideoTherbligImage *image = [[WRTreatRehabStageVideoTherbligImage alloc] initWithDictionary:dict];
                [data addObject:image];
            }
            self.images = data;
        }
        
        array = dc[@"attributes"];
        if(array.count > 0){
            NSMutableArray *data = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRObject *image = [[WRObject alloc] initWithDictionary:itemDict];
                image.detail = itemDict[@"content"];
                [data addObject:image];
            }
            self.attributes = data;
        }
    }
    return self;
}
@end

@implementation WRTreatRehabStageVideoTherbligImage
@end

@implementation WRTreatRehabStage
-(instancetype)initWithDictionary:(NSDictionary *)dc {
    if(self = [super initWithDictionary:dc]) {
        self.mtWellVideoInfo = [[WRTreatRehabStageVideo alloc] initWithDictionary:dc[@"mtWellVideoInfo"]];
        self.mtWellVideoInfo.difficulty = self.difficulty;
    }
    return self;
}
@end

