//
//  WRViewModel+Common.h
//  rehab
//
//  Created by herson on 2016/11/18.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRViewModel.h"

typedef NS_ENUM(NSInteger, OperationType)
{
    OperationTypeNotification,
    OperationTypeFavor,
    OperationTypeUserCommonDisease,
    OperationTypeUserDiseasePhoto,
    OperationTypeProTreatArticle
};

typedef NS_ENUM(NSInteger, OperationActionType)
{
    OperationActionTypeUnknown,
    OperationActionTypeAdd,
    OperationActionTypeDelete
};

typedef NS_ENUM(NSInteger, OperationContentType)
{
    OperationContentTypeUnknown,
    OperationContentTypeTreat,
    OperationContentTypeArticle,
    OperationContentTypeStage,
    OperationContentTypeTreatStage,
    OperationContentTypeProTreatStage,
};

NS_ASSUME_NONNULL_BEGIN

@interface WRViewModel(Common)

#pragma mark - Common Action
+(void)operationWithType:(OperationType)type
                 indexId:(NSString*)indexId
              actionType:(OperationActionType)actionType
             contentType:(OperationContentType)contentType
              completion:(void(^)(NSError* error))completion;

+(void)userGetCollectionListWithCompletion:(void (^)(NSError * _Nullable, id _Nullable))completion type:(OperationContentType)type;

@end

NS_ASSUME_NONNULL_END
