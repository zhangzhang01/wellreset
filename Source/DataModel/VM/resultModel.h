//
//  resultModel.h
//  rehab
//
//  Created by matech on 2019/11/21.
//  Copyright © 2019 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface resultModel : NSObject
@property(copy,nonatomic)NSString* high;
@property(copy,nonatomic)NSString* part;
@property(copy,nonatomic)NSMutableArray* ODIArray;
@property(copy,nonatomic)NSMutableArray* JOAArray;
-(id)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
