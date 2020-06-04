//
//  UserBasicInfoController.m
//  rehab
//
//  Created by Matech on 3/3/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "JCAlertView.h"
#import "WRCitySelectorView.h"
#import "WRSheetView.h"
#import "UserBasicInfoController.h"
#import "WRUserInfo.h"

#import "WRUserDiseaseHistoryCell.h"
#import "SelfCommonDiseaseCell.h"
#import "SelfDiseasePhotoCell.h"
#import "WRSelfInfoPanelView.h"

#import "SDPhotoBrowser.h"
#import "ActionSheetDatePicker.h"
#import "ShareUserData.h"
#import "ActionSheetStringPicker.h"
#import "WRImagePicker.h"

#import "DiseaseSelectorController.h"
#import "LevelController.h"

#import "WRViewModel+Common.h"

#import "UserViewModel.h"
#import "UserdaliyViewModel.h"
#import <YYKit/YYKit.h>
const NSUInteger MaxHeight = 250;
const NSUInteger MinHeight = 100;
const NSUInteger MaxWeight = 150;
const NSUInteger MinWeight = 20;
const NSUInteger MinAge = 10;
const NSUInteger MaxAge = 80;
const NSUInteger DefaultAge = 30;

typedef NS_ENUM(NSInteger, MyInfoTag) {
    TagNickName,
    TagSex,
    TagBirthDay,
    TagCity,
    TagHeight,
    TagWeight,
    TagBMI,
    TagHistory,
};

@interface UserBasicInfoController ()<UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, SDPhotoBrowserDelegate>
{
    NSArray *_itemArray;
    
    NSInteger _tempValue;
    NSDate *_startDate;
    BOOL _isUserHead;
    CGSize _currentImageSize;
    
    WRImagePicker *_imagePicker;
}
@property(nonatomic)WRUserInfo *userInfo;
@property (nonatomic, strong) WRSelfInfoPanelView *headImageView;
@property UserdaliyViewModel* viewModel;
@end

@implementation UserBasicInfoController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForMeWithType:@"basic" duration:duration];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if(self = [super initWithStyle:UITableViewStyleGrouped]){
        _startDate = [NSDate date];
        NSDictionary *dic = [[WRUserInfo selfInfo] convertDictionary];
        _userInfo = [[WRUserInfo alloc] initWithDictionary:dic];
        
        _itemArray = @[
                       @[                       NSLocalizedString(@"等级", nil)],
                       @[                       NSLocalizedString(@"昵称", nil),
                                                NSLocalizedString(@"性别", nil),
                                                NSLocalizedString(@"出生日期", nil)],
                       
                       @[                       NSLocalizedString(@"所在城市", nil)],
                       
                       @[                       NSLocalizedString(@"身高", nil),
                                                NSLocalizedString(@"体重", nil),
                                                NSLocalizedString(@"体质指数", nil),]
                       
                       //NSLocalizedString(@"病史", nil)
                       ];
        UIImage *image = [WRUIConfig defaultHeadImage];
        CGFloat cx = self.tableView.width;
        CGFloat cy = image.size.height + 80;
        WRSelfInfoPanelView *headerView = [[WRSelfInfoPanelView alloc] initWithFrame:CGRectMake(0, 0, cx, cy) isSimple:YES];
        headerView.logOffButton.hidden = YES;
        headerView.nameLabel.hidden = YES;
        headerView.backgroundColor = [UIColor wr_lightGray];
        self.headImageView = headerView;
        [self.headImageView update];
        
        self.tableView.tableHeaderView = headerView;
        self.tableView.showsVerticalScrollIndicator = NO;
        
        [self createFooterView:self.tableView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadTapped:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [headerView.headImageView addGestureRecognizer:singleTap];
        [headerView.headImageView setUserInteractionEnabled:YES];
        [self updateSelfInfo];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateExperise) name:WRUpdateExperise object:nil];
        
//        [self updateExperise];
       
    }
    return self;
}

