//
//  WRUserDiseaseHistoryCell.h
//  rehab
//
//  Created by Matech on 4/13/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRUserDiseaseHistoryCell : UITableViewCell

@property(nonatomic, readonly) UILabel *titleLabel, *contentLabel;
@property(nonatomic) NSObject *model;

+(CGFloat)heightForText:(NSString*)title text:(NSString*)text tabelView:(UITableView*)tableView;

@end
