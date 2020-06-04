//
//  mainReportViewController.h
//  rehab
//
//  Created by yefangyang on 2019/3/7.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "WRBaseViewController.h"
#import "HWPublishBaseController.h"
NS_ASSUME_NONNULL_BEGIN

@interface mainReportViewController : HWPublishBaseController
@property (nonatomic, copy)void(^addressBlock)(NSArray *userArray);
@property (nonatomic, copy)void(^selectBlock)(NSArray *questionArray);
@property (nonatomic, strong)NSString *tag;
@end

NS_ASSUME_NONNULL_END
