//
//  WRLocationHelper.h
//  rehab
//
//  Created by 何寻 on 3/27/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WRLocationHelperCompletionBlock)(NSError*);

@interface WRLocationHelper : NSObject

@property(nonatomic, copy) NSString* currentState, *currentCity;
@property(nonatomic, copy) WRLocationHelperCompletionBlock completion;

+(instancetype)defaultSerivce;

- (void)locate;

@end
