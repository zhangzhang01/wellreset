//
//  AlarmController.m
//  rehab
//
//  Created by Matech on 4/7/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "AlarmController.h"

const NSUInteger MaxAlarmCount = 4;

@interface AlarmController()
{
    BOOL _hasAlarm;
    NSInteger _alarmCount;
    
    NSArray *_alarmTimeArray;
}
@property(nonatomic) NSInteger alarmCount;
@end

@implementation AlarmController

//-(void)dealloc
//{
//    NSInteger alarmCount = 0;
//    if (_hasAlarm)
//    {
//        alarmCount = self.alarmCount;
//        [UMengUtils careForAlarmWithCount:alarmCount];
//    }
//    else
//    {
//        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    }
//    [[NSUserDefaults standardUserDefaults] setInteger:alarmCount forKey:@"alarmCount"];
//    [self save];
//}

-(instancetype)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _hasAlarm = NO;
        _alarmTimeArray = @[@[@"10:00"], @[@"10:00", @"20:00"], @[@"10:00", @"15:00", @"20:00"], @[@"10:00", @"13:00", @"16:00", @"20:00"]];
        self.alarmCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"alarmCount"];
        _hasAlarm = self.alarmCount > 0;
        [self defaultStyle];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSInteger alarmCount = 0;
    if (_hasAlarm)
    {
        alarmCount = self.alarmCount;
        [UMengUtils careForAlarmWithCount:alarmCount];
    }
    else
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:alarmCount forKey:@"alarmCount"];
    [self save];
}

#pragma mark - UITableView Delegate&Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    if (_hasAlarm && _alarmCount > 0) {
        count++;
    }
    return count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case 0:
        {
            count = 1;
            if(_hasAlarm)
            {
                count += MaxAlarmCount;
            }
            break;
        }
            
        case 1:
        {
            count = _alarmCount;
            break;
        }
            
        default:
            break;
    }
    return count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *array = @[NSLocalizedString(@"提醒设置", nil), NSLocalizedString(@"时间设定", nil)];
    return array[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [WRUIConfig defaultLabelHeight] + WRUIOffset;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [WRUIConfig tableView:tableView createCustomSectionHeaderViewWithText:[self tableView:tableView titleForHeaderInSection:section] headerHeight:[self tableView:tableView heightForHeaderInSection:section]];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont wr_textFont];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    NSUInteger index = indexPath.row;
    if (indexPath.section == 0) {
        if (index == 0) {
            cell.textLabel.text = NSLocalizedString(@"康复提醒", nil);
            UISwitch *control = [[UISwitch alloc] init];
            control.on = _hasAlarm;
            [control sizeToFit];
            [control addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = control;
        }
        else{
            cell.textLabel.text = [NSString stringWithFormat:@"%d%@", (int)index, NSLocalizedString(@"个提醒", nil)];
            cell.accessoryType = (index == self.alarmCount)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
        }
    } else if(indexPath.section == 1) {
        NSArray *array = [_alarmTimeArray objectAtIndex:(self.alarmCount - 1)];
        cell.textLabel.text = [self localTimeDesc:array[index]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row > 0) {
            self.alarmCount = indexPath.row;
        }
    }
}

#pragma mark - IBactions
-(IBAction)onValueChanged:(UISwitch*)sender {
    _hasAlarm = sender.on;
    if (sender.on) {
        self.alarmCount = _alarmCount;
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark -
-(void)setAlarmCount:(NSInteger)alarmCount {
    _alarmCount = alarmCount;
    [[NSUserDefaults standardUserDefaults] setInteger:alarmCount forKey:@"alarmCount"];
    [self.tableView reloadData];
}

-(NSString*)localTimeDesc:(NSString*)timeString {
    return timeString;
    //NSDate *date = [NSDate dateWithString:timeString format:@"HH:mm"];
    //return [date descriptionWithLocale:nil];
}

-(void)save {
    //NSUInteger badgeNumber = 0;
    // 试图取消以前的通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if (_hasAlarm && self.alarmCount > 0) {
        //badgeNumber = self.alarmCount;
        NSArray *array = [_alarmTimeArray objectAtIndex:(self.alarmCount - 1)];
        for(NSString *time in array) {
            // 设置新的通知
            UILocalNotification* notification = [[UILocalNotification alloc] init];
            
            NSDate *date = [NSDate date];
            NSString *dateString = [NSString stringWithFormat:@"%04d-%02d-%02d %@:00", (int)date.year, (int)date.month, (int)date.day, time];
            //NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            //[dateFormatter setTimeZone:GTMzone];
            date = [dateFormatter dateFromString:dateString];
            
            // 设置响应时间
            notification.fireDate = date;
            // 设置时区，默认即可
            notification.timeZone = [NSTimeZone defaultTimeZone];
            
            // 重复提醒，这里设置一分钟提醒一次，只有启动应用，才会停止提醒。
            notification.repeatInterval = NSCalendarUnitDay;
            //notification.applicationIconBadgeNumber = MAX((self.alarmCount - index - 1), 0);
            // 提示时的显示信息
            notification.alertBody = NSLocalizedString(@"WELL提醒您:要开始做康复运动了", nil);
            // 下面属性仅在提示框状态时的有效，在横幅时没什么效果
            notification.hasAction = NO;
            notification.alertAction = @"open";
            notification.userInfo = nil;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        //[UIApplication sharedApplication].applicationIconBadgeNumber = self.alarmCount;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    //[UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
}

@end
