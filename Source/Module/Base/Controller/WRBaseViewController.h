//
//  WRBaseViewController.h
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JTNavigationController.h"
#import "UIKit+AFNetworking.h"
#import "SVProgressHUD.h"
#import "WRUserInfo.h"
#import "WRViewModel.h"
#import "UMengUtils.h"

@interface WRViewController : UIViewController
@property NSString* umstr;
-(CGRect)getClientFrame;


@end

@interface WRNavigationController : JTNavigationController
@end

@interface WRBaseNavigationController : UINavigationController
@end

@interface WRTableViewController : UITableViewController
@property NSString* umstr;
-(void)defaultStyle;
@end

@interface WRTextViewController : WRViewController
@property(nonatomic)UITextView *textView;
@end

@interface WRWebViewController : WRViewController
@property(nonatomic)UIWebView *webView;
@end

@interface WRScrollViewController : WRViewController
@property(nonatomic) UIScrollView* scrollView;
@end

@interface WRInputViewController : WRViewController

@property(nonatomic, copy)void(^completion)();

@property(nonatomic)UITextView *textView;
@end
