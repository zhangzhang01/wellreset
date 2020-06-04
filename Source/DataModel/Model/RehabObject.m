//
//  RehabObject.m
//  rehab
//
//  Created by herson on 16/9/16.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "RehabObject.h"

@implementation WRRehabDisease
-(BOOL)isPro
{
    return self.isProTreat;
}

-(instancetype)initWithDictionary:(NSDictionary *)dc {
    if(self = [super initWithDictionary:dc]) {
        NSDictionary *dic = dc[@"chargeInfo"];
        if (dic) {
            _chargeInfo = [[ChargeInfo alloc] initWithDictionary:dic];
            
        }
        
        dic = dc[@"productInfo"];
        if (dic) {
            _productInfo = [[ProductInfo alloc] initWithDictionary:dic];
            
        }
    }
    return self;
}
@end

@implementation ChargeInfo
@end

@implementation ProductInfo
@end

@implementation WRProTreatSpecialty
@end

@implementation WRProTreatAnswer
-(instancetype)initWithDictionary:(NSDictionary *)dc {
    if(self = [super initWithDictionary:dc]) {
        self.desc =  dc[@"description"];
    }
    return self;
}
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
        self.desc =  dc[@"description"];
    }
    return self;
}
@end

#pragma mark - WRAssess
@implementation WRAssess

@end

#pragma mark - ProTreat Rehab
@implementation WRRehab

-(instancetype)initWithDictionary:(NSDictionary *)dc {
    if(self = [super initWithDictionary:dc]) {
        if ([Utility IsEmptyString:self.indexId]) {
            _indexId = dc[@"uuid"];
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
            _stageSet = data;
        }
        
        array = nil;
        object = dc[@"checkDate"];
        if ([object isKindOfClass:[NSArray class]]) {
            array = object;
        }
        if(array.count > 0){
            _checkedDate = [array copy];
        }
        
        NSDictionary *dict = dc[@"disease"];
        if (dict) {
            _disease = [[WRRehabDisease alloc] initWithDictionary:dict];
        }
        
        array = dc[@"relate"];
        if(array.count > 0){
            NSMutableArray *data = [NSMutableArray array];
            for(NSDictionary *dict in array)
            {
                WRArticle *object = [[WRArticle alloc] initWithDictionary:dict];
                [data addObject:object];
            }
            _relate = data;
        }
        
        array = dc[@"users"];
        if(array.count > 0){
            NSMutableArray *data = [NSMutableArray array];
            for(NSDictionary *dict in array)
            {
                WRUserInfo *object = [[WRUserInfo alloc] initWithDictionary:dict];
                [data addObject:object];
            }
            _users = data;
        }
        
        array = dc[@"faq"];
        NSMutableArray<WRFAQ*> *faqData = [NSMutableArray array];
        if(array.count > 0){
            for(NSDictionary *dict in array)
            {
                WRFAQ *object = [[WRFAQ alloc] initWithDictionary:dict];
                [faqData addObject:object];
            }
        }
        _faq = faqData;
        
        array = dc[@"assesses"];
        NSMutableArray<WRAssess*> *assessData = [NSMutableArray array];
        if(array.count > 0){
            for(NSDictionary *dict in array)
            {
                WRAssess *object = [[WRAssess alloc] initWithDictionary:dict];
                [assessData addObject:object];
            }
        }
        _assess = assessData;
        
        _operation = dc[@"operation"];
    }
    return self;
}
@end

@implementation WRProTreatRehabFeedbackQuestion
@end

#pragma mark - MuscleDiagram
@implementation MuscleDiagram
-(instancetype)initWithDictionary:(NSDictionary *)dc
{
    if (self = [super initWithDictionary:dc])
    {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *imagesArray = dc[@"images"];
        [imagesArray enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *image = obj[@"imageUrl"];
            if (image)
            {
                [array addObject:image];
            }
        }];
        _images = array;
    }
    return self;
}
@end

#pragma mark - WRTreatRehabStageVideo
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
        NSDictionary *dict = dc[@"muscleInfo"];
        if (dict) {
            _muscle = [[MuscleDiagram alloc] initWithDictionary:dict];
        }
    }
    return self;
}
@end

@implementation WRTreatRehabStageVideoTherbligImage
@end

@implementation WRTreatRehabStage
-(instancetype)initWithDictionary:(NSDictionary *)dc
{
    if(self = [super initWithDictionary:dc])
    {
        self.mtWellVideoInfo = [[WRTreatRehabStageVideo alloc] initWithDictionary:dc[@"mtWellVideoInfo"]];
        self.mtWellVideoInfo.difficulty = self.difficulty;
    }
    return self;
}
@end


@implementation WRDownRehab




@end

@implementation WRTreatclass
-(instancetype)initWithDictionary:(NSDictionary *)dc
{
    if (self = [super initWithDictionary:dc]) {
        _uuid = dc[@"id"];
    }
    return self;
}
@end

