//
//  reportModel.h
//  rehab
//
//  Created by matech on 2019/3/15.
//  Copyright © 2019 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "questionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface reportModel : NSObject
@property(copy,nonatomic)NSMutableArray* questionArr;
@property(copy,nonatomic)NSString* isTrue;
@property(copy,nonatomic)NSString* issDesc;
@property(copy,nonatomic)NSString* issFile;
@property(copy,nonatomic)NSString* issueId;
@property(copy,nonatomic)NSString* issueName;
@property(copy,nonatomic)NSString* symptomId;
@property(copy,nonatomic)NSString* updateDate;
@property(copy,nonatomic)NSString* grade;
@property(copy,nonatomic)NSString* improvement;
@property(copy,nonatomic)NSMutableArray* SecondobjectArray;
-(id)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
