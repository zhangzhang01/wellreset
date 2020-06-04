//
//  MeSubSettingController.m
//  rehab
//
//  Created by herson on 6/28/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "MeSubSettingController.h"
#import <YYKit/YYKit.h>
@interface MeSubSettingController ()
{
    NSArray *_titlesArray;
    NSDate *_startDate;
}
@end

@implementation MeSubSettingController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForMeWithType:@"setting" duration:duration];
}

-(instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
         _startDate = [NSDate date];
        _titlesArray = @[NSLocalizedString(@"自动播放背景音乐", nil), NSLocalizedString(@"快速缓解不适不弹出详情", nil)];
        self.tableView.tableHeaderView = [UIView new];
        self.tableView.tableFooterView = [UIView new];
        
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titlesArray.count - 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.accessoryView = nil;
    cell.textLabel.text = _titlesArray[indexPath.row];
    if (indexPath.row <= 1 ) {
        UISwitch *switchControl = [[UISwitch alloc] init];
        [switchControl sizeToFit];
        BOOL flag = ![UserProfile defaultProfile].notAutoPlayBgm;
        if (indexPath.row == 1) {
            flag = [UserProfile defaultProfile].donotShowTreatRehabDetail;
        }
        switchControl.on = flag;
        [switchControl addBlockForControlEvents:UIControlEventValueChanged block:^(id  _Nonnull sender) {
            UISwitch *control = sender;
            if (indexPath.row == 0) {
                [UserProfile defaultProfile].notAutoPlayBgm = !control.on;
            } else {
                [UserProfile defaultProfile].donotShowTreatRehabDetail = control.on;
            }
            
        }];
        cell.accessoryView = switchControl;
    }
    return cell;
}

@end
