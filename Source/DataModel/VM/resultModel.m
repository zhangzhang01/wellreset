//
//  resultModel.m
//  rehab
//
//  Created by matech on 2019/11/21.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "resultModel.h"
#import "reportModel.h"
#import "questionModel.h"
@implementation resultModel
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _high =[NSString stringWithFormat:@"%@",dic[@"describeId"]];
        _part =[NSString stringWithFormat:@"%@",dic[@"part"]];
        
         _ODIArray= [NSMutableArray array];
         _JOAArray= [NSMutableArray array];
        
        NSArray *questionArr = dic[@"ODI"];
               for (NSDictionary *dic in questionArr) {
                   questionModel *model = [[questionModel alloc]initWithDic:dic];
                   [_ODIArray addObject:model];
               }
        
        NSArray *joaArr = dic[@"JOA"];
                      for (NSDictionary *dic in joaArr) {
                          reportModel *model = [[reportModel alloc]initWithDic:dic];
                          [_JOAArray addObject:model];
                      }
    }
    return self;
}
@end
