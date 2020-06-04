//
//  ChallengeNotifyView.h
//  rehab
//
//  Created by herson on 8/24/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeNotifyView : UIView

-(instancetype)initWithFrame:(CGRect)frame isExcellent:(BOOL)flag viewController:(UIViewController *)viewController shareUrl:(NSString *)shareUrl;

@property(nonatomic) UIImageView* lightImageView;
@property(nonatomic) UILabel *titleLabel, *detailLabel;
@property(nonatomic) NSString* videoId;
@property(nonatomic) NSInteger time;
@property(nonatomic, copy) void(^click)(NSInteger index);
@property(nonatomic, copy) void(^shareSuccessBlock)();
@property(nonatomic) UIImage* head;

@end
