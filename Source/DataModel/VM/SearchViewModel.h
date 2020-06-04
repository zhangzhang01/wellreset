//
//  SearchViewModel.h
//  rehab
//
//  Created by herson on 2016/10/7.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRViewModel.h"
#import "RehabObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewModel : WRViewModel

@property(nonatomic, nullable)NSArray<WRRehabDisease*> *treatDiseases, *proTreatDiseases;
@property(nonatomic, nullable)NSArray<WRArticle*> *articles;
@property(nonatomic, nullable)NSArray<WRHotWord*> *hotWords;
-(BOOL)isEmpty;

+(void)searchKeywords:(nonnull NSString*)keywords completion:(void (^_Nullable)(NSError * _Nullable, SearchViewModel *_Nullable viewModel))completion;;

- (void)searchHotWordWithCompletion:(void (^)(NSError* error))completion;

@end

NS_ASSUME_NONNULL_END