//刷新经验值
- (void)updateExperise
{
    [SVProgressHUD showWithStatus:nil];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    
    
    [SVProgressHUD dismiss];
self.headImageView.progressView.progress = (float)self.viewModel.myDaliy.currentXP/self.viewModel.myDaliy.nextlevelXP;
self.headImageView.experiseLabel.text = [NSString stringWithFormat:@"%d/%d",(int)self.viewModel.myDaliy.currentXP,(int)self.viewModel.myDaliy.nextlevelXP];
self.headImageView.levellabal.text = [NSString stringWithFormat:@"Lv%d",(int)self.viewModel.myDaliy.currenLevel];
                
            
   
}
-(void)viewWillDisappear:(BOOL)animated
{
  //  [self onClickedSubmitButton:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    [self createBackBarButtonItem];
    _viewModel = [UserdaliyViewModel new];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onClickedSubmitButton:)];
    [WRNetworkService pwiki:@"个人资料"];
    UIButton* right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30+4, 15)];
    [right setTitle:@"完成" forState:0];
    [right setTitleColor:[UIColor wr_rehabBlueColor] forState:0];
    [right bk_whenTapped:^{
        [self onClickedSubmitButton:nil];
    }];
    right.titleLabel.font = [UIFont systemFontOfSize:WRTitleFont];
    UIBarButtonItem* item  = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"编辑资料", nil);
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    if(uuid == nil)
    {
        uuid = @"";
    }
    [WRViewModel userHomeWithCompletion:^(NSError * _Nonnull error, id  _Nonnull resultObject) {
        
        [SVProgressHUD dismiss];
        WRSelfInfoPanelView *headerView = (WRSelfInfoPanelView*)self.tableView.tableHeaderView;
        
        [headerView update];
        
        [self.tableView reloadData];
    } apnsUUID:uuid];
    [_viewModel fetchUserdaliyWithCompletion:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self updateExperise];
    }];
    
    
//    [self updateExperise];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate&Source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat dy = 50;
    switch (indexPath.section) {
        case 2:
            dy = [SelfCommonDiseaseCell defaultHeight];
            break;
            
            //        case 2:
            //            dy = [SelfDiseasePhotoCell defaultHeightForTableView:tableView];
            //            break;
            
        default:
            break;
    }
    return dy;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _itemArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    switch (section) {
//        case 2:
//            title = NSLocalizedString(@"常见疾病史", nil);
//            break;
//            
//        case 3:
//         title = NSLocalizedString(@"X光、MRI片子等", nil);
//           break;
//            //
//        default:
//            break;
    }
    return title;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 1;
