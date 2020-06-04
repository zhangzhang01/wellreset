//
//  AlarmController.m
//  rehab
//
//  Created by Matech on 4/7/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "AlarmController.h"
#import "ActionSheetDatePicker.h"
#import "ShareUserData.h"
#import "GuideView.h"
#import <UserNotifications/UserNotifications.h>
#import <YYKit/YYKit.h>
const NSUInteger MaxAlarmCount = 4;

@interface AlarmController()
{
    NSMutableArray *_alarmTimeArray;
}
@property(nonatomic) NSInteger alarmCount;

@end

@implementation AlarmController

-(void)dealloc
{
    //    [UMengUtils careForAlarmWithCount:_alarmTimeArray.count];
}

-(instancetype)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
        _alarmTimeArray = [NSMutableArray array];
        
        [self defaultStyle];
        self.tableView.rowHeight = 80;
        
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onClickedAddItem:)];
        self.navigationItem.rightBarButtonItem = addItem;
        
        [_alarmTimeArray addObjectsFromArray:[ShareUserData userData].alarmArray];
        self.alarmCount = _alarmTimeArray.count;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *key = @"FirstAlarm";
        NSString *hasExercise = [ud objectForKey:key];
        if (!hasExercise) {
            NSArray* guideTitles = @[NSLocalizedString(@"还没有设置提醒呢！\n点击右上角的“+”添加您的第一个提醒\n定时锻炼，有助康复哦！", nil)];
            GuideView *guide = [GuideView new];
            NSMutableArray *array = [NSMutableArray array];
            CGRect barFrame = CGRectMake(self.view.width - 45 , 16, 40, 30);
            CGRect frame = [Utility resizeRect:barFrame cx:40 height:30];
            frame = CGRectOffset(frame, 0, 10);
            [array addObject:[NSValue valueWithCGRect:frame]];
            UIView *view = [[self class] root].view;
            [guide showInView:view maskFrames:array labels:guideTitles];
            [ud setObject:@"YES" forKey:key];
        }
        
        
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    self.title = NSLocalizedString(@"提醒", nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"alarmArray%@",[ShareUserData userData].alarmArray);
    //    UINavigationBar *bar = self.navigationController.navigationBar;
    //    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
    //    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //    bar.barTintColor = [UIColor whiteColor];
    //    bar.tintColor = bar.barTintColor;
    //    [bar setShadowImage:[UIImage new]];
}

#pragma mark - UITableView Delegate&Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _alarmTimeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont wr_bigFont];
        cell.textLabel.textColor = [UIColor blackColor];
        UIImage *image = [UIImage imageNamed:@"icon_clock"];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        cell.accessoryView = imageView;
        //        cell.imageView.image = [UIImage imageNamed:@"icon_clock"];
    }
    NSUInteger index = indexPath.row;
    cell.textLabel.text = _alarmTimeArray[index];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        NSString *datesS = [ShareUserData userData].alarmArray[indexPath.row];
        [_alarmTimeArray removeObjectAtIndex:indexPath.row];
        [[ShareUserData userData].alarmArray removeObjectAtIndex:indexPath.row];
        [[ShareUserData userData] save];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
            [self delegateWithTime:datesS];
            NSLog(@"alarmArray.count%lu",(unsigned long)[ShareUserData userData].alarmArray.count);
        } else {
            [self save];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        self.alarmCount = [ShareUserData userData].alarmArray.count;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - control event
- (IBAction)onClickedAddItem:(UIBarButtonItem *)sender
{
    __weak __typeof(self)weakself = self;
    [ActionSheetDatePicker showPickerWithTitle:NSLocalizedString(@"选择时间", nil) datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        NSString *dateS = [formatter stringFromDate:selectedDate];
        if (_alarmTimeArray.count > 0) {
            for (NSString *string in _alarmTimeArray) {
                if ([string isEqualToString:dateS]) {
                    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"已有相同提醒", nil)];
                    return ;
                }
            }
        }
        [UMengUtils careForAlarmAdd:dateS];
        [_alarmTimeArray addObject:dateS];
        [[ShareUserData userData].alarmArray addObject:dateS];
        [[ShareUserData userData] save];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
            [self saveWithTime:dateS];
            
        } else {
            [self save];
        }
        [weakself.tableView reloadData];
        weakself.alarmCount = _alarmTimeArray.count;
        
    } cancelBlock:^(ActionSheetDatePicker *picker) {
    } origin:self.navigationController.view];
}

#pragma mark -
-(void)setAlarmCount:(NSInteger)alarmCount {
    _alarmCount = alarmCount;
    if (alarmCount == 0) {
        if (!self.tableView.backgroundView) {
            self.tableView.backgroundView = [WRUIConfig createNoDataViewWithFrame:self.tableView.bounds title:NSLocalizedString(@"没有提醒", nil) image:[UIImage imageNamed:@"well_logo"]];
        }
        self.tableView.backgroundView.hidden = NO;
    } else {
        self.tableView.backgroundView.hidden = YES;
    }
}

-(NSString*)localTimeDesc:(NSString*)timeString {
    return timeString;
    //NSDate *date = [NSDate dateWithString:timeString format:@"HH:mm"];
    //return [date descriptionWithLocale:nil];
}

-(void)save {
    // 试图取消以前的通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    for(NSString *time in _alarmTimeArray) {
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
        
        int temp = 0;
        int days = 0;
        NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
        int hour = [[[time componentsSeparatedByString:@"-" ] firstObject] intValue];
        
        int minute = [[[time componentsSeparatedByString:@"-" ] lastObject] intValue];
        
        NSDateComponents *comps = [[NSDateComponents alloc] init] ;
        
        
        NSInteger unitFlags = NSEraCalendarUnit |
        NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSHourCalendarUnit |
        NSMinuteCalendarUnit |
        NSSecondCalendarUnit |
        NSWeekCalendarUnit |
        NSWeekdayCalendarUnit |
        NSWeekdayOrdinalCalendarUnit |
        NSQuarterCalendarUnit;
        
        comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
        [comps setHour:hour];
        [comps setMinute:minute];
        [comps setSecond:0];

        
        temp = 1 - components.weekday;
        days = (temp >= 0 ? temp : temp + 7);
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
        
        notification.fireDate = newFireDate;
        
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitWeek;
        
        
        //notification.applicationIconBadgeNumber = MAX((self.alarmCount - index - 1), 0);
        // 提示时的显示信息
        notification.alertBody = NSLocalizedString(@"WELL健康提醒您:要开始做康复运动了", nil);
        // 下面属性仅在提示框状态时的有效，在横幅时没什么效果
        notification.hasAction = NO;
        notification.alertAction = @"open";
        notification.userInfo = nil;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

//使用 UNNotification 本地通知
- (void)saveWithTime:(NSString *)time {
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    //    [center removeAllDeliveredNotifications];
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"WELL健康提醒您:要开始做康复运动了"
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    // 在 alertTime 后推送本地推送
    //    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
    //                                                  triggerWithTimeInterval:20 repeats:NO];
    
    NSArray *array = [time componentsSeparatedByString:@":"];
    NSLog(@"%@",array[1]);
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = [array[0] integerValue];
    components.minute = [array[1] integerValue];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:time content:content trigger:trigger];
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
        //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        //            [alert addAction:cancelAction];
        //            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)delegateWithTime:(NSString *)time
{
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:@[time]];
}
@end
