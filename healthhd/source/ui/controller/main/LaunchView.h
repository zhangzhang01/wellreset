//
//  LaunchView.h
//  rehab
//
//  Created by Matech on 4/27/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchView : UIView

@property(nonatomic,copy)void(^completion)();

-(void)start;

@end
