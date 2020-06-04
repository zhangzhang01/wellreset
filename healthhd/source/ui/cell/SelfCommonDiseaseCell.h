//
//  SelfCommonDiseaseCell.h
//  rehab
//
//  Created by 何寻 on 8/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SelfCommonDiseaseCellGridCount 8

@interface SelfCommonDiseaseCell : UITableViewCell

@property(nonatomic, copy) void(^clickBlock)(UIButton*sender);
+(CGFloat)defaultHeight;
-(void)setTags:(NSArray<NSString*>*)tags;

@end
