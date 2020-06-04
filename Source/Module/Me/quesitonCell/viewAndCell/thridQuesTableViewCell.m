//
//  thridQuesTableViewCell.m
//  rehab
//
//  Created by matech on 2019/11/18.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "thridQuesTableViewCell.h"

@implementation thridQuesTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}
-(void)setUpAllView
{
    self.mainView = [UIView zj_viewWithBackColor:[UIColor whiteColor] supView:self.contentView constraints:^(MASConstraintMaker *make) {
           
           make.top.equalTo(self.contentView).offset(10);
           make.left.equalTo(self.contentView).offset(10);
           make.right.equalTo(self.contentView).offset(-10);
           make.height.mas_equalTo(610);
           
       }];
    self.mainView.layer.cornerRadius = 20.0;
    self.mainView.layer.masksToBounds= YES;
    
    
    self.pictView = [UIImageView zj_imageViewWithImage:nil SuperView:self.mainView constraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.mainView).offset(10);
        make.right.equalTo(self.mainView).offset(-10);
        make.bottom.equalTo(self.mainView).offset(-10);
    }];
    self.pictView.contentMode = UIViewContentModeScaleAspectFit;
    
//    self.pictView.backgroundColor = [UIColor redColor];
}
-(void)setHightWithIndex:(NSInteger)index
{
    if (index== 2) {
        [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(640);
        }];
    }else{
        [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.contentView).offset(10);
                   make.left.equalTo(self.contentView).offset(10);
                   make.right.equalTo(self.contentView).offset(-10);
                   make.height.mas_equalTo(570);
               }];
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
