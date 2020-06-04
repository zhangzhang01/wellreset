//
//  WRObject.m
//  rehab
//
//  Created by Matech on 3/10/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRObject.h"
#import "WRApp.h"
#import "WRProTreat.h"
#import "WRTreat.h"

#pragma mark - WRObject
@implementation WRObject

-(instancetype)initWithDictionary:(NSDictionary *)dc
{
    self = [super init];
    if(self)
    {
        [self fromDictionary:dc];
        if ([Utility IsEmptyString:self.indexId])
        {
            self.indexId = dc[@"id"];
            if ([Utility IsEmptyString:self.indexId])
            {
                self.indexId = dc[@"uuid"];
            }
        }
        if ([Utility IsEmptyString:self.imageUrl])
        {
            self.imageUrl = dc[@"picture"];
        }
        if(self.name == nil) {
            self.name = @"";
        }
        if (self.imageUrl == nil) {
            self.imageUrl = @"";
        }
        if (self.detail == nil) {
            self.detail = dc[@"content"];
            if (!self.detail) {
                self.detail = @"";
            }
        }
    }
    return self;
}

@end

#pragma mark - WRFAQ
@implementation WRFAQ
@end


#pragma mark - WRExpert
@implementation WRExpert
-(instancetype)initWithDictionary:(NSDictionary *)dc {
    if(self = [super initWithDictionary:dc]){
        self.detail = dc[@"description"];
    }
    return self;
}
@end

@implementation WRExpertReply
@end

#pragma mark - WRSyncData
@implementation WRSyncData
-(instancetype)initWithDictionary:(NSDictionary *)dict {
    if(self = [super init]){
        [self fromDictionary:dict];
    }
    return self;
}
@end

@implementation WRCategory
@end

@implementation WRArticle
@end

@implementation WRBannerInfo

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        NSDictionary *extraDict = dict[@"extra"];
        BannerActionType bannerType = (BannerActionType)self.type;
        switch (bannerType) {
            case BannerActionTypeUnknown: {
                break;
            }

            case BannerActionTypeTreat:
            case BannerActionTypeProTreat: {
                self.extraData = [[WRRehabDisease alloc] initWithDictionary:extraDict];
                break;
            }
            case BannerActionTypeArticle: {
                self.extraData = [[WRArticle alloc] initWithDictionary:extraDict];
                break;
            }
            default:
                break;
        }
    }
    return self;
}

@end

@implementation WRCommonDisease

-(BOOL)isChoosen
{
    return [self.userStatus isEqualToString:@"yes"];
}

-(void)setChoose:(BOOL)flag
{
    self.userStatus = flag ? @"yes" : @"no";
}
@end

@implementation WRRehabDisease

-(BOOL)isPro
{
    return self.isProTreat;
}

@end