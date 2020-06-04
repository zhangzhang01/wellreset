//
//  reportViewModel.h
//  rehab
//
//  Created by matech on 2019/3/15.
//  Copyright © 2019 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "reportModel.h"
@interface reportViewModel : NSObject
@property(copy,nonatomic)NSString* symptomId;
@property(copy,nonatomic)NSString* symptomName;
@property(copy,nonatomic)NSString* updateDate;
@property(copy,nonatomic)NSString* distinction;

@property(copy,nonatomic)NSMutableArray* objectArray;
-(id)initWithDic:(NSDictionary *)dic;
@end


