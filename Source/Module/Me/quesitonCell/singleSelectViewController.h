//
//  singleSelectViewController.h
//  rehab
//
//  Created by matech on 2019/12/17.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(NSMutableArray *backArray);
@interface singleSelectViewController : WRViewController
@property(nonatomic,strong)NSMutableArray *titleArray2;
@property(nonatomic,strong)NSMutableArray *secondArray2;
@property(nonatomic,strong)NSMutableArray *detailArray2;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,copy)ClickBlock backClick;
@end

NS_ASSUME_NONNULL_END
