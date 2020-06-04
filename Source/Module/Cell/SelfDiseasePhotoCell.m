//
//  SelfDiseasePhotoCell.m
//  rehab
//
//  Created by herson on 8/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "SelfDiseasePhotoCell.h"
#import <YYKit/YYKit.h>
#define row_count 2
#define iPadRow_count 1
@interface SelfDiseasePhotoCell ()
{
    NSUInteger _itemCount;
    NSMutableArray<UIImageView*> *_tagArray;
}
@end

@implementation SelfDiseasePhotoCell

+(CGFloat)defaultHeightForTableView:(UITableView *)tableView
{

    NSUInteger columns;
    NSUInteger rowCount;
        BOOL biPad = [WRUIConfig IsHDApp];
    if (biPad) {
        rowCount = iPadRow_count;
        columns = 6;
    } else {
        columns = 3;
        rowCount = row_count;
    }

    UIImage *image = [UIImage imageNamed:@"icon_add"];
    CGFloat offset = (tableView.bounds.size.width*2*WRUIOffset/320);
    CGFloat x = offset;
    CGFloat cx = (tableView.bounds.size.width - (columns + 1)*x)/columns;
    CGFloat cy = image.size.height*cx/image.size.width;
    return (rowCount + 1)*offset + rowCount*cy;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _itemCount = 6;
        _tagArray = [NSMutableArray array];
        
        self.imageView.hidden = YES;
        self.textLabel.hidden = YES;
        self.detailTextLabel.hidden = YES;
        
        UIImage *image = [UIImage imageNamed:@"icon_add"];
        __weak __typeof(self) weakSelf = self;
        for(NSUInteger index = 0; index < _itemCount; index++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.tag = index;
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                [weakSelf onClickedTags:imageView];
            }];
            [imageView addGestureRecognizer:gesture];
            [self.textLabel.superview addSubview:imageView];
            [_tagArray addObject:imageView];
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
        BOOL biPad = [WRUIConfig IsHDApp];
    NSUInteger columns;
    if (biPad) {
        columns = _itemCount/iPadRow_count;
    } else {
        columns = _itemCount/row_count;
    }
    UIImageView *button = _tagArray.firstObject;
    CGFloat offset = (self.bounds.size.width*2*WRUIOffset/320);
    CGFloat x = offset, y = x;
    CGFloat cx = (self.bounds.size.width - (columns + 1)*x)/columns;
    CGFloat cy = button.size.height*cx/button.size.width;
    for (NSUInteger index = 0; index < _tagArray.count; index++)
    {
        UIView *button = _tagArray[index];
        button.frame = CGRectMake(x, y, cx, cy);
        x += cx + offset;
        if ((index + 1)%columns == 0) {
            x = offset;
            y += cy + offset;
        }
    }
}

#pragma mark - Control Event
-(IBAction)onClickedTags:(UIImageView*)sender
{
    if (self.clickBlock) {
        self.clickBlock(sender);
    }
}


#pragma mark -
-(void)setImages:(NSArray<NSString *> *)imageUrls
{
    NSUInteger index = 0;
    UIImage *image = [UIImage imageNamed:@"icon_add"];
    for (; index < imageUrls.count; index++)
    {
        if (index < _tagArray.count)
        {
            UIImageView *imageView = _tagArray[index];
            NSString *url = imageUrls[index];
            [imageView setImageWithURL:[NSURL URLWithString:url] placeholder:image];
        }
    }
    for(;index < _tagArray.count; index++)
    {
        UIImageView *imageView = _tagArray[index];
        imageView.image = image;
    }
}

@end
