//
//  CategoryView.m
//  rehab
//
//  Created by herson on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "CategoryView.h"
#import <YYKit/YYKit.h>
@interface CategoryView()
{
    NSMutableArray *_itemsArray;
    NSMutableArray *_lineArray;
}
@end

@implementation CategoryView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titleArray icons:(NSArray<NSString *> *)iconNameArray itemWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight
{
    if (self = [super initWithFrame:frame])
    {
        BOOL biPad = [WRUIConfig IsHDApp];
        _itemsArray = [NSMutableArray array];
        _lineArray = [NSMutableArray array];
        CGFloat cx = itemWidth, cy = itemHeight;
        CGFloat offset = 3;
//        UIImage *lineImage = [UIImage imageNamed:@"light_line"];
        for(NSUInteger index = 0; index < titleArray.count; index++) {
            NSString *title = titleArray[index];
            NSString *imageName = iconNameArray[index];
            
            UIImage *image = [[UIImage imageNamed:imageName] imageByTintColor:[UIColor whiteColor]];
            image = [image imageByResizeToSize:CGSizeMake(image.size.width/2, image.size.height/2)];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (index < titleArray.count - 1) {
                UIView *line = [UIView new];
                line.backgroundColor = [UIColor wr_lightWhite];
                [_lineArray addObject:line];
                line.frame = CGRectMake(0, offset, 1, cy - 2*offset);
                [self addSubview:line];
            }
            [button setImage:image forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont wr_smallFont];
            if (biPad) {
                button.titleLabel.font = [UIFont wr_titleFont];
            }
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, cx - 1, cy - 1);
            button.tag = index;
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//            [button wr_verticalImageAndTitle:5];
            [button addTarget:self action:@selector(onClickedItem:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [_itemsArray addObject:button];
        }
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (_itemsArray.count == 0)
    {
        return;
    }
    CGRect frame = self.bounds;
    UIButton *button = _itemsArray.firstObject;
    CGFloat y = (frame.size.height - button.bounds.size.height)/2;
    CGFloat x = (frame.size.width - _itemsArray.count*button.frame.size.width)/(_itemsArray.count + 1);
    CGFloat offset = x;
    for(UIButton *button in _itemsArray)
    {
        button.frame = [Utility moveRect:button.frame x:x y:y];
        x = button.right + offset;
    }
    CGFloat x0, y0;
    y0 = 0;
    x0 = offset + button.frame.size.width;
    for (UIView *line in _lineArray) {
        line.frame = [Utility moveRect:line.frame x:x0 y:y0];
        x0 += button.frame.size.width;
    }
}

-(IBAction)onClickedItem:(UIButton*)sender {
    if (self.itemAction) {
        self.itemAction(sender.tag, [sender titleForState:UIControlStateNormal]);
    }
}

@end
