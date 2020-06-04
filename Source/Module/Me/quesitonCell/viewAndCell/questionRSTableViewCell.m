//
//  questionTableViewCell.m
//  rehab
//
//  Created by matech on 2019/11/13.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "questionRSTableViewCell.h"

@implementation questionRSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
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
        make.height.mas_equalTo(120);
        
    }];
    self.mainView.layer.cornerRadius = 20.0;
    self.mainView.layer.masksToBounds= YES;
    
    self.titleLabel = [UILabel zj_labelWithFontSize:14 textColor:COLORBLUE superView:self.mainView constraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mainView);
            make.left.equalTo(self.mainView).offset(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
    self.titleLabel.textColor = [UIColor blackColor];
    
    self.secondLabel = [UILabel zj_labelWithFontSize:14 textColor:COLORBLUE superView:self.mainView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.mainView).offset(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    self.secondLabel.textColor = [UIColor blackColor];
    self.detailLabel = [UILabel zj_labelWithFontSize:14 textColor:COLORBLUE superView:self.mainView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondLabel.mas_bottom);
        make.left.equalTo(self.mainView).offset(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    self.detailLabel.textColor = COLOR(140, 211, 251, 1);
    
}
-(void)setModel:(NSMutableArray *)titleModelArray withSecondeModel:(reportModel *)secondModel withDetailModel:(questionModel *)detailModel withindex:(NSInteger)index withTag:(NSInteger)tag;
{
    
//    _g++;
//    NSLog(@"%ld",_g);
    if (tag == 0) {
        for (NSInteger i = 0 ; i < titleModelArray.count; i ++) {
              reportViewModel *model = titleModelArray[i];
              if ([model.objectArray containsObject:secondModel]) {
                  self.titleLabel.text =[NSString stringWithFormat:@"%ld.%@",index,model.symptomName] ;
              }
          }
        self.secondLabel.text = secondModel.issueName;
        self.detailLabel.text = detailModel.describetTtle;
    }else
    {
        self.secondLabel.text =[NSString stringWithFormat:@"%ld.%@",index,secondModel.issueName] ;
        self.detailLabel.text = detailModel.describetTtle;
    }
  
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
