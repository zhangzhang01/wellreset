//
//  firstQuesTableViewCell.h
//  rehab
//
//  Created by matech on 2019/11/18.
//  Copyright © 2019 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface firstQuesTableViewCell : UITableViewCell
@property(nonatomic,retain)UIView *mainView;
@property(nonatomic,retain)UIButton *nameBtn;
@property(nonatomic,retain)UIButton *sexBtn;
@property(nonatomic,retain)UIButton *brithBtn;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)UILabel *sexLabel;
@property(nonatomic,retain)UILabel *brithLabel;
-(void)setModel;
@end

NS_ASSUME_NONNULL_END