//    switch (section) {
//        case 1:
//            count = _itemArray.count;
//            break;
//            
//        default:
//            break;
//    }
    NSArray *array = _itemArray[section];
    count = array.count;
    return count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0, 0 , 0, 0);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MyInfoTag tag = indexPath.row;
    NSString *identifier = [NSString stringWithFormat:@"%ld",indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    __weak __typeof(self) weakSelf = self;
    if (!cell) {
        if ([identifier isEqualToString:[SelfCommonDiseaseCell className]])
        {
            SelfCommonDiseaseCell *diseaseCell = [[SelfCommonDiseaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell = diseaseCell;
            
            diseaseCell.clickBlock = ^(UIButton* sender) {
                DiseaseSelectorController *viewController = [[DiseaseSelectorController alloc] init];
                UINavigationController *nav = [[WRBaseNavigationController alloc] initWithRootViewController:viewController];
                viewController.completion = ^() {
                    [weakSelf.tableView reloadData];
                };
                [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
            };
        }
        //        else if ([identifier isEqualToString:[SelfDiseasePhotoCell className]])
        //        {
        //            SelfDiseasePhotoCell *photoCell = [[SelfDiseasePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //            photoCell.clickBlock = ^(UIImageView *sender) {
        //                NSInteger index = sender.tag;
        //                if (index >= [ShareUserData userData].diseasePhotoArray.count) {
        //                    [weakSelf showImagePicker:NO];
        //                } else {
        //                    [weakSelf showImageBrowser:index superView:sender.superview];
        //                }
        //            };
        //            cell = photoCell;
        //        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            //            cell.textLabel.textColor = [UIColor wr_themeColor];
            cell.textLabel.font = [UIFont wr_textFont];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.font = [UIFont wr_textFont];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([cell isKindOfClass:[SelfCommonDiseaseCell class]])
    {
        SelfCommonDiseaseCell *selfCell = (SelfCommonDiseaseCell*)cell;
        NSMutableArray *array = [NSMutableArray array];
        [[ShareUserData userData].commonDiseases enumerateObjectsUsingBlock:^(WRCommonDisease*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isChoosen]) {
                [array addObject:obj.name];
            }
        }];
        [selfCell setTags:array];
    }
    //    else if([cell isKindOfClass:[SelfDiseasePhotoCell class]])
    //    {
    //        SelfDiseasePhotoCell *photoCell = (SelfDiseasePhotoCell*)cell;
    //        [photoCell setImages:[ShareUserData userData].diseasePhotoArray];
    //    }
    else
    {
      
        if (indexPath.section == 0) {
            cell.textLabel.text = NSLocalizedString(@"等级", nil);
            if (!cell.accessoryView) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
                NSInteger level = [WRUserInfo selfInfo].level;
                
                if (level > 10) {
                    level = 10;
                }
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_normal_%d", (int)level]];
                cell.accessoryView = imageView;
            }
        }
        else
        {
            NSArray *detailArray = _itemArray[indexPath.section];
            NSString *emptyValueString = NSLocalizedString(@"未填写", nil);
            NSString *sexDesc = [WRApp genderDescription:_userInfo.sex];
            NSString *location = [NSString stringWithFormat:@"%@ %@", _userInfo.province, _userInfo.city];
            if ([Utility IsEmptyString:_userInfo.province]
                && [Utility IsEmptyString:_userInfo.city])
            {
                location = emptyValueString;
            }
            
            NSString *heightDesc = [NSString stringWithFormat:@"%dcm", (int)_userInfo.height];
            if (_userInfo.height == 0)
            {
                heightDesc = emptyValueString;
            }
            
            NSString *weightDesc = [NSString stringWithFormat:@"%dkg", (int)_userInfo.weight];
            if (_userInfo.weight == 0)
            {
                weightDesc = emptyValueString;
            }
            
            CGFloat bmi = 0;
            NSString *bmiDesc = @"0";
            if (_userInfo.height > 0 && _userInfo.weight > 0)
            {
                bmi = [self calculateBmi:_userInfo.weight height:_userInfo.height];
                bmiDesc = [NSString stringWithFormat:@"%.2f(%@)",bmi, [self bmiDesc:bmi]];
            }
            
            NSString *birthDay = _userInfo.birthDay;
            if ([Utility IsEmptyString:birthDay])
            {
                birthDay = emptyValueString;
            }
            else
            {
                if (birthDay.length > 10)
                {
                    birthDay = [birthDay substringToIndex:10];
                }
                
            }
            
            NSArray *array = @[
                               @[_userInfo.name,
                                  sexDesc,
                                  birthDay],
                               
                               @[location],
                               @[heightDesc,
                                weightDesc,
                                bmiDesc,
                                @""]
                               
                               ];
            NSArray *textArray = array[indexPath.section - 1];
                    cell.textLabel.text = detailArray[indexPath.row];
                    cell.detailTextLabel.text = textArray[indexPath.row];
            
        }
    }
    if ((indexPath.section == 1 && indexPath.row < 6) || (indexPath.section == 0)) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        [UMengUtils careForMeLevel:[@([WRUserInfo selfInfo].level) stringValue]];
        LevelController *controller = [[LevelController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"修改昵称", nil) message:NSLocalizedString(@"6-20个字符为限", nil) preferredStyle:UIAlertControllerStyleAlert];
                [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *submitAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"修改", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UITextField *textField = controller.textFields.firstObject;
                    NSString *text = textField.text;
                    if (text.length > 20) {
                        text = [text substringWithRange:NSMakeRange(0, 20)];
                    }
                    _userInfo.name = text;
                    [weakSelf.tableView reloadData];
                    [self onClickedSubmitButton:nil];
                    [WRUserInfo selfInfo].name = text;
                    [[WRUserInfo selfInfo] save];
                }];
                [controller addAction:cancelAction];
                [controller addAction:submitAction];
                [self presentViewController:controller animated:YES completion:nil];

                break;
            }
            case 1:
            {
                UIView *sourceView = nil;
                CGRect sourceRect = CGRectZero;
                if (IPAD_DEVICE) {
                    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                    sourceView = cell;
                    sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
                }
                [self showSexSelectorWithCompletion:^(NSInteger sex) {
                    _userInfo.sex = sex;
                    [weakSelf.tableView reloadData];
                    [weakSelf onClickedSubmitButton:nil];
                    [WRUserInfo selfInfo].sex = sex;
                    [[WRUserInfo selfInfo] save];
                } sourceView:sourceView sourceRect:sourceRect];
                break;
            }
            case 2:
            {
                UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 40, 216)];
                picker.tag = TagBirthDay;
                picker.datePickerMode =UIDatePickerModeDate;
