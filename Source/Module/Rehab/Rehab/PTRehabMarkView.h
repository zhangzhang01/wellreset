//
//  PTRehabMarkView.h
//  rehab
//
//  Created by herson on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTRehabMarkView : UIView

-(instancetype)initWithFrame:(CGRect)frame beginDate:(NSDate*)beginDate days:(NSInteger)days;

-(void)checkForDateArray:(NSArray<NSDate*>*)dateArray;

@property(nonatomic, copy) void(^clickedEvent)(UILabel* sender);

@end
