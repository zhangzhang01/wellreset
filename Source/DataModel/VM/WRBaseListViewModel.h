//
//  WRBaseListViewModel.h
//  
//
//  Created by Matech on 16/2/18.
//  Copyright © 2016年 X.H. All rights reserved.
//

#import "WRViewModel.h"

@interface WRBaseListViewModel : WRViewModel
{
    NSInteger _pageNO, _pageSize;
}

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, copy)void(^didSelectedCellBlock)(UITableView*, NSIndexPath*);
@property(nonatomic, copy)ViewModeLoadCompleteBlock didDeleteCellBlock;
@property(nonatomic, assign)BOOL isLastPage;

-(void)clearData;
-(void)fetchDataWithBlock:(ViewModeLoadCompleteBlock)block;
-(void)fetchDataWithCompletion:(ViewModeLoadCompleteBlock)completion urlString:(NSString*)urlString templateBlock:(NSObject* (^)(id objectOffArray))block useCache:(BOOL)flag;

-(void)deleteObjectWithIndex:(NSUInteger)index completeBlock:(ViewModeLoadCompleteBlock)block;

@end