//                picker.dataSource = self;
//                picker.delegate = self;
                NSUInteger defaultValue = _userInfo.age;
                if(defaultValue == 0) {
                    defaultValue += 30;
                    defaultValue -= MinAge;
                    _tempValue = defaultValue;
                }
//                [picker selectRow:defaultValue inComponent:0 animated:NO];
                [WRSheetView showWithCustomView:picker completion:^{
                    NSDate *date = picker.date;
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy"];
                    NSInteger currentYear = [[formatter stringFromDate:date] integerValue];
                    [formatter setDateFormat:@"MM"];
                    NSInteger currentMonth=[[formatter stringFromDate:date] integerValue];
                    [formatter setDateFormat:@"dd"];
                    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
                    NSInteger birthdayYear = currentYear;
                    NSString * birthdayStr =[NSString stringWithFormat:@"%d-%d-%d",(int)birthdayYear,(int)currentMonth,(int)currentDay];
                    _userInfo.birthDay = birthdayStr;
                    [weakSelf.tableView reloadData];
                    [self onClickedSubmitButton:nil];
                    [WRUserInfo selfInfo].birthDay = birthdayStr;
                    [[WRUserInfo selfInfo] save];
                }];

                break;
            }
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        [WRCitySelectorView showWithCompletion:^(WRLocation *location) {
            _userInfo.province = location.state;
            _userInfo.city = location.city;
            [weakSelf.tableView reloadData];
            [weakSelf onClickedSubmitButton:nil];
            [WRUserInfo selfInfo].province = location.state;
            [WRUserInfo selfInfo].city = location.city;
            [[WRUserInfo selfInfo] save];
        }];
    } else if (indexPath.section == 3) {
        NSUInteger tag = indexPath.row;
        switch (indexPath.row) {
            case 0:
            case 1:
            {
                UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 40, 216)];
                picker.tag = indexPath.row?TagWeight:TagHeight;
                picker.dataSource = self;
                picker.delegate = self;
                NSUInteger defaultValue = (tag == TagHeight)?_userInfo.height:_userInfo.weight;
                if(defaultValue == 0) {
                    defaultValue += (tag == TagHeight)?170:55;
                    defaultValue -= (tag == TagHeight)?MinHeight:MinWeight;
                    _tempValue = defaultValue;
                } else {
                    defaultValue -= (tag == TagHeight)?MinHeight:MinWeight;
                    _tempValue = defaultValue;
                }
                [picker selectRow:defaultValue inComponent:0 animated:NO];
                [WRSheetView showWithCustomView:picker completion:^{
                    switch (picker.tag) {
                        case TagHeight:
                            _userInfo.height = _tempValue + MinHeight;
                            break;
                            
                        case TagWeight:
                            _userInfo.weight = _tempValue + MinWeight;
                            break;
                            
                        default:
                            break;
                    }
                    [weakSelf.tableView reloadData];
                    [weakSelf onClickedSubmitButton:nil];
                    switch (picker.tag) {
                        case TagHeight:
                            [WRUserInfo selfInfo].height = _tempValue + MinHeight;
                            [[WRUserInfo selfInfo] save];
                            break;
                            
                        case TagWeight:
                            [WRUserInfo selfInfo].weight = _tempValue + MinHeight;
                            [[WRUserInfo selfInfo] save];
                            break;
                            
                        default:
                            break;
                    }
                }];
                break;
            }
            case 2:
            {
                break;
            }
            default:
                break;
        }
    }


            
    
