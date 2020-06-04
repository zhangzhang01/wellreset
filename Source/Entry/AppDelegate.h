//
//  AppDelegate.h
//  rehab
//
//  Created by HX on 16/2/5.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseUI.h"



//#import <Hyphenate/Hyphenate.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,
EMChatManagerDelegate>
{
    EMConnectionState _connectionState;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSDictionary *probt;
@property NSString* taburl;
@property NSString* code;//微信授权code
@property NSMutableDictionary* circle_protocol;
@end

