//
//  MemoryCheck.h
//  UTVgo
//
//  Created by wen on 12-12-12.
//  Copyright (c) 2012年 UTVGO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoryCheck : NSObject

+(void)Run;
- (double)usedMemory;
- (double)availableMemory;

@end