//        case TagHistory:
//        {
//            WRInputViewController *vc = [[WRInputViewController alloc] init];
//            __weak __typeof(vc) weakObject = vc;
//            vc.completion = ^() {
//                _userInfo.diseaseHistory = weakObject.textView.text;
//                [weakSelf.tableView reloadData];
//                [weakSelf onClickedSubmitButton:nil];
//                [WRUserInfo selfInfo].diseaseHistory = weakObject.textView.text;
//                [[WRUserInfo selfInfo] save];
//            };
//            
//            WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:vc];
//            [self.navigationController presentViewController:nav animated:YES completion:nil];
//            vc.title = NSLocalizedString(@"请输入您的病史", nil);
//            vc.textView.text = _userInfo.diseaseHistory;
//            break;
//        }
    
    
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = 0;
    switch (pickerView.tag) {
        case TagHeight:
            count = MaxHeight - MinHeight;
            break;
            
        case TagWeight:
            count = MaxWeight - MinWeight;
            break;
        case TagBirthDay:
            count = MaxAge - MinAge;
        default:
            break;
    }
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *value = @"";
    switch (pickerView.tag) {
        case TagHeight:
            value = [NSString stringWithFormat:@"%dcm", (int)(row + MinHeight)];
            break;
            
        case TagWeight:
            value = [NSString stringWithFormat:@"%dkg", (int)(row + MinWeight)];
            break;
        case TagBirthDay:
            value = [NSString stringWithFormat:@"%d", (int)(row + MinAge)];
            break;
        default:
            break;
    }
    return value;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _tempValue = row;
}

#pragma mark - IBActions
-(IBAction)userHeadTapped:(UITapGestureRecognizer*)sender {
    _isUserHead = YES;
    if (!_imagePicker) {
        __weak __typeof(self) weakSelf = self;
        
        _imagePicker = [[WRImagePicker alloc] initWithController:self.navigationController targetSize:CGSizeMake(320, 320) imageView:(UIImageView *)_headImageView];
        _imagePicker.completion = ^(UIImage* image) {
            [weakSelf uploadImage:image];
        };
    }
    [_imagePicker show];
}

-(IBAction)onSexSegmentedControlValueChanged:(UISegmentedControl*)sender {
    _userInfo.sex = sender.selectedSegmentIndex + 1;
}

-(IBAction)onClickedModifyDiseaseHistory:(UIControl*)sender {
    __weak __typeof(self) weakSelf = self;
    WRInputViewController *vc = [[WRInputViewController alloc] init];
    __weak __typeof(vc) weakObject = vc;
    vc.completion = ^() {
        _userInfo.diseaseHistory = weakObject.textView.text;
        [weakSelf createFooterView:weakSelf.tableView];
    };
    
    WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    vc.title = NSLocalizedString(@"请输入您的病史", nil);
    vc.textView.text = _userInfo.diseaseHistory;
}

- (IBAction)onClickedSubmitButton:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    NSString *value = _userInfo.name;
    
        params[@"name"] = _userInfo.name;
    
    
    
        params[@"diseaseHistory"] = _userInfo.diseaseHistory;
    
    
    
        params[@"sex"] = @(_userInfo.sex);
    
    
    
        params[@"birthDay"] = _userInfo.birthDay;
    
    
        params[@"province"] = _userInfo.province;
    
    
        params[@"city"] = _userInfo.city;
    
    
        params[@"height"] = @(_userInfo.height);
    
        params[@"weight"] = @(_userInfo.weight);
    
    if (params.count == 0) {
        [Utility showToast:NSLocalizedString(@"并没有修改任何信息", nil) position:ToastPositionBottom];
    } else {
        __weak __typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在提交请求", nil)];
        [WRViewModel modifySelfBasicInfo:params completion:^(NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            if (error) {
                NSString *errorString = error.domain;
                if ([Utility IsEmptyString:errorString]) {
                    errorString = NSLocalizedString(@"修改信息失败,请检查网络", nil);
                }
                [Utility retryAlertWithViewController:weakSelf title:errorString completion:^{
                    [weakSelf onClickedSubmitButton:sender];
                }];
            } else {
                for (NSString *item in params.allKeys) {
                    [UMengUtils careForMeModify:item];
                }
                //                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"修改成功", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                //                [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //                    [weakSelf.navigationController popViewControllerAnimated:YES];
                //                }]];
                //                [weakSelf presentViewController:controller animated:YES completion:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:WRUpdateSelfInfoNotification object:nil];
            }
        }];
    }
}


#pragma mark - SDPhotoBrowserDelegate
-(UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return [UIImage imageNamed:@"well_default"];
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSString *imageUrl = [ShareUserData userData].diseasePhotoArray[index];
    return [NSURL URLWithString:imageUrl];
}

-(NSString *)photoBrowser:(SDPhotoBrowser *)browser detailForIndex:(NSInteger)index {
    return @"";
}

#pragma mark - Image
-(void)showImageBrowser:(NSInteger)index superView:(UIView*)superView
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = superView;
    browser.imageCount = [ShareUserData userData].diseasePhotoArray.count;
    browser.currentImageIndex = index;
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
}

