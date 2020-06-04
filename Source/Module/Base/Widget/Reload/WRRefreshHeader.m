//
//  WRRefreshHeader.m
//  rehab
//
//  Created by herson on 6/28/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRRefreshHeader.h"

@implementation WRRefreshHeader

-(void)prepare {
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    [super prepare];
    
    NSMutableArray *refreshingImages = [NSMutableArray array];
    NSInteger count = 8;
    NSTimeInterval timeInterval = 0.5;
    for (NSUInteger i = 1; i<= count; i++) {
        NSUInteger index = i;
        if (index > count) {
            index = 2*count - index;
        }
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%zd", index]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages duration:timeInterval forState:MJRefreshStateIdle];
    // Set the refreshing state of animated images
    [self setImages:refreshingImages duration:timeInterval forState:MJRefreshStateRefreshing];
}

@end
