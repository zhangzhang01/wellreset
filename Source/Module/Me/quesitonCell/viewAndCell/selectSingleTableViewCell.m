//
//  selectSingleTableViewCell.m
//  rehab
//
//  Created by yefangyang on 2019/3/11.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "selectSingleTableViewCell.h"
@interface selectSingleTableViewCell ()


@property (nonatomic, copy)NSArray *questionArray;
@property (nonatomic, copy)NSMutableArray *selectStateArray;

@end


@implementation selectSingleTableViewCell
- (NSMutableArray *)selectStateArray {
    
    if (!_selectStateArray) {
        _selectStateArray = [NSMutableArray array];
    }
    return _selectStateArray;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}
-(void)setUpAllView
{
    
    
    self.collectbutton10= [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectbutton10.frame = CGRectMake(10, 12.5, 25, 25);
//    self.selectImageV.backgroundColor = [UIColor redColor];
    self.collectbutton10.userInteractionEnabled = NO;
   [self addSubview:self.self.collectbutton10];
    

    // 标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 , 0, ScreenW-60, 50)];
    self.titleLabel.textColor =COLOR_grayColor;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 3.0;
//    self.titleLabel.backgroundColor = [UIColor blueColor];
    [self addSubview:self.titleLabel];
    
   
    
}
-(void)setModelValue:(questionModel *)model
{
    self.titleLabel.text = model.describetTtle;
}
//-(void)setbuttonModelValue:(questionModel *)model
//{
//    if ([model.formType isEqualToString:@"single-select"]) {
//        for (UIButton *button in self.buttonArray) {
//            
//            if (button.tag == model.tag) {
//                button.selected = model.isSelect;
//                break;
//            }
//        }
//    }
//}
//
//-(void)setMorebuttonModelValue:(NSMutableArray *)modelArray
//{
//    for (NSInteger i = 0 ; i < self.buttonArray.count; i ++) {
//        optionModel *model = self.totalModel.optionArr[i];
//        if ([modelArray containsObject:model]) {
//            UIButton *button = self.buttonArray[i];
//            button.selected = YES;
//        }
//    }
//}
//

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
