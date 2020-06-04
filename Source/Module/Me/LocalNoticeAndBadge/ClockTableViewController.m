//
//  ClockTableViewController.m
//  CBayelProjectManage
//
//  Created by gcf on 16/6/23.
//  Copyright © 2016年 CBayel. All rights reserved.
//

#import "ClockTableViewController.h"

@interface ClockTableViewController ()<CZPickerViewDataSource, CZPickerViewDelegate>
//列表Arr
@property(strong,nonatomic)NSArray *array;
//时间picker
@property(strong,nonatomic)UIDatePicker *clockDatePicker;
//重复picker
@property(strong,nonatomic) NSArray *weeks;
@property(strong,nonatomic) NSArray *weeksImages;
@property(strong,nonatomic) CZPickerView *pickerWithImage;
//时间选择Arr
@property(strong,nonatomic)NSMutableArray *weeksArr;

//当前闹钟
//@property(strong,nonatomic)LocalNoticeModel *noticeModel;

//选中时间
@property(strong,nonatomic)NSDate *selectedDate;


@end
static NSString *const clockCellID=@"clockCellID";
//static id _instace;
@implementation ClockTableViewController
/*
#pragma mark -----Login单例-----
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+(instancetype)shareClockTableViewController{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc]init];
    });
    return _instace;
}

-(id)copyWithZone:(NSZone *)zone{
    return _instace;
}
*/

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self=[super initWithStyle:style]) {
        self.navigationItem.title = @"通知";
        self.array=@[@"时间",@"重复"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
        self.weeks = @[@"周一", @"周二", @"周三", @"周四", @"周五",@"周六",@"周日"];
        
    }
    return self;
}


