//
//  CategoryView.m
//  rehab
//
//  Created by 何寻 on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "CategoryView.h"

@interface CategoryView()
{
    NSMutableArray *_itemsArray;
}
@end

@implementation CategoryView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titleArray icons:(NSArray<NSString *> *)iconNameArray itemWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight
{
    if (self = [super initWithFrame:frame])
    {
        BOOL biPad = [WRUIConfig IsHDApp];
        _itemsArray = [NSMutableArray array];
        CGFloat cx = itemWidth, cy = itemHeight;
        for(NSUInteger index = 0; index < titleArray.count; index++) {
            NSString *title = titleArray[index];
            NSString *imageName = iconNameArray[index];
            
            UIImage *image = [UIImage imageNamed:imageName];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:image forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont wr_smallestFont];
            if (biPad) {
                button.titleLabel.font = [UIFont wr_titleFont];
            }
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, cx, cy);
            button.tag = index;
            [button wr_verticalImageAndTitle:5];
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
}

-(IBAction)onClickedItem:(UIButton*)sender {
    if (self.itemAction) {
        self.itemAction(sender.tag, [sender titleForState:UIControlStateNormal]);
    }
}

@end
