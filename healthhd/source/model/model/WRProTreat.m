//
//  WRProTreat.m
//  rehab
//
//  Created by Matech on 3/17/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRProTreat.h"
#import "WRTreat.h"

@implementation WRProTreatSpecialty
@end

@implementation WRProTreatAnswer
@end

#pragma mark - WRProTreatQuestion
@implementation WRProTreatQuestion
-(instancetype)initWithDictionary:(NSDictionary *)dc {
    if(self = [super initWithDictionary:dc]) {
        NSArray *array = self.answers;
        NSMutableArray *answerArray = [NSMutableArray array];
        for(NSDictionary *dict in array) {
            WRProTreatAnswer *answer = [[WRProTreatAnswer alloc] initWithDictionary:dict];
            [answerArray addObject:answer];
        }
        self.answers = answerArray;
    }
    return self;
}
@end

#pragma mark - ProTreat Rehab
@implementation WRRehab

-(instancetype)initWithDictionary:(NSDictionary *)dc {
    if(self = [super initWithDictionary:dc]) {
        if ([Utility IsEmptyString:self.indexId]) {
            self.indexId = dc[@"uuid"];
        }
        NSArray *array = nil;
        id object = dc[@"stageSet"];
        if ([object isKindOfClass:[NSArray class]]) {
            array = object;
        }
        
        if(array.count > 0){
            NSMutableArray *data = [NSMutableArray array];
            for(NSDictionary *dict in array)
            {
                WRTreatRehabStage *object = [[WRTreatRehabStage alloc] initWithDictionary:dict];
                [data addObject:object];
            }
            self.stageSet = data;
        }
        
        array = nil;
        object = dc[@"checkDate"];
        if ([object isKindOfClass:[NSArray class]]) {
            array = object;
        }
        if(array.count > 0){
            self.checkedDate = [array copy];
        }
        
        NSDictionary *dict = dc[@"disease"];
        if (dict) {
            self.disease = [[WRRehabDisease alloc] initWithDictionary:dict];
        }
        
        array = dc[@"relate"];
        if(array.count > 0){
            NSMutableArray *data = [NSMutableArray array];
            for(NSDictionary *dict in array)
            {
                WRArticle *object = [[WRArticle alloc] initWithDictionary:dict];
                [data addObject:object];
            }
            self.relate = data;
        }
        
        array = dc[@"users"];
        if(array.count > 0){
            NSMutableArray *data = [NSMutableArray array];
            for(NSDictionary *dict in array)
            {
                WRUserInfo *object = [[WRUserInfo alloc] initWithDictionary:dict];
                [data addObject:object];
            }
            self.users = data;
        }
    }
    return self;
}
@end

@implementation WRProTreatRehabFeedbackQuestion
@end