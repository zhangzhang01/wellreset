//
//  questionTableViewCell.h
//  rehab
//
//  Created by matech on 2019/11/13.
//  Copyright © 2019 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "reportViewModel.h"
#import "reportModel.h"
#import "questionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface questionRSTableViewCell : UITableViewCell
@property(nonatomic,retain)UIView *mainView;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,assign)NSInteger g;
@property(nonatomic,retain)UILabel *secondLabel;
@property(nonatomic,retain)UILabel *detailLabel;
-(void)setModel:(NSMutableArray *)titleModelArray withSecondeModel:(reportModel *)secondModel withDetailModel:(questionModel *)detailModel withindex:(NSInteger)index withTag:(NSInteger)tag;
@end

NS_ASSUME_NONNULL_END
