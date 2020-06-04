//
//  DownloadMusicViewModel.h
//  rehab
//
//  Created by yefangyang on 2016/10/25.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRViewModel.h"
#import "RehabObject.h"

@interface DownloadMusicViewModel : NSObject

@property (nonatomic, copy) NSString *url, *requestUrlString, *version;
@property (nonatomic, strong) NSArray *musicArray;

-(BOOL)needReload;
-(void)fetchDownloadDataWithCompletion:(void (^)(NSError *error))completion;
@end
