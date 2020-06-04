//
//  reportViewModel.m
//  rehab
//
//  Created by matech on 2019/3/15.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "reportViewModel.h"

@implementation reportViewModel
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        
        _symptomId =dic[@"symptomId"];
        _symptomName =dic[@"symptomName"];
        _updateDate =dic[@"updateDate"];
        _distinction=dic[@"distinction"];
         _objectArray= [NSMutableArray array];
               NSArray *questionArr = dic[@"iss"];
               for (NSDictionary *dic in questionArr) {
                   reportModel *model = [[reportModel alloc]initWithDic:dic];
                   [_objectArray addObject:model];
               }
        
      
        
        
        
    }
    return self;
}
@end
