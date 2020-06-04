//
//  selectSingleTableViewCell.h
//  rehab
//
//  Created by yefangyang on 2019/3/11.
//  Copyright © 2019 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "selectSingleView.h"
#import "questionModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol questionCellClickDelegate <NSObject>

// 添加人员
- (void)addUserDicToUsers:(questionModel *)userDic;
// 删减人员
- (void)deleteUserDicFromUsers:(questionModel *)userDic;
@end
@interface selectSingleTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property(nonatomic,retain)UIButton *collectbutton10;
@property (retain, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  questionModel * totalModel;
@property (assign, nonatomic)  CGFloat height;
@property(nonatomic,copy)void(^saveData)(NSInteger  tagg);
@property(nonatomic,copy)void(^saveModelData)(NSMutableArray  *modelArray);
@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property(nonatomic,assign)NSInteger tagg;



@property (nonatomic, weak) id<questionCellClickDelegate> questionDelegate;
-(void)setModelValue:(questionModel *)model;
-(void)setbuttonModelValue:(questionModel *)model;
-(void)setMorebuttonModelValue:(NSMutableArray *)modelArray;
@end

NS_ASSUME_NONNULL_END
