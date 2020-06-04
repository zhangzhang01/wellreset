//
//  thridQuesTableViewCell.h
//  rehab
//
//  Created by matech on 2019/11/18.
//  Copyright © 2019 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface thridQuesTableViewCell : UITableViewCell
@property(nonatomic,retain)UIView *mainView;
@property(nonatomic,retain)UIImageView *pictView;
-(void)setHightWithIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
