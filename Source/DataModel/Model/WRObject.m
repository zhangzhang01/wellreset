//
//  WRObject.m
//  rehab
//
//  Created by Matech on 3/10/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRObject.h"
#import "WRApp.h"
#import "RehabObject.h"
#import "RehabObject.h"

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

#pragma mark -
@implementation WRUserPermission
-(instancetype)initWithDictionary:(NSDictionary *)dc
{
    if (self = [super initWithDictionary:dc]) {
        id object = dc[@"changeRehab"];
        _changeRehab = object ? [object integerValue] : 0;
 
        object = dc[@"askCount"];
        _askCount = object ? [object integerValue] : 0;
        
        object = dc[@"downloadOffline"];
        _downloadOffline = object ? [object integerValue] : 0;
        
        object = dc[@"collection"];
        _collection = object ? [object integerValue] : 0;
        
        object = dc[@"changeRehab"];
        _changeRehab = object ? [object integerValue] : 0;
    }
    return self;
}

-(void)reset
{
    self.changeRehab = 0;
    self.askCount = 0;
    self.downloadOffline = 0;
    self.collection = 0;
}
@end

@implementation WRLevelRule



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
- (CGFloat)cellHeight
{
    NSAssert(self.cellWidth > 0, @"please set cell width first");
    
    if (_cellHeight) {
        return _cellHeight;
    }
    
    CGFloat cellWidth = self.cellWidth;
    
    CGFloat inset =12;
    CGFloat offset = WRUIDiffautOffset;
    CGFloat x, y, cx, cy;
    CGFloat iconW = WRReplyCellIconWidthAndHeight;
    
    
    y = WRReplyCellIconWidthAndHeight + 2 * offset;
    x = offset+inset;
    y = x;
    NSString *text = self.question;
    if ([Utility IsEmptyString:text]) {
        text = @" ";
    }
    
    
    
    
    self.iconFrame = CGRectMake(x, y, iconW, iconW);
    NSDictionary *nameAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    
    CGSize timeSize = [self.operTime sizeWithAttributes:nameAttr];
    cx = timeSize.width;
    cy = timeSize.height;
    x = self.cellWidth - offset - cx;
    y = CGRectGetMidY(self.iconFrame) - cy/2;
    self.timeFrame = CGRectMake(x, y, cx, cy);
    
    x = CGRectGetMaxX(self.iconFrame) + 9+inset;
    CGSize nameSize = [self.userName sizeWithAttributes:nameAttr];
    cx = CGRectGetMinX(self.timeFrame) - x - offset -2*inset;
    cy = nameSize.height;
    y = CGRectGetMidY(self.iconFrame) - cy/2;
    self.nameFrame = CGRectMake(x, y, cx, cy);
    
    y = CGRectGetMaxY(self.iconFrame);

    
    x = offset+inset;
    
    NSDictionary *questionAttr = @{NSFontAttributeName:[UIFont wr_textFont]};
    y = CGRectGetMaxY(self.nameFrame)+34;
    CGFloat questionMaxWidth = self.cellWidth - 2*offset-2*inset;
    CGSize questionMaxSize = CGSizeMake(questionMaxWidth, MAXFLOAT);
    CGSize questionSize = [text boundingRectWithSize:questionMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:questionAttr context:nil].size;
    cx = questionMaxWidth;
    cy = questionSize.height;
    self.questionFrame = CGRectMake(x, y, cx, cy);
    
    text = self.content;
    if ([Utility IsEmptyString:text]) {
        text = @" ";
    }
    y = CGRectGetMaxY(self.questionFrame) + WRUILittleOffset;
    NSDictionary *answerAttr = @{NSFontAttributeName:[UIFont wr_textFont]};
    CGFloat answerMaxWidth = cellWidth - 2 * offset-2*inset;
    CGSize answerMaxSize = CGSizeMake(answerMaxWidth, MAXFLOAT);
    CGSize answerSize = [self.content boundingRectWithSize:answerMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:answerAttr context:nil].size;
    cx = answerMaxWidth;
    cy = answerSize.height;
    self.answerFrame = CGRectMake(x, y, cx, cy);
    y += cy + 3;
    
    
    _cellHeight = y + 43 - 2*offset;
    return _cellHeight;
}
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
-(instancetype)initWithDictionary:(NSDictionary *)dc
{
    if (self = [super initWithDictionary:dc]) {
        self.typeID = dc[@"id"];
        self.wtArray = [NSMutableArray array];
    }
    return self;
}
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
            case 6:
            {
                self.extraData = extraDict;
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


@implementation WRMusic
@end

@implementation FavorContent
-(instancetype)initWithDictionary:(NSDictionary *)dc
{
    if (self = [super initWithDictionary:dc])
    {
        NSDictionary *dict = dc[@"collectContent"];
        if ([_type isEqualToString:@"treatStage"] || [_type isEqualToString:@"proTreatStage"])
        {
            _collectContent = [[WRTreatRehabStage alloc] initWithDictionary:dict];
        }
    }
    return self;
}
@end

@implementation WRHotWord

@end

@implementation WRDaliy
-(instancetype)initWithDictionary:(NSDictionary *)dc
{
    if (self = [super initWithDictionary:dc])
    {
        self.nextlevelXP = [dc[@"next"] integerValue]+[dc[@"integral"] integerValue];
        self.currentXP = [dc[@"integral"] integerValue];
        self.currenLevel = [dc[@"level"]integerValue ];
        self.nextLevel = [dc[@"level"] integerValue]+1;
        self.awardArry = dc[@"levelInfo"];
        self.isFinishData = dc[@"completeInfo"];
        self.isBlinkPhone = dc[@"bindPhone"];
        self.taskarry = dc[@"taskInfo"];
        NSDictionary* info = self.taskarry[0];
        self.hadSignDays = [info[@"currentDay"] integerValue];
        
        
    }
    return self;
}

@end

@implementation WRTrainChartData
-(instancetype)initWithDictionary:(NSDictionary *)dc
{
    if (self = [super initWithDictionary:dc])
    {
        if ([Utility IsEmptyString:self.xVlue])
        {
            self.xVlue = [[NSString stringWithFormat:@"%@",dc[@"date"]]  substringFromIndex:5];
            self.date = dc[@"date"];
            if ([Utility IsEmptyString:self.xVlue]||dc[@"startDate"]) {
                self.xVlue = [NSString stringWithFormat:@"%@-%@",[[NSString stringWithFormat:@"%@",dc[@"startDate"]]  substringFromIndex:5],[[NSString stringWithFormat:@"%@",dc[@"finishDate"]]  substringFromIndex:5]];
                self.date = dc[@"startDate"];
                
            }
            
            if ([Utility IsEmptyString:self.xVlue]||dc[@"month"]) {
                self.xVlue = dc[@"month"];
                self.date = dc[@"month"];
            }
            
        }
        if ([Utility IsEmptyString:self.time])
        {
            self.time = [NSString stringWithFormat:@"%ld",[dc[@"minutes"] integerValue]] ;
        }
        if ([Utility IsEmptyString:self.day])
        {
            self.day = [NSString stringWithFormat:@"%ld",[dc[@"days"] integerValue]];
        }
        
        self.trainCount = [dc[@"count"] intValue];
        CGFloat f =[dc[@"minutes"] intValue]/60;
        self.trainTime =[dc[@"minutes"] intValue]>0&&f <1?1: [dc[@"minutes"] intValue]/60;
        
        
        
        
        
    }
    return self;
}

@end


@implementation WRTrainData
-(instancetype)initWithDictionary:(NSDictionary *)dc
{
    if (self = [super initWithDictionary:dc])
    {
        
    }
    return self;
}

@end

@implementation WRComment

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        self.uuid = dict[@"uuid"];
        self.name = dict[@"name"];
        self.headImg = dict[@"headImg"];
        self.context = dict[@"context"];
        self.date = dict[@"date"];
        
    }
    return self;

}