-(void)saveAction{
    /*
    // 先取消之前的推送
    [ClockTableViewController cancelLocalNotificationWithKey:@"notification"];
    
    DLog(@"====%@",self.timeStr);
    [kUserDefault setBool:YES forKey:@"alarm"];
    // 设置本地通知
    [ClockTableViewController registerLocalNotification:self.timeStr];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
     */
    [self setRemindTime];
    [self saveLocalNoticeModel];
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  本地化闹钟
 */
-(void)saveLocalNoticeModel{
    LocalNoticeModelDBTool *noticeDBTool = [LocalNoticeModelDBTool shareInstance];
    [noticeDBTool createTable];
    NSString *jsonStr = @"";
    if (self.weeksArr != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.weeksArr options:NSJSONWritingPrettyPrinted error:nil];
        jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    if (self.noticeId != nil) {
        NSString *selectedDateStr = [NSString stringWithFormat:@"%f",[self.selectedDate timeIntervalSince1970]];
        [noticeDBTool updateModelWithkey:@"nTime" value:selectedDateStr nId:self.noticeId];
        [noticeDBTool updateModelWithkey:@"nWeek" value:jsonStr nId:self.noticeId];
        [noticeDBTool updateModelWithkey:@"nIsOpen" value:@"1" nId:self.noticeId];
    }
    else
    {
        if(self.selectedDate == nil)
        {
            self.selectedDate = [NSDate date];
        }
        NSDictionary *noticeDic = @{@"noticeTime":self.selectedDate,@"noticeWeek":jsonStr,@"isOpen":@"1"};
        LocalNoticeModel *noticeModel =[[LocalNoticeModel alloc]initWithDictionary:noticeDic];
        [noticeDBTool insertModel:noticeModel];
    }
}


#pragma mark本地通知方法
// 注册本地通知
- (void)scheduleNotificationWithItem:(NSString *)alertItem fireDate:(NSDate*)date
{
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //初始化
    UILocalNotification *locationNotification = [[UILocalNotification alloc]init];
    locationNotification.fireDate =date;
    //NSLog(@"推送时间%@",locationNotification.fireDate);
    locationNotification.timeZone = [NSTimeZone defaultTimeZone];
    //设置重复周期
    locationNotification.repeatInterval = kCFCalendarUnitWeek;
    //设置通知的音乐
    locationNotification.soundName = UILocalNotificationDefaultSoundName;
    //设置通知内容
    locationNotification.alertBody = alertItem;
    if (!self.selectedDate) {
        self.selectedDate = [NSDate date];
    }
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 这里是用大写的 H
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString * str = [dateFormatter stringFromDate:self.selectedDate];
    
    locationNotification.userInfo = @{@"id":str};
    //执行本地推送
    [[UIApplication sharedApplication] scheduleLocalNotification:locationNotification];
}

// 取消通知：
// 通知完一定要取消，IOS最多允许最近本地通知数量是64个，超过限制的本地通知将被忽略。
// 删除应用所有通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key
{
    // 从当前的app中找出所有的本地通知.
    NSArray * notificationArrray = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification * not in notificationArrray) {
        if ([not.userInfo valueForKey:key]) {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
    }
}

-(void)setRemindTime
{
    if (self.noticeModel) {
        NSArray * notificationArrray = [UIApplication sharedApplication].scheduledLocalNotifications;
        for (UILocalNotification * not in notificationArrray) {
            if ([[not.userInfo valueForKey:@"id"]isEqualToString:_noticeModel.noticeTime]) {
                [[UIApplication sharedApplication] cancelLocalNotification:not];
            }
        }
  
    }
    
    //取得系统的时间，并将其一个个赋值给变量
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSWeekCalendarUnit| NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:unitFlags fromDate:now];
    
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    comps2 = [calendar components:unitFlags fromDate:now];
    
    //    int hour = [comps hour];
    //    int min = [comps minute];
    //    int sec = [comps second];
    
    int i = 0;
    for (int newWeekDay =2; newWeekDay<=8; newWeekDay++) {
        
        int temp = 0;
        int days = 0;
        
        temp = newWeekDay - comps.weekday;
        days = (temp >= 0 ? temp : temp + 7);
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 这里是用大写的 H
        [dateFormatter setDateFormat:@"HH:mm"];
        
        NSString * str = [dateFormatter stringFromDate:self.selectedDate];
        [comps setHour:[[str componentsSeparatedByString:@":"][0] intValue]];
        [comps setMinute:[[str componentsSeparatedByString:@":"][1] intValue]];
        [comps setSecond:0];
        
        
        
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
        
        if (self.weeksArr.count == 0 && i==0) {
            newFireDate = self.selectedDate;
            [self scheduleNotificationWithItem:[NSString stringWithFormat:@"WELL健康提醒您:要开始做康复运动了"] fireDate:newFireDate];
            i++;
        }
        else if(self.weeksArr.count>0 )
        {
            if (([self.weeksArr[i]isEqualToString:@"周一"]  && newWeekDay==2)||([self.weeksArr[i]isEqualToString:@"周二"]  && newWeekDay==3)||([self.weeksArr[i]isEqualToString:@"周三"]  && newWeekDay==4)||([self.weeksArr[i]isEqualToString:@"周四"]  && newWeekDay==5)||([self.weeksArr[i]isEqualToString:@"周五"]  && newWeekDay==6)||([self.weeksArr[i]isEqualToString:@"周六"]  && newWeekDay==7)||([self.weeksArr[i]isEqualToString:@"周日"]  && newWeekDay==8)) {
                [self scheduleNotificationWithItem:[NSString stringWithFormat:@"WELL健康提醒您:要开始做康复运动了"] fireDate:newFireDate];
                if (i==self.weeksArr.count-1) {
                    return;
                }
            }
            
            
        }
        
        
    }
    
}




- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
               attributedTitleForRow:(NSInteger)row{
    
    NSAttributedString *att = [[NSAttributedString alloc]
                               initWithString:self.weeks[row]
                               attributes:@{
                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:18.0]
                                            }];
    return att;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    return self.weeks[row];
}



- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return self.weeks.count;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
//    DLog(@"%@ is chosen!", self.weeks[row]);
}

