//
//  questionResultViewController.h
//  rehab
//
//  Created by matech on 2019/11/13.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface questionResultViewController : WRViewController
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *secondArray;
@property(nonatomic,strong)NSMutableArray *detailArray;
@property(nonatomic,strong)NSString *tagStr;
@end

NS_ASSUME_NONNULL_END
