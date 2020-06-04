//
//  WRView.m
//  rehab
//
//  Created by Matech on 3/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRView.h"

@implementation WRVideoThumbControl

+(CGFloat)heightForTitles:(NSArray<NSString *>*)titles {
    static UILabel *label = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        label = [self videoTitleLabel];
    });
    
    UIImage *defaultVideoImage = [UIImage imageNamed:@"well_default_video"];
    CGFloat dy = 0;
    for(NSString* title in titles)
    {
        label.text = title;
        dy = MAX(dy, [label sizeThatFits:CGSizeMake(defaultVideoImage.size.width, CGFLOAT_MAX)].height);
    }
    return dy + defaultVideoImage.size.height + WRUINearbyOffset;
}

+(CGFloat)getHeightWithTitles:(NSArray<NSString *> *)titles videhThumbHeight:(CGFloat)videhThumbHeight
{
    static UILabel *label = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        label = [self videoTitleLabel];
    });
    
    UIImage *defaultVideoImage = [UIImage imageNamed:@"well_default_video"];
    CGFloat dy = 0;
    CGFloat cx = (videhThumbHeight*defaultVideoImage.size.width/defaultVideoImage.size.height);
    for(NSString* title in titles)
    {
        label.text = title;
        dy = MAX(dy, [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)].height);
    }
    return dy + videhThumbHeight + WRUINearbyOffset;
}

- (instancetype)initWithHeight:(CGFloat)height
                   videoHeight:(CGFloat)videoHeight
                             x:(CGFloat)x
                             y:(CGFloat)y
                      imageUrl:(NSString*)imageUrl
                         title:(NSString*)title
{
    UIImage *defaultVideoImage = [UIImage imageNamed:@"well_default_video"];
    CGFloat cx = videoHeight*defaultVideoImage.size.width/defaultVideoImage.size.height;
    CGRect frame = CGRectMake(x, y, cx, height);
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat offset = WRUINearbyOffset, x = 0, y = x, cy = videoHeight;
        cx =  frame.size.width;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        [imageView setImageWithUrlString:imageUrl holder:@"well_default_video"];
        [imageView wr_setShadow];
        [self addSubview:imageView];
        
        UIImageView *playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"well_icon_video_thumb"]];
        playImageView.frame = [Utility moveRect:playImageView.frame x:(imageView.center.x - playImageView.frame.size.width/2) y:(imageView.center.y - playImageView.frame.size.height/2)];
        [self addSubview:playImageView];
        
        y += cy + offset;
        UILabel *label = [WRVideoThumbControl videoTitleLabel];
        label.text = title;
        CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y, cx, MIN(size.height, height - videoHeight));
        [self addSubview:label];
    }
    return self;
}

+ (UILabel*)videoTitleLabel{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont wr_detailFont];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

@end


#define GridThumbViewOffset 3

@implementation GridThumbView

-(instancetype)initWithFrame:(CGRect)frame style:(GridThumbViewStyle)style placeHolderImage:(UIImage *)image{
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [WRUIConfig IsHDApp] ? [UIFont wr_titleFont] : [UIFont wr_tinyFont];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1;
        label.text = @" ";
        [self addSubview:label];
        self.titleLabel = label;
        
        label = [[UILabel alloc] init];
        label.font = [WRUIConfig IsHDApp] ? [UIFont wr_titleFont] : [UIFont wr_detailFont];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1;
        label.text = @" ";
        [self addSubview:label];
        self.detailLabel = label;
    }
    
    return self;
}

-(void)setEnable:(BOOL)enable
{
    _enable = enable;
    if (!self.visibleLabel) {
        if (!enable) {
            UILabel *label = [[UILabel alloc] initWithFrame:self.imageView.frame];
            
            UILabel *textLabel = [UILabel new];
            textLabel.backgroundColor = [UIColor colorWithHexString:@"606060dd"];
            textLabel.textColor = [UIColor lightGrayColor];
            textLabel.font = [UIFont wr_detailFont];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.text = NSLocalizedString(@"敬请期待", nil);
            [textLabel sizeToFit];
            CGFloat cy = textLabel.height + 6;
            textLabel.frame = CGRectMake(0, (self.imageView.height - cy)/2, self.imageView.width, cy);
            [label addSubview:textLabel];
            
            [self addSubview:label];
            self.visibleLabel = label;
        }
    }
    self.visibleLabel.hidden = enable;
}

-(void)makeRoundStyle {
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 6.f;
}

-(void)sizeToFit {
    if (self.style == GridThumbViewStyleDefault) {
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
        CGFloat cy = (self.imageView.bounds.size.height*self.bounds.size.width)/self.imageView.bounds.size.width;
        cy += size.height + GridThumbViewOffset;
        if (self.detailLabel) {
            size = [self.detailLabel sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
            cy += size.height + GridThumbViewOffset;
        }
        self.frame = [Utility resizeRect:self.frame cx:self.width height:cy];
    } else {
        [super sizeToFit];
    }
}

-(void)layoutSubviews
{
    if (self.style == GridThumbViewStyleDefault)
    {
        CGRect frame = self.bounds;
        CGFloat cx = frame.size.width, cy = (self.imageView.frame.size.height*cx)/self.imageView.frame.size.width, offset = GridThumbViewOffset;
        self.imageView.frame = CGRectMake(0, 0, cx, cy);
        self.visibleLabel.frame = self.imageView.frame;
        
        CGFloat y = self.imageView.bottom + offset;
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        self.titleLabel.frame = CGRectMake(0, y, frame.size.width, size.height);
        y = self.titleLabel.bottom + offset;
        size = [self.detailLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        self.detailLabel.frame = CGRectMake(0, y, frame.size.width, size.height);
    }
    else if(self.style == GridThumbViewStyle1)
    {
        CGFloat offset = WRUIOffset;
        CGRect frame = self.bounds;
        CGFloat cy = frame.size.height - 2*offset, cx = cy, x = frame.size.width - cx - WRUILittleOffset, y = WRUILittleOffset;
        self.imageView.frame = CGRectMake(x, y, cx, cy);
        self.imageView.layer.cornerRadius = cx/2;
        
        x = 0;
        cx = self.imageView.left - offset - x;
        
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        self.titleLabel.frame = CGRectMake(x, y, cx, size.height);
        y = self.titleLabel.bottom + WRUINearbyOffset;
        
        size = [self.detailLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        self.detailLabel.frame = CGRectMake(x, y, cx, size.height);
        
        self.visibleLabel.frame = self.bounds;
        UILabel *textLabel = self.visibleLabel.subviews.firstObject;
        textLabel.frame = CGRectMake(0, (self.visibleLabel.height - textLabel.height)/2, self.visibleLabel.width, textLabel.height);
    }
}
@end

