//
//  reportModel.m
//  rehab
//
//  Created by matech on 2019/3/15.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "reportModel.h"

@implementation reportModel
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        _issueId= dic[@"issueId"];
        _issueName = dic[@"issueName"];
        _symptomId = dic[@"symptomId"];
        _updateDate = dic[@"updateDate"];
        _isTrue =[NSString stringWithFormat:@"%@",dic[@"isTrue"]] ;
        _issDesc = dic[@"issDesc"];
        _issFile = dic[@"issFile"];
        _grade = [NSString stringWithFormat:@"%@",dic[@"grade"]];
        _improvement = [NSString stringWithFormat:@"%@",dic[@"improvement"]];
        _SecondobjectArray = [NSMutableArray array];
        NSArray *questionArr = dic[@"des"];
        for (NSDictionary *dic in questionArr) {
            questionModel *model = [[questionModel alloc]initWithDic:dic];
            [_SecondobjectArray addObject:model];
        }
        
    }
    return self;
}
@end
