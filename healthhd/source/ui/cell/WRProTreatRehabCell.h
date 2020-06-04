//
//  WRProTreatRehabCell.h
//  rehab
//
//  Created by Matech on 4/11/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ProTreatRehabDetailProgressState)
{
    ProTreatRehabDetailProgressStateUndo = -1,
    ProTreatRehabDetailProgressStateDefault = 0,
    ProTreatRehabDetailProgressStateDone = 1,
    ProTreatRehabDetailProgressStateLock
};

@interface WRProTreatRehabDetailBannerCell : UITableViewCell

@end

@interface WRProTreatRehabDetailVideosCell : UITableViewCell
@property(nonatomic) UIScrollView *scrollView;
@end


@interface WRProTreatRehabDetailProgressCell : UITableViewCell
@property(nonatomic) ProTreatRehabDetailProgressState state;
@end