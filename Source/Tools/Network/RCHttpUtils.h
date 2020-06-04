//
//  RCHttpUtils.h
//  158Job
//
//  Created by Matech on 16/2/16.
//  Copyright © 2016年 X.H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCHttpUtils : NSObject

+(BOOL)UploadFile:(NSURL*)fileURL url:(NSString*)url;
+(void)uploadImage:(UIImage*)image uploadUrl:(NSString*)uploadUrl complete:(void (^)(NSData *responseData, NSError *error))completion;

@end