#pragma mark -
-(void)updateSelfInfo {
    
    
}

-(NSString*)getDisease {
    NSString *text = _userInfo.diseaseHistory;
    if ([Utility IsEmptyString:text]) {
        text = NSLocalizedString(@"点击填写", nil);
    }
    return text;
}

-(CGFloat)calculateBmi:(NSUInteger)weightKg height:(CGFloat)heightCm {
    return (CGFloat)weightKg/((CGFloat)heightCm*heightCm/10000);
}

-(NSString*)bmiDesc:(CGFloat)bmi {
    if (bmi < 18.5) {
        return NSLocalizedString(@"偏瘦", nil);
    } else if(bmi > 24) {
        return NSLocalizedString(@"偏胖", nil);
    } else {
        return NSLocalizedString(@"正常", nil);
    }
}

-(void)createFooterView:(UITableView*)tableView {
    tableView.tableFooterView = [UIView new];
}

-(void)uploadImage:(UIImage*)image {
    
    NSString *title = _isUserHead ? NSLocalizedString(@"修改头像失败", nil) : NSLocalizedString(@"上传图片失败", nil);
    __weak __typeof(self) weakSelf = self;
    void (^failedBlock)(NSError *) = ^ (NSError *error) {
        [Utility retryAlertWithViewController:weakSelf.navigationController title:title completion:^{
            [weakSelf uploadImage:image];
        }];
        if (error) {
            NSLog(@"failed %@", error.localizedDescription);
        }
    };
    
    [SVProgressHUD showProgress:0 status:NSLocalizedString(@"正在上传图片", nil)];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *type = _isUserHead ? @"userHead" : @"userDisease";
    NSString *url = [NSString stringWithFormat:[WRNetworkService getFormatURLString: urlUpload],type];
    NSLog(@"url %@",url);
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData * imageData = UIImagePNGRepresentation(image);
        NSString *fileName = [NSString stringWithFormat:@"%@%zi.png", @"image", 0];
        [formData appendPartWithFileData:imageData name:@"self" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [SVProgressHUD showProgress:(float)(uploadProgress.completedUnitCount)/uploadProgress.totalUnitCount
                             status:NSLocalizedString(@"正在上传图片", nil)];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *json = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        WRJsonParser *parser = [WRJsonParser ParserFromString:json];
        if (parser.isSuccess) {
            NSDictionary *dict = parser.resultObject;
            
            BOOL flag = NO;
            do{
                NSArray *array = dict[@"fileList"];
                if (array.count == 0) {
                    break;
                }
                
                NSMutableArray *imageUrlArray = [NSMutableArray array];
                NSMutableArray *imageIdArray = [NSMutableArray array];
                
                [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *path = obj[@"fileUrl"];
                    NSString *imageId = obj[@"fileId"];
                    if (![Utility IsEmptyString:path]) {
                        [imageUrlArray addObject:path];
                        [imageIdArray addObject:imageId];
                    }
                }];
                
                if (imageUrlArray.count == 0) {
                    break;
                }
                flag = YES;
                if (_isUserHead) {
                    NSString *imageUrl = imageUrlArray.firstObject;
                    NSString *fileId = imageIdArray.firstObject;
                    NSLog(@"%@ %@", imageUrl, fileId);
                    
                    [WRViewModel modifySelfBasicInfo:@{@"imageId":fileId} completion:^(NSError * _Nonnull error) {
                        [SVProgressHUD dismiss];
                        if (error) {
                            failedBlock(error);
                        } else {
                            [WRUserInfo selfInfo].headImageUrl = imageUrl;
                            [[WRUserInfo selfInfo] save];
                            [weakSelf updateSelfInfo];
                            [[NSNotificationCenter defaultCenter] postNotificationName:WRUpdateSelfInfoNotification object:nil];
                        }
                    }];
                } else {
                    NSString *idString = [imageIdArray componentsJoinedByString:@"|"];
                    [WRViewModel operationWithType:OperationTypeUserDiseasePhoto indexId:idString actionType:OperationActionTypeAdd contentType:OperationContentTypeUnknown completion:^(NSError * _Nonnull error) {
                        [SVProgressHUD dismiss];
                        if (error) {
                            failedBlock(error);
                        } else {
                            NSMutableArray *photoArray = [ShareUserData userData].diseasePhotoArray;
                            [photoArray addObjectsFromArray:imageUrlArray];
                            [weakSelf.tableView reloadData];
                        }
                    }];
                }
            }while (NO);
            
            if (!flag) {
                [SVProgressHUD dismiss];
                failedBlock(nil);
            }
            
        } else {
            [SVProgressHUD dismiss];
            failedBlock(nil);
        }
        NSLog(@"success %@", json);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        failedBlock(error);
    }];
}

