//
//  WRProQuestionView.m
//  rehab
//
//  Created by Matech on 3/15/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRProQuestionView.h"
#import "DLRadioButton.h"
#import "RadioButton.h"
#import "WRProTreat.h"

@interface WRProQuestionView()
@property(nonatomic, weak) WRProTreatQuestion *question;
@property(nonatomic, weak) WRProTreatAnswer *anwser;
@end

@implementation WRProQuestionView
-(instancetype)initWithFrame:(CGRect)frame question:(id)question index:(NSUInteger)index {
    if (self = [super initWithFrame:frame]) {
        self.question = question;
        WRProTreatQuestion *object = question;
        CGFloat offset = WRUIOffset,  x = offset, y = x, cx = frame.size.width - 2*x, cy = frame.size.height;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.text = [NSString stringWithFormat:@"%d.%@", (int)(index + 1), self.question.question];
        label.numberOfLines = 0;
        [label sizeToFit];
        [self addSubview:label];
        y = CGRectGetMaxY(label.frame) + offset;
        
        NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:3];
        NSUInteger index = 0;
        for (WRProTreatAnswer *anwser in object.answers) {
            /*
            RadioButton* btn = [[RadioButton alloc] initWithFrame:CGRectMake(x, y, cx, 30)];
            [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
            btn.tag = index++;
            //[btn setTitle:anwser.answer forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            [btn setImage:[UIImage imageNamed:@"well_radio"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"well_radio_focus"] forState:UIControlStateSelected];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
            [self addSubview:btn];
            [buttons addObject:btn];
            [btn sizeToFit];
            
            CGFloat x0 = CGRectGetMaxX(btn.frame) + offset;
            label = [[UILabel alloc] initWithFrame:CGRectMake(x0, y, frame.size.width - offset - x0, 0)];
            label.text = anwser.answer;
            label.textColor = [UIColor grayColor];
            //label.font = [UIFont wr_detailFont];
            label.numberOfLines = 0;
            [label sizeToFit];
            if (label.size.height > btn.frame.size.height) {
                //btn.frame = [Utility moveRect:btn.frame x:-1 y:(CGRectGetMidY(label.frame) - btn.frame.size.height/2)];
            } else {
                label.frame = [Utility moveRect:label.frame x:-1 y:CGRectGetMidY(btn.frame) - label.frame.size.height/2];
            }
            [self addSubview:label];
            */
            DLRadioButton *btn = [[DLRadioButton alloc] initWithFrame:CGRectMake(x, y, cx, 30)];
            btn.titleLabel.font = [UIFont wr_textFont];
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            [btn setTitle:anwser.answer forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.iconColor = [UIColor grayColor];
            btn.indicatorColor = [UIColor grayColor];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn addTarget:self action:@selector(logSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
            [btn sizeToFit];
            //btn.backgroundColor = [UIColor blueColor];
            btn.tag = index;
            [self addSubview:btn];
            [buttons addObject:btn];
            index++;
            y = MAX(CGRectGetMaxY(btn.frame), CGRectGetMaxY(label.frame)) + WRUIBigOffset;
        }
        if(buttons.count > 0) {
            DLRadioButton *radio = buttons.firstObject;
            [buttons removeObjectAtIndex:0];
            radio.otherButtons = buttons;
        }
        
        /*
        if(buttons.count > 0) {
            [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
            //[buttons[0] setSelected:YES]; // Making the first button initially selected
        }
         */
    }
    return self;
}

-(IBAction)onRadioButtonValueChanged:(RadioButton*)sender {
    if(sender.selected) {
        self.anwser = self.question.answers[sender.tag];
    }
}

-(id)getUserAnwser {
    return self.anwser;
}

-(IBAction)logSelectedButton:(UIButton*)sender {
    if(sender.selected) {
        self.anwser = self.question.answers[sender.tag];
    }
}

@end
