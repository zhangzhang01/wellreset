//
//  questionModel.h
//  rehab
//
//  Created by matech on 2019/3/15.
//  Copyright © 2019 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface questionModel : NSObject
@property(copy,nonatomic)NSString* describeId;
@property(copy,nonatomic)NSString* describetTtle;
@property(copy,nonatomic)NSString* describeText;
@property(copy,nonatomic)NSString* issueId;
@property(copy,nonatomic)NSString* grade;
//@property(copy,nonatomic)NSString* isTrue;

@property(nonatomic)NSInteger tag;
@property(nonatomic)BOOL   isSelect;
-(id)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
