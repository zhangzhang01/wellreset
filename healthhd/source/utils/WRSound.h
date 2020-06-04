//
//  WRSound.h
//  rehab
//
//  Created by Matech on 3/23/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRSound : NSObject

@property(nonatomic) NSUInteger count;

-(instancetype)initSystemShake;//系统 震动
-(instancetype)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;//初始化系统声音
+(instancetype)counter;
+(instancetype)overCounter;
-(void)play;//播放
-(void)process:(CFAbsoluteTime)timer completion:(void(^)())completion;

@end