-(void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows{
    self.weeksArr = [[NSMutableArray alloc]initWithCapacity:self.weeks.count];
    for(NSNumber *n in rows){
        NSInteger row = [n integerValue];
//        DLog(@"%@ is chosen!", self.weeks[row]);
        //加载所选重复时间
        [self.weeksArr addObject:self.weeks[row]];
    }
//    DLog(@"%@",self.weeksArr);
    //重新加载
    [self.tableView reloadData];
}

- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
//    DLog(@"Canceled.");
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    //注册cell
    
    [self.tableView registerClass:[ClockTableViewCell class] forCellReuseIdentifier:clockCellID];
    if (self.noticeId != nil) {
        LocalNoticeModelDBTool *noticeDBTool = [LocalNoticeModelDBTool shareInstance];
        self.noticeModel = [noticeDBTool selectLocalNoticeModelWithNoticeId:self.noticeId];
        
        NSInteger num = [self.noticeModel.noticeTime integerValue];
        self.selectedDate = [NSDate dateWithTimeIntervalSince1970:num];
        self.weeksArr = [self.noticeModel.noticeWeek objectFromJSONString];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.clockDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 160)];
    if (self.selectedDate == nil) {
        self.clockDatePicker.date = [NSDate date];
    }
    else
    {
        self.clockDatePicker.date = self.selectedDate;
    }
    self.clockDatePicker.datePickerMode = UIDatePickerModeTime;
    [self.clockDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    return self.clockDatePicker;
}

-(void)datePickerValueChanged:(id)sender
{
    self.selectedDate = [self.clockDatePicker date];
//    DLog(@"date: %@", self.selectedDate);
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:clockCellID forIndexPath:indexPath];
    
    // Configure the cell...
    cell.titleLabel.text = self.array[indexPath.row];
    
    if (indexPath.row == 0) {

        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 这里是用大写的 H
        [dateFormatter setDateFormat:@"HH:mm"];
        if (self.selectedDate == nil) {
            cell.detailLabel.text = [dateFormatter stringFromDate:[NSDate date]];
        }
        else
        {
            cell.detailLabel.text = [dateFormatter stringFromDate:self.selectedDate];
        }
        
    }
    else if (indexPath.row == 1) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSUInteger totalCount = self.weeksArr.count;
        switch (totalCount) {
            case 0:
            {
                cell.detailLabel.text = @"永不";
                break;
            }
            case 2:
            {
                int weeksDayCount = 0;
                NSMutableString *weeksStr = [[NSMutableString alloc]initWithString:@""];
                for (NSString *str in self.weeksArr) {
                    if ([str isEqualToString:@"周六"] || [str isEqualToString:@"周日"]) {
                        weeksDayCount ++;
                    }
                    [weeksStr appendFormat:@" %@",str];
                }
                if (weeksDayCount == 2) {
                    cell.detailLabel.text = @"周末";
                }
                else
                {
                    cell.detailLabel.text = weeksStr;
                }
                break;
            }
            case 5:
            {
                int weeksDayCount = 0;
                NSMutableString *weeksStr = [[NSMutableString alloc]initWithString:@""];
                for (NSString *str in self.weeksArr) {
                    if (![str isEqualToString:@"周六"] && ![str isEqualToString:@"周日"]) {
                        weeksDayCount ++;
                    }
                    [weeksStr appendFormat:@" %@",str];
                }
                if (weeksDayCount == 5) {
                    cell.detailLabel.text = @"工作日";
                }
                else
                {
                    cell.detailLabel.text = weeksStr;
                }
                break;
            }
            case 7:
            {
                cell.detailLabel.text = @"每天";
                break;
            }
            default:
            {
                NSMutableString *weeksStr = [[NSMutableString alloc]initWithString:@""];
                for (NSString *str in self.weeksArr) {
                    [weeksStr appendFormat:@" %@",str];
                }
                cell.detailLabel.text = weeksStr;
                break;
            }
        }
        
    }
    return cell;
}

//将时间字符串转换为HH：mm
-(NSString *)getTimeStrWithNoticeTime:(NSString *)noticeTime{
    NSInteger num = [noticeTime integerValue];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 这里是用大写的 H
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:num];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        //重复
        CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"重复设置" cancelButtonTitle:@"取消" confirmButtonTitle:@"确认"];
        picker.delegate = self;
        picker.dataSource = self;
        picker.allowMultipleSelection = YES;
        [picker show];
        
    }
    else
    {
        
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
