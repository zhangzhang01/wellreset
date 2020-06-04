//
//  ShareUserData.m
//  rehab
//
//  Created by herson on 8/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ShareUserData.h"

@implementation ShareUserData

+(instancetype)userData
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
        [self restore];
    }
    return self;
}

-(NSMutableArray<NSString *> *)redArticleArray {
    if (!_redArticleArray) {
        _redArticleArray = [NSMutableArray array];
    }
    return _redArticleArray;
}

-(void)restore
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"article.plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
    if (array.count > 0) {
        [self.redArticleArray addObjectsFromArray:array];
    }
    
    NSString *alarmFileName = [path stringByAppendingPathComponent:@"alarm.plist"];
    array = [NSArray arrayWithContentsOfFile:alarmFileName];
    if (array.count > 0) {
        [self.alarmArray addObjectsFromArray:array];
    }
}

-(void)save
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"article.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm createFileAtPath:fileName contents:nil attributes:nil];
    [self.redArticleArray writeToFile:fileName atomically:YES];
 
     NSString *alarmFileName = [path stringByAppendingPathComponent:@"alarm.plist"];
    [fm createFileAtPath:alarmFileName contents:nil attributes:nil];
    [self.alarmArray writeToFile:alarmFileName atomically:YES];
}

-(WRTreatRehabStage*)getUserStageByVideoId:(NSString*)indexId
{
    for(WRTreatRehabStage *obj in [ShareUserData userData].challengeVideoArray)
    {
        if ([obj.videoId isEqualToString:indexId])
        {
            return obj;
        }
    }
    return nil;
}

-(NSMutableArray *)commonDiseases {
    if (_commonDiseases == nil) {
        _commonDiseases = [[NSMutableArray alloc] init];
    }
    return _commonDiseases;
}

-(NSMutableArray *)diseasePhotoArray {
    if (_diseasePhotoArray == nil) {
        _diseasePhotoArray = [[NSMutableArray alloc] init];
    }
    return _diseasePhotoArray;
}

-(NSMutableArray<NSString *> *)alarmArray {
    if (_alarmArray == nil) {
        _alarmArray = [[NSMutableArray alloc] init];
    }
    return _alarmArray;
}

-(void)clear
{
    self.proTreatRehab = [NSMutableArray array];
    self.treatRehab = [NSMutableArray array];
    [self.commonDiseases removeAllObjects];
    [self.diseasePhotoArray removeAllObjects];
    [self.alarmArray removeAllObjects];
    
    [self.userPermissions reset];
}

-(BOOL)notifyRehab:(WRRehab *)rehab
{
    BOOL exsit = NO;
    NSMutableArray<WRRehab*> *rehabArray = [rehab.disease isPro] ? self.proTreatRehab : self.treatRehab;
    NSUInteger index = 0;
    for(WRRehab *obj in rehabArray)
    {
        if ([obj.disease.indexId isEqualToString:rehab.disease.indexId]) {
            exsit = YES;
            [rehabArray replaceObjectAtIndex:index withObject:rehab];
            break;
        }
        index++;
    }
    if (!exsit) {
        [rehabArray addObject:rehab];
    }
    return YES;
}
@end
