//
//  QuestionCell.m
//  rehab
//
//  Created by yefangyang on 2016/11/21.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "QuestionCell.h"
#import <YYKit/YYKit.h>
//#import "QuestionModel.h"

@interface QuestionCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UILabel *newla;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *ba;
@property (nonatomic)UIButton* vouBtn ,*comBtn ,*readBtn;

@end

@implementation QuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        UIView* ba = [UIView new];
        ba.backgroundColor = [UIColor whiteColor];
        ba.layer.cornerRadius = WRCornerRadius;
        ba.layer.masksToBounds =YES;
        ba.layer.borderColor = [UIColor colorWithHexString:@"dcdcdc"].CGColor;
        ba.layer.borderWidth = 1;
        [self.contentView addSubview:ba];
        self.ba= ba;
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.iconImageView = imageView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.numberOfLines = 0;
        nameLabel.font = [UIFont wr_detailFont];
        nameLabel.textColor = [UIColor wr_titleTextColor];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.numberOfLines = 0;
        timeLabel.font = nameLabel.font;
        timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UIView* line = [UIView new];
        line.backgroundColor =[UIColor colorWithHexString:@"EDEDED"];
        [self.contentView addSubview:line];
        self.line = line;
        
        
        UILabel *questionLabel = [[UILabel alloc] init];
        questionLabel.numberOfLines = 0;
        questionLabel.font = [UIFont wr_textFont];
        questionLabel.textColor = [UIColor wr_titleTextColor];
        [self.contentView addSubview:questionLabel];
        self.questionLabel = questionLabel;
        
        UILabel *answerLabel = [[UILabel alloc] init];
        answerLabel.numberOfLines = 0;
        answerLabel.font = [UIFont systemFontOfSize:WRDetailFont];
        answerLabel.textColor = [UIColor colorWithHexString:@"959595"];
        [self.contentView addSubview:answerLabel];
        self.answerLabel = answerLabel;
        
        UIButton* vouBtn = [UIButton new];
        [vouBtn setImage:[UIImage imageNamed:@"有用图标默认状态-1"] forState:0]
        ;
        [vouBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [vouBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        [vouBtn setTitleColor:[UIColor colorWithHexString:@"959595"] forState:0];
        vouBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:vouBtn];
        vouBtn.enabled =NO;
        vouBtn.userInteractionEnabled = NO;
        self.vouBtn = vouBtn;
        
        UIButton* comBtn = [UIButton new];
        [comBtn setImage:[UIImage imageNamed:@"评论"] forState:0]
        ;
        [comBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [comBtn setTitleColor:[UIColor colorWithHexString:@"959595"] forState:0];
        comBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:comBtn];
        comBtn.enabled =NO;
        comBtn.userInteractionEnabled = NO;
        self.comBtn = comBtn;
        
        UIButton* readBtn = [UIButton new];
        [readBtn setImage:[UIImage imageNamed:@"人数"] forState:0]
        ;
        [readBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [readBtn setTitleColor:[UIColor colorWithHexString:@"959595"] forState:0];
        readBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:readBtn];
        readBtn.enabled =NO;
        readBtn.userInteractionEnabled = NO;
        self.readBtn = readBtn;
        
        
        UILabel* new = [UILabel new];
        new.text =  @"• 新的回复";
        new.font = [UIFont systemFontOfSize:13];
        new.textColor = [UIColor redColor];
        [self.contentView addSubview:new];
        self.newla = new;
        
    }
    return self;
}

//- (void)setModel:(QuestionModel *)model
//{
//    _model = model;
//    self.iconImageView.image = [UIImage imageNamed:model.icon];
//    self.nameLabel.text = model.name;
//    self.questionLabel.text = model.question;
//    self.answerLabel.text = model.answer;
//}

- (void)setModel:(WRExpertReply *)model
{
    _model = model;
    [self.iconImageView setImageWithUrlString:model.headImage holder:@"well_default_head"];
    if ([Utility IsEmptyString:model.userName]) {
        model.userName = NSLocalizedString(@"WELL健康用户", nil);
    }
    NSString *str =  [model.userName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (str.length<1) {
        str = @"匿名用户";
    }
    self.nameLabel.text =str;
    
   
    self.questionLabel.text = [@"提问:" stringByAppendingString:model.question] ;
    NSString *content = model.content;
//    self.answerLabel.textColor = [UIColor darkGrayColor];
    if (model.state == WRExpertReplyStateWaiting) {
        content = NSLocalizedString(@"等待专家回复", nil);
        self.answerLabel.textColor = [UIColor orangeColor];
    }
    else if([Utility IsEmptyString:content])
    {
        content = NSLocalizedString(@"没有内容", nil);
    }
    self.answerLabel.text =@"";
    self.timeLabel.text =  model.operTime;
//    UIFont *font = self.vouBtn.titleLabel.font;
//    CGSize size = CGSizeMake(MAXFLOAT, 13.0f);
//    CGSize buttonSize = [content boundingRectWithSize:size
//                                              options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                           attributes:@{ NSFontAttributeName:font}
//                                              context:nil].size;
 
    [self.vouBtn setTitle:[NSString stringWithFormat:@"%ld人觉得有用",model.upvote ] forState:0];
    [self.comBtn setTitle:[NSString stringWithFormat:@"%ld",model.commentCount ] forState:0];
    [self.readBtn setTitle:[NSString stringWithFormat:@"%ld",model.readCount ] forState:0];
    self.newla.hidden = !model.newreply;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.iconImageView.frame = self.model.iconFrame;
    self.nameLabel.frame = self.model.nameFrame;
    self.timeLabel.frame = self.model.timeFrame;
    self.questionLabel.frame = self.model.questionFrame;
    self.answerLabel.frame = self.model.answerFrame;
    self.line.frame = CGRectMake(12+WRUIDiffautOffset, self.iconImageView.bottom+WRUIOffset, self.width-12*2-WRUIDiffautOffset*2, 1);
    self.ba.frame = CGRectMake(12, 12, self.width-24, self.height-12);
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.width/2;
    
    
    self.vouBtn.x = self.questionLabel.x;
    self.vouBtn.y = self.questionLabel.bottom+15;
    [self.vouBtn sizeToFit];
    
    [self.readBtn sizeToFit];
    self.readBtn.y = self.vouBtn.y;
    self.readBtn.right = self.questionLabel.right;
    
    [self.comBtn sizeToFit];
    self.comBtn.y = self.vouBtn.y;
    self.comBtn.right = self.readBtn.left-17;
    
    [self.newla sizeToFit];
    self.newla.right = self.questionLabel.right;
    self.newla.centerY = self.nameLabel.centerY;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
