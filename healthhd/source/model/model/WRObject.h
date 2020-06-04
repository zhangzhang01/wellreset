//
//  WRObject.h
//  rehab
//
//  Created by Matech on 3/10/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "NSObject+Property.h"

@interface WRObject : NSObject

@property(nonatomic, copy) NSString *indexId, *name, *detail, *imageUrl;
-(instancetype)initWithDictionary:(NSDictionary *)dc;
@end

@interface WRFAQ : WRObject
@property(nonatomic, copy) NSString *question, *answer, *keywords;
@end


@interface WRExpert : WRObject
@property(nonatomic, copy) NSString *field, *jobTitle;
@end

@interface WRExpertReply : WRObject
@property(nonatomic, copy) NSString *askerId, *askTime, *expertId, *question, *content, *operTime;
@property(nonatomic) NSInteger state;
@end

@interface WRSyncData : NSObject
@property(nonatomic, copy)NSString *userId, *type, *value, *time;
@property(nonatomic) NSUInteger deviceType;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRCategory : WRObject
@property(nonatomic, copy)NSString *logoImgUrl;
@end

@interface WRArticle : NSObject
@property(nonatomic, copy)NSString *uuid, *title, *subtitle, *imageUrl, *contentUrl, *createTime;
@property(nonatomic, assign)BOOL favor;
@property(nonatomic, assign)NSInteger viewCount;
@end

@interface WRBannerInfo : WRObject
@property(nonatomic, copy)NSString *title;
@property(nonatomic)NSInteger type;
@property(nonatomic)NSObject* extraData;
@end

@interface WRCommonDisease : NSObject
@property(nonatomic, copy) NSString *uuid, *name, *userStatus, *parentId;
@property(nonatomic) NSInteger state;

-(BOOL)isChoosen;
-(void)setChoose:(BOOL)flag;
@end

@interface WRRehabDisease : NSObject

@property(nonatomic, copy) NSString *indexId, *specialtyId, *bannerImageUrl, *bannerImageUrl2,
*diseaseName, *diseaseDetail, *imageUrl, *bodyCode, *userStatus, *parentId, *specialty;
@property(nonatomic) NSInteger state, count, clicks, difficulty;
@property(nonatomic)BOOL isProTreat;

-(BOOL)isPro;

@end

