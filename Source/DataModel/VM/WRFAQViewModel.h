//
//  WRFAQViewModel.h
//  rehab
//
//  Created by Matech on 3/10/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRBaseListViewModel.h"

@interface WRFAQViewModel : WRBaseListViewModel


-(void)fetchDataWithBlock:(ViewModeLoadCompleteBlock)block keyword:(NSString*)keyword;



+(void)userGetFavorStateWithArticleId:(NSString *)articleId
                           completion:(void (^)(NSError *error,WRArticle *article))completion;

@end
