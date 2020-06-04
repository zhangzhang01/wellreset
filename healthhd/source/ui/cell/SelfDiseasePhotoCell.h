//
//  SelfDiseasePhotoCell.h
//  rehab
//
//  Created by 何寻 on 8/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfDiseasePhotoCell : UITableViewCell

@property(nonatomic, copy) void(^clickBlock)(UIImageView* sender);

+(CGFloat)defaultHeightForTableView:(UITableView*)tableView;
-(void)setImages:(NSArray<NSString*>*)imageUrls;

@end
