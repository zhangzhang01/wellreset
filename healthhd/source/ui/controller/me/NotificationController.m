//
//  NotificationController.m
//  rehab
//
//  Created by Matech on 3/2/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "NotificationController.h"
#import "WRViewModel.h"

@interface NotificationController ()
{
    BOOL _flag;
}
@end

@implementation NotificationController

-(void)dealloc{
    if (_flag != [WRUserInfo selfInfo].notificationFlag) {
        BOOL flag = _flag;
        [WRViewModel operationWithType:WROperationTypeNotification indexId:@"" flag:_flag contentType:@"" completion:^(NSError * _Nonnull error) {
            if (!error) {
                [WRUserInfo selfInfo].notificationFlag = flag;
                [[WRUserInfo selfInfo] save];
            }
        }];
    }
}

- (instancetype)init {
    if(self = [super initWithStyle:UITableViewStylePlain]){
        _flag = [WRUserInfo selfInfo].notificationFlag;
        
        self.tableView.tableHeaderView = [[UIView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    
    [self defaultStyle];
    // Do any additional setup after loading the view.
    [WRNetworkService pwiki:@"消息通知设置"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate&Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor grayColor];
        UISwitch *control = [[UISwitch alloc] init];
        control.on = _flag;
        [control sizeToFit];
        [control addTarget:self action:@selector(onValueChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = control;
    }
    cell.textLabel.text = NSLocalizedString(@"向我推送最新康复资讯", nil);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - IBActions
-(IBAction)onValueChange:(UISwitch*)sender {
    _flag = sender.on;
}
@end
