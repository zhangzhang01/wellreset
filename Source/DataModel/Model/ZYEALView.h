//
//  ZYEALView.h
//  rehab
//
//  Created by yongen zhou on 2017/10/25.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDauthCode.h"
@interface ZYEALView : UIView
- (instancetype)initwithPhone:(NSString*)phone type:(NSString*)type;
@property NSString* phone;
@property NSString* type;
@property SDauthCode * codeview;
@property UILabel* title;
@property UITextField* textfield;
@property UIView* lineview;
@property UIView* midview;
@property UIButton* sure;
@property UIButton* closs;
@property NSString* codeid;
@property UIView* bacview;
@property(nonatomic)void(^completionBlock)(NSString* text,NSString* codeid);
@property(nonatomic)void(^clossBlock)();
@end
