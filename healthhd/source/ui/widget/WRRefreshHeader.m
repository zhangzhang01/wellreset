//
//  WRRefreshHeader.m
//  rehab
//
//  Created by 何寻 on 6/28/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRRefreshHeader.h"

@implementation WRRefreshHeader

-(void)prepare {
    [super prepare];
    
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<= 6; i++) {
        NSUInteger index = i;
        if (index > 6) {
            index = 12 - index;
        }
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%zd", index]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages duration:1.8 forState:MJRefreshStateIdle];
    // Set the refreshing state of animated images
    [self setImages:refreshingImages duration:1.8 forState:MJRefreshStateRefreshing];
}

@end
