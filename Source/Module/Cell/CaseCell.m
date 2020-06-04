//
//  CaseCell.m
//  rehab
//
//  Created by yongen zhou on 2017/3/17.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "CaseCell.h"
#import <YYKit/YYKit.h>
@implementation CaseCell

- (void)layout:(WRcase*)wrcase
{
    self.name.text = wrcase.title;
    self.dise.text = wrcase.diseaseName;
    self.date.text = wrcase.create_time;
    self.person.text = wrcase.viewCount;
    self.comment.text =[NSString stringWithFormat:@"%@",wrcase.commentCount] ;
    [self.im setImageWithURL:[NSURL URLWithString:wrcase.imageurl2] placeholder:[UIImage imageNamed:@"well_default_banner"]];
    self.im.contentMode = UIViewContentModeScaleAspectFill;
    self.im.clipsToBounds =YES;
}

@end
