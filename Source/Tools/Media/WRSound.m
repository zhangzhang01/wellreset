//
//  WRSound.m
//  rehab
//
//  Created by Matech on 3/23/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRSound.h"
#import <AudioToolbox/AudioToolbox.h>

@interface WRSound ()
{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
}
@end

@implementation WRSound

- (instancetype)initSystemShake
{
    self = [super init];
    if (self) {
        sound = kSystemSoundID_Vibrate;//震动
    }
    return self;
}

- (instancetype)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType
{
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
        //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
        //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
            if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
                return nil;
            }
        }
    }
    return self;
}

+(instancetype)counter {
    return [[self alloc] initSystemSoundWithName:@"sms-received3" SoundType:@"caf"];
}

+(instancetype)overCounter {
    return [[self alloc] initSystemSoundWithName:@"end_video_record.caf" SoundType:@"caf"];
}

- (void)play
{
    AudioServicesPlaySystemSound(sound);
}

-(void)process:(CFAbsoluteTime)timer completion:(void (^)())completion {
    if (self.count > 0) {
        self.count--;
        NSLog(@"%d s left", (int)self.count);
        [self play];
        __weak __typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf process:timer completion:completion];
        });
    } else {
        if (completion) {
            completion();
        }
    }
}
@end
