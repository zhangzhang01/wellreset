//
//  firstQuesTableViewCell.m
//  rehab
//
//  Created by matech on 2019/11/18.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "firstQuesTableViewCell.h"

@implementation firstQuesTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}
-(void)setUpAllView
{
   self.mainView = [UIView zj_viewWithBackColor:[UIColor whiteColor] supView:self.contentView constraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(100);
        
    }];
    self.mainView.layer.cornerRadius = 20.0;
    self.mainView.layer.masksToBounds= YES;
    
    
    self.nameBtn = [UIButton zj_buttonWithTitle:@"姓名" titleColor:[UIColor blackColor] norImage:IMAGE(@"姓名") selectedImage:nil backColor:[UIColor clearColor] fontSize:14 isBold:NO borderWidth:0 borderColor:0 cornerRadius:0 supView:self.mainView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView).offset(0);
        make.left.equalTo(self.mainView).offset(10);
        make.width.mas_equalTo(ScreenW/3-40);
        make.height.mas_equalTo(50);
    } touchUp:^(id sender) {
        
    }];
    self.nameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0.0);
    self.sexBtn = [UIButton zj_buttonWithTitle:@"性别" titleColor:[UIColor blackColor] norImage:IMAGE(@"性别") selectedImage:nil backColor:[UIColor clearColor] fontSize:14 isBold:NO borderWidth:0 borderColor:0 cornerRadius:0 supView:self.mainView constraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mainView).offset(0);
          make.left.equalTo(self.nameBtn.mas_right).offset(10);
          make.width.mas_equalTo(ScreenW/3-40);
          make.height.mas_equalTo(50);
       } touchUp:^(id sender) {
           
       }];
    self.sexBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0.0);
    
    self.brithBtn = [UIButton zj_buttonWithTitle:@"年龄" titleColor:[UIColor blackColor] norImage:IMAGE(@"生日") selectedImage:nil backColor:[UIColor clearColor] fontSize:14 isBold:NO borderWidth:0 borderColor:0 cornerRadius:0 supView:self.mainView constraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.mainView).offset(0);
               make.left.equalTo(self.sexBtn.mas_right).offset(10);
               make.width.mas_equalTo(ScreenW/3-40);
               make.height.mas_equalTo(50);
          } touchUp:^(id sender) {
              
          }];
    self.brithBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0.0);
    self.nameLabel = [UILabel zj_labelWithFontSize:14 textColor:COLORBLUE superView:self.mainView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameBtn.mas_bottom);
        make.left.equalTo(self.mainView).offset(10);
        make.width.mas_equalTo(ScreenW/3-40);
        make.height.mas_equalTo(50);
    }];
    
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.sexLabel = [UILabel zj_labelWithFontSize:14 textColor:COLORBLUE superView:self.mainView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameBtn.mas_bottom);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.width.mas_equalTo(ScreenW/3-40);
        make.height.mas_equalTo(50);
    }];
    self.sexLabel.textColor = [UIColor blackColor];
    
     self.sexLabel.textAlignment = NSTextAlignmentCenter;
    
    self.brithLabel = [UILabel zj_labelWithFontSize:14 textColor:[UIColor blackColor] superView:self.mainView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameBtn.mas_bottom);
        make.left.equalTo(self.sexLabel.mas_right).offset(10);
        make.width.mas_equalTo(ScreenW/3-10);
        make.height.mas_equalTo(50);
    }];
    self.brithLabel.textColor = [UIColor blackColor];
    
    self.brithLabel.textAlignment = NSTextAlignmentCenter;
}
-(void)setModel
{
    self.nameLabel.text = [WRUserInfo selfInfo].name;
    if ([WRUserInfo selfInfo].sex == 0) {
        self.sexLabel.text = @"男";
    }else{
        
        self.sexLabel.text = @"女";
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    
    NSDate *nowDate = [NSDate date];
    NSString *birthDay2 = [[WRUserInfo selfInfo].birthDay substringToIndex:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];//生日
    NSDate *birthDay = [dateFormatter dateFromString:birthDay2];
    //用来得到详细的时差
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0];
    if([date year] >0){
        NSLog(@"%@",[NSString stringWithFormat:(@"%ld岁%ld月%ld天"),(long)[date year],(long)[date month],(long)[date day]]) ;
        
        
    }
    else if([date month] >0){
        NSLog(@"%@",[NSString stringWithFormat:(@"%ld月%ld天"),(long)[date month],(long)[date day]]);
        
    }
    else if([date day]>0){
        NSLog(@"%@",[NSString stringWithFormat:(@"%ld天"),(long)[date day]]);
         
    }
      else {
        NSLog(@"0天");
         
      }
   self.brithLabel.text =[NSString stringWithFormat:@"%ld岁",(long)[date year]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
