//
//  WRView.h
//  rehab
//
//  Created by Matech on 3/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRVideoThumbControl : UIView

+ (CGFloat)heightForTitles:(NSArray<NSString*>*)titles;
+ (CGFloat)getHeightWithTitles:(NSArray<NSString*>*)titles videhThumbHeight:(CGFloat)videhThumbHeight;

- (instancetype)initWithHeight:(CGFloat)height
                   videoHeight:(CGFloat)videoHeight
                             x:(CGFloat)x
                             y:(CGFloat)y
                      imageUrl:(NSString*)imageUrl
                         title:(NSString*)title;

@end



typedef NS_ENUM(NSInteger, GridThumbViewStyle)
{
    GridThumbViewStyleDefault,
    GridThumbViewStyle1
};

@interface GridThumbView : UIView

@property(nonatomic) GridThumbViewStyle style;
@property(nonatomic) UIImageView *imageView;
@property(nonatomic) UILabel *titleLabel, *detailLabel, *visibleLabel;
@property(nonatomic) BOOL enable;
-(instancetype)initWithFrame:(CGRect)frame style:(GridThumbViewStyle)style placeHolderImage:(UIImage*)image;
-(void)makeRoundStyle;

@end

