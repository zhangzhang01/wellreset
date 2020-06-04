//
//  SelfCommonDiseaseCell.m
//  rehab
//
//  Created by 何寻 on 8/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "SelfCommonDiseaseCell.h"

#define tag_height 28
#define row_count 2

@interface SelfCommonDiseaseCell ()
{
    NSUInteger _itemCount;
    NSMutableArray *_tagArray;
}
@end

@implementation SelfCommonDiseaseCell

+(CGFloat)defaultHeight
{
    NSUInteger rowCount = row_count;
    return (rowCount + 1)*WRUIOffset + rowCount*tag_height;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _itemCount = SelfCommonDiseaseCellGridCount;
        _tagArray = [NSMutableArray array];
        
        self.imageView.hidden = YES;
        self.textLabel.hidden = YES;
        self.detailTextLabel.hidden = YES;
        
        for(NSUInteger index = 0; index < _itemCount; index++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = index;
            [button wr_roundBorderWithColor:[UIColor lightGrayColor]];
            button.titleLabel.font = [UIFont wr_detailFont];
            [button setTitle:@"+" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onClickedTags:) forControlEvents:UIControlEventTouchUpInside];
            [self.textLabel.superview addSubview:button];
            [_tagArray addObject:button];
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
    CGFloat offset = WRUIOffset;
    NSUInteger columns = _itemCount/row_count;
    CGFloat x = offset, y = offset, cx = (self.bounds.size.width - (columns + 1)*offset)/columns, cy = tag_height;
    for (NSUInteger index = 0; index < _tagArray.count; index++)
    {
        UIButton *button = _tagArray[index];
        button.frame = CGRectMake(x, y, cx, cy);
        x += cx + offset;
        if ((index + 1)%columns == 0) {
            x = offset;
            y += cy + offset;
        }
    }
}

#pragma mark - Control Event
-(IBAction)onClickedTags:(UIButton*)sender
{
    if (self.clickBlock) {
        self.clickBlock(sender);
    }
}


#pragma mark -
-(void)setTags:(NSArray<NSString *> *)tags
{
    NSUInteger index = 0;
    for (; index < tags.count; index++)
    {
        if (index < _tagArray.count)
        {
            UIButton *button = _tagArray[index];
            [button setTitle:tags[index] forState:UIControlStateNormal];
        }
    }
    for(;index < _tagArray.count; index++)
    {
        UIButton *button = _tagArray[index];
        [button setTitle:@"+" forState:UIControlStateNormal];
    }
}


@end
