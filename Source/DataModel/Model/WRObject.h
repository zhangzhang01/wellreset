//
//  WRObject.h
//  rehab
//
//  Created by Matech on 3/10/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "NSObject+Property.h"

typedef NS_ENUM(NSInteger, WRExpertReplyState)
{
    WRExpertReplyStateWaiting,
    WRExpertReplyStateReplyed
};

@interface WRObject : NSObject
@property(nonatomic, copy) NSString *indexId, *name, *detail, *imageUrl;
-(instancetype)initWithDictionary:(NSDictionary *)dc;
@end

@interface WRUserPermission : WRObject
@property(nonatomic) NSInteger changeRehab, askCount, downloadOffline, collection;
-(void)reset;
@end

@interface WRLevelRule : WRObject
@property(nonatomic, copy) NSString *rule;
@end

@interface WRFAQ : WRObject
@property(nonatomic, copy) NSString *question, *answer, *keywords;
@end


@interface WRExpert : WRObject
@property(nonatomic, copy) NSString *field, *jobTitle, *picture, *uuid, *image_id, *headImage;
@end

@interface WRExpertReply : WRObject
@property(nonatomic, copy) NSString *askerId, *askTime, *expertId, *question, *content, *operTime, *userName, *headImage;
@property(nonatomic) NSInteger state,upvote,readCount,commentCount;
@property (assign, nonatomic) CGRect iconFrame;
@property (assign, nonatomic) CGRect nameFrame;
@property (assign, nonatomic) CGRect timeFrame;
@property (assign, nonatomic) CGRect questionFrame;
@property (assign, nonatomic) CGRect answerFrame;
@property (assign, nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat cellWidth;
@property (nonatomic) BOOL ifUpvoted;
@property (nonatomic) BOOL newreply;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRSyncData : NSObject
@property(nonatomic, copy)NSString *userId, *type, *value, *time;
@property(nonatomic) NSUInteger deviceType;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRCategory : WRObject
@property(nonatomic, copy)NSString *logoImgUrl, *subtitle , *typeID;
@property(nonatomic)NSMutableArray *wt;
@property(nonatomic,strong)NSMutableArray *wtArray;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRArticle : NSObject
@property(nonatomic, copy)NSString *uuid, *title, *subtitle, *imageUrl, *contentUrl, *createTime ,*typeId;
@property(nonatomic, assign)BOOL favor;
@property(nonatomic) BOOL hot;
@property(nonatomic, assign)NSInteger viewCount;
@property(nonatomic, assign)NSInteger commentCount;
@property(nonatomic) BOOL isHiddenComment;
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

@interface WRMusic: WRObject
@property(nonatomic, copy)NSString *fileName;
@end

@interface FavorContent : WRObject
@property(nonatomic) NSString *type, *createTime ,*contentId ;
@property(nonatomic) NSObject *collectContent;
@end

@interface WRHotWord : WRObject
@property(nonatomic, copy) NSString *searchKey;
@end

@interface WRDaliy : WRObject
@property(nonatomic) NSUInteger nextlevelXP , currentXP , nextLevel , currenLevel ,hadSignDays;
@property(nonatomic) NSArray <NSDictionary*>* awardArry;
@property(nonatomic) BOOL isFinishData, isBlinkPhone;
@property(nonatomic) NSArray <NSDictionary*>* taskarry;
@property(nonatomic) BOOL isDaliy;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end





@interface WRTrainData: WRObject
@property (nonatomic) NSString *diseaseName , *totalTime , *date ;
@property (nonatomic) NSInteger currentStep , totalStep;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end



@interface WRTrainChartData: WRObject
@property (nonatomic) NSString* xVlue , *time , *day , *date;
@property (nonatomic) NSInteger trainCount , trainTime , maxContiuDay , currentContiuday;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRComment : WRObject
@property (nonatomic) NSString* uuid , *name,*headImg,*context,*date,*userName;
@property (nonatomic)WRComment* chid;
-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end

@interface WRAskComment : WRObject
@property (nonatomic) NSString* userId , *name,*headImg,*content,*createTime;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end



@interface WRcase : WRObject
@property (nonatomic) NSString* type_id , *content_url,*title,*viewCount,*create_time,*imageurl,*diseaseName,*commentCount,*uuid , *imageurl2;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRTestInfo : WRObject
@property (nonatomic) NSString* maxwwt , *wwt,*desc,*createTime;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRImOrder : WRObject
@property (nonatomic) NSString* orderNo , *createTime,*payTime,*startDate,*endDate,*finishTime,*productName;
@property (nonatomic) NSInteger type,status,productPrice;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRUser : WRObject
@property(nonatomic) NSString* imgUrl,*userId;
@property(nonatomic,assign) NSInteger temporarys;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRCircle : WRObject
@property(nonatomic) NSString *uuid,*background,*resume,*headimg;
@property(nonatomic) NSInteger usercnt,articlecnt;
@property(nonatomic) BOOL isJoin;
@property(nonatomic) NSArray* circleUserImgs;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRCOMArticle : WRObject
@property(nonatomic) NSString * uuid,* topicName,* createTime,* text;
@property(nonatomic) NSInteger upvote,cnt;
@property(nonatomic) BOOL stick ,isupvote;
@property(nonatomic) WRUser* user;
@property(nonatomic) NSArray* images;
@property(nonatomic) NSArray* comments;
@property(nonatomic) NSArray* upvotes;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRCOMcomment_usr : WRObject
@property(nonatomic) NSString * repuserimg,* repusername,* reptext;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRCOMcomment : WRObject
@property(nonatomic) NSString * userimg,* username,* text,* createTime,* userId,* uuid ;
@property(nonatomic) NSString * repuserimg,* repusername,* reptext,* repuserId;
@property(nonatomic,copy)NSNumber *upvote;

@property(nonatomic) BOOL isupvote;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRBanner : WRObject
@property(nonatomic) NSString* title,* url,* uuid,* dynamic_id;
@property(nonatomic) NSInteger sort,type;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface WRMessage : WRObject
@property(nonatomic) NSString* action,* createTime,* img,* isread,* msg,* rltTime,* rltType,* rltMsg,* rltUUID,* type,* userId,* userImg,* userName,* uuid;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end





