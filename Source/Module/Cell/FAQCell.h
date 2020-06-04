//
//  FAQCell.h
//  rehab
//
//  Created by Matech on 3/23/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRObject.h"

@interface FAQCell : UITableViewCell

@property(nonatomic, weak) UILabel *titleLabel, *contentLabel, *leftLabel;
-(void)setContent:(WRFAQ*)object;

@end
