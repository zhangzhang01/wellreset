//
//  questionModel.m
//  rehab
//
//  Created by matech on 2019/3/15.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "questionModel.h"
//#import "optionModel.h"
@implementation questionModel
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        _describeId =dic[@"describeId"];
        _describetTtle =dic[@"describetTtle"];
        _describeText =dic[@"describeText"];
        _issueId=dic[@"issueId"];
        _grade=[NSString stringWithFormat:@"%@",dic[@"grade"]];
//        _isTrue=[NSString stringWithFormat:@"%@",dic[@"isTrue"]];
    }
    return self;
}
@end
