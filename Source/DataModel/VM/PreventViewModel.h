//
//  PreventViewModel.h
//  rehab
//
//  Created by herson on 2016/11/16.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRScene.h"

@interface PreventViewModel : NSObject

@property(nonatomic, readonly)NSMutableArray<WRScene*> *scenes;

-(void)fetchDataWithCompletion:(void (^)(NSError*))completion;

@end