@end

@implementation WRAskComment

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        if ([dict[@"userinfos"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary*info =dict[@"userinfos"];
        
        self.name = info[@"name"];
        self.headImg = info[@"headImageUrl"];
        }
    }
    return self;
    
}


@end



@implementation WRcase

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        self.uuid = dict[@"id"];
        
    }
    return self;
    
}


@end


@implementation WRTestInfo

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        self.desc = dict[@"description"];
        
    }
    return self;
    
}

@end
@implementation WRImOrder

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        
    }
    return self;
    
}
@end

@implementation WRCircle

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        
    }
    return self;
    
}
@end

@implementation WRBanner

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        
        
    }
    return self;
    
}


@end

@implementation WRUser
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        
        
    }
    return self;
    
}
@end

@implementation WRCOMArticle
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        NSArray* ar = dict[@"comments"];
        NSMutableArray* arry = [NSMutableArray array];
        for (NSDictionary* dic in ar) {
            WRCOMcomment* com  = [[WRCOMcomment alloc]initWithDictionary:dic];
            [arry addObject:com];
        }
        ar = arry;
        _comments = ar;
    }
    return self;
    
}
@end

@implementation WRCOMcomment_usr
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        
        
    }
    return self;
    
}
@end

@implementation WRCOMcomment
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        
        
    }
    return self;
    
}
@end


@implementation WRMessage
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict])
    {
        
        
    }
    return self;
    
}
@end
