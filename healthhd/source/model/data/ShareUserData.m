//
//  ShareUserData.m
//  rehab
//
//  Created by 何寻 on 8/18/16.
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
}

-(void)save
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"article.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm createFileAtPath:fileName contents:nil attributes:nil];
    [self.redArticleArray writeToFile:fileName atomically:YES];
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

-(void)clear
{
    self.proTreatRehab = [NSArray array];
    self.treatRehab = [NSArray array];
    [self.commonDiseases removeAllObjects];
    [self.diseasePhotoArray removeAllObjects];
}
@end
