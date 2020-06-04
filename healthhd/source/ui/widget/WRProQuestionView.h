//
//  WRProQuestionView.h
//  rehab
//
//  Created by Matech on 3/15/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRView.h"

@interface WRProQuestionView : UIView

-(instancetype)initWithFrame:(CGRect)frame question:(id)question index:(NSUInteger)index;

-(id)getUserAnwser;

@end
