//
//  MeCategoryCell.m
//  rehab
//
//  Created by 何寻 on 6/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "MeCategoryCell.h"

@interface MeCategoryCell()
{
    NSMutableArray *_itemsArray;
}
@end

@implementation MeCategoryCell

+(void)getlayoutInfoWithItemCount:(NSUInteger)count
                        position:(CGPoint*)position
                           offset:(CGFloat*)offset
                         itemSize:(CGSize *)itemSize
                   containerSize:(CGSize)containerSize
{
    CGFloat cx, cy, offsetX = WRUIOffset;
    UIImage *image = [UIImage imageNamed:@"cell_icon_favor"];

    cx = image.size.width + 2*offsetX;
    cy = image.size.height + 2*offsetX + 30;
    
    CGFloat y = (containerSize.height - cy)/2;
    CGFloat x = (containerSize.width - count*cx - (count - 1)*offsetX)/2;
    *position = CGPointMake(x, y);

    *itemSize = CGSizeMake(cx, cy);
    *offset = offsetX;
}

-(instancetype)initWithTitles:(NSArray*)titles images:(NSArray*)images reuseIdentifier:(NSString*)reuseIdentifier {
    if (self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _itemsArray = [NSMutableArray array];
        CGFloat cx = 0, cy = 0, offset = WRUIOffset;
        for(NSUInteger index = 0; index < titles.count; index++) {
            NSString *title = titles[index];
            NSString *imageName = images[index];
        
            UIImage *image = [UIImage imageNamed:imageName];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:image forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont wr_detailFont];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            if (cx == 0) {
                cx = image.size.width + 2*offset;
                cy = image.size.height + 2*offset + 30;
            }
            button.frame = CGRectMake(0, 0, cx, cy);
            button.tag = index;
            [button wr_verticalImageAndTitle:5];
            [button addTarget:self action:@selector(onClickedItem:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [_itemsArray addObject:button];
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
    
    if (_itemsArray.count == 0) {
        return;
    }
    
    CGRect frame = self.contentView.bounds;
    UIButton *button = _itemsArray.firstObject;
    CGFloat y = (frame.size.height - button.bounds.size.height)/2;
    CGFloat offset = WRUIOffset;
    CGFloat x = (frame.size.width - _itemsArray.count*button.frame.size.width - (_itemsArray.count - 1)*offset)/2;
    for(UIButton *button in _itemsArray) {
        button.frame = [Utility moveRect:button.frame x:x y:y];
        x = CGRectGetMaxX(button.frame) + offset;
    }
}

-(IBAction)onClickedItem:(UIButton*)sender {
    if (self.itemAction) {
        self.itemAction(sender.tag);
    }
}

@end