//-(void)uploadImage:(UIImage*)image {
//    [SVProgressHUD showProgress:0 status:NSLocalizedString(@"正在上传图片", nil)];
//
//    __weak __typeof(self) weakSelf = self;
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSString *type = _isUserHead ? @"userHead" : @"userDisease";
//    NSString *url = [NSString stringWithFormat:[WRNetworkService getFormatURLString: urlUpload],type];
//    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSData * imageData = UIImagePNGRepresentation(image);
//        NSString *fileName = [NSString stringWithFormat:@"%@%zi.png", @"image", 0];
//        [formData appendPartWithFileData:imageData name:@"self" fileName:fileName mimeType:@"image/png"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        [SVProgressHUD showProgress:(float)(uploadProgress.completedUnitCount)/uploadProgress.totalUnitCount
//                             status:NSLocalizedString(@"正在上传图片", nil)];
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *json = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        WRJsonParser *parser = [WRJsonParser ParserFromString:json];
//        if (parser.isSuccess) {
//            NSDictionary *dict = parser.resultObject;
//            if (!_isUserHead) {
//
//                BOOL flag = NO;
//                do{
//                    NSArray *array = dict[@"fileList"];
//                    if (array.count == 0) {
//                        break;
//                    }
//
//                    NSMutableArray *imageUrlArray = [NSMutableArray array];
//                    NSMutableArray *imageIdArray = [NSMutableArray array];
//
//                    [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        NSString *path = obj[@"fileUrl"];
//                        NSString *imageId = obj[@"fileId"];
//                        if (![Utility IsEmptyString:path]) {
//                            [imageUrlArray addObject:path];
//                            [imageIdArray addObject:imageId];
//                        }
//                    }];
//
//                    if (imageUrlArray.count == 0) {
//                        break;
//                    }
//                    flag = YES;
//                    NSString *idString = [imageIdArray componentsJoinedByString:@"|"];
//                    [WRViewModel operationWithType:WROperationTypeUserDiseasePhoto indexId:idString flag:YES contentType:@"" completion:^(NSError * _Nonnull error) {
//                        [SVProgressHUD dismiss];
//                        if (error) {
//                            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"上传图片失败", nil) completion:^{
//                                [weakSelf uploadImage:image];
//                            }];
//                        } else {
//                            NSMutableArray *photoArray = [ShareUserData userData].diseasePhotoArray;
//                            [photoArray addObjectsFromArray:imageUrlArray];
//                            [weakSelf.tableView reloadData];
//                        }
//                    }];
//
//                }while (NO);
//
//                if (!flag) {
//                    [SVProgressHUD dismiss];
//                    [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"上传图片失败", nil) completion:^{
//                        [weakSelf uploadImage:image];
//                    }];
//                }
//
//            } else {
//                NSString *fileId = dict[@"fileId"];
//                NSArray *imageUrlsArray = dict[@"fileUrlList"];
//                if (imageUrlsArray.count > 0)
//                {
//                    NSString *imageUrl = imageUrlsArray.firstObject;
//                    NSLog(@"%@", imageUrl);
//                    [WRViewModel modifySelfBasicInfo:@{@"imageId":fileId} completion:^(NSError * _Nonnull error) {
//                        [SVProgressHUD dismiss];
//                        if (error) {
//
//                        } else {
//                            [WRUserInfo selfInfo].headImageUrl = imageUrl;
//                            [[WRUserInfo selfInfo] save];
//                            [weakSelf updateSelfInfo];
//                            [[NSNotificationCenter defaultCenter] postNotificationName:WRUpdateSelfInfoNotification object:nil];
//                        }
//                    }];
//                } else {
//                    [SVProgressHUD dismiss];
//                }
//            }
//
//        } else {
//            [SVProgressHUD dismiss];
//            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"上传图片失败", nil)];
//        }
//        NSLog(@"success %@", json);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"上传图片失败", nil)];
//        NSLog(@"failed %@", error.localizedDescription);
//    }];
//}

@end
