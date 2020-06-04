//
//  statusView.h
//  rehab
//
//  Created by matech on 2019/11/18.
//  Copyright © 2019 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface statusView : UIView
@property (nonatomic, strong) NSString *str;
-(void)setDataWith:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
