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
#import "WRViewModel.h"
#import "WRUserDiseaseHistoryCell.h"
#import "SelfCommonDiseaseCell.h"
#import "SelfDiseasePhotoCell.h"
#import "WRSelfInfoPanelView.h"
#import "DiseaseSelectorController.h"
#import "SDPhotoBrowser.h"
#import "ActionSheetDatePicker.h"
#import "ShareUserData.h"

const NSUInteger MaxHeight = 250;
const NSUInteger MinHeight = 100;
const NSUInteger MaxWeight = 150;
const NSUInteger MinWeight = 20;
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

@interface UserBasicInfoController ()<UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, SDPhotoBrowserDelegate>
{
    NSArray *_itemArray;
    
    NSInteger _tempValue;
    NSDate *_startDate;
    BOOL _isUserHead;
    CGSize _currentImageSize;
}
@property(nonatomic)WRUserInfo *userInfo;

@end

@implementation UserBasicInfoController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForMeWithType:@"basic" duration:duration];
}

- (instancetype)init {
    if(self = [super initWithStyle:UITableViewStyleGrouped]){
        _startDate = [NSDate date];
        NSDictionary *dic = [[WRUserInfo selfInfo] convertDictionary];
        _userInfo = [[WRUserInfo alloc] initWithDictionary:dic];
        _itemArray = @[
                       NSLocalizedString(@"昵称", nil),
                       NSLocalizedString(@"性别", nil),
                       NSLocalizedString(@"年龄", nil),
                       NSLocalizedString(@"所在城市", nil),
                       NSLocalizedString(@"身高", nil),
                       NSLocalizedString(@"体重", nil),
                       NSLocalizedString(@"体质指数", nil),
                       //NSLocalizedString(@"病史", nil)
                       ];
        UIImage *image = [WRUIConfig defaultHeadImage];
        CGFloat cx = self.tableView.width;
        CGFloat cy = image.size.height + 40;
        WRSelfInfoPanelView *headerView = [[WRSelfInfoPanelView alloc] initWithFrame:CGRectMake(0, 0, cx, cy) isSimple:YES];
        headerView.logOffButton.hidden = YES;
        headerView.nameLabel.hidden = YES;
        headerView.backgroundColor = [UIColor wr_lightGray];
        
        self.tableView.tableHeaderView = headerView;
        self.tableView.showsVerticalScrollIndicator = NO;
        
        [self createFooterView:self.tableView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadTapped:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [headerView.headImageView addGestureRecognizer:singleTap];
        [headerView.headImageView setUserInteractionEnabled:YES];
        [self updateSelfInfo];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onClickedSubmitButton:)];
    [WRNetworkService pwiki:@"个人资料"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"个人资料", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate&Source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat dy = 50;
    switch (indexPath.section) {
        case 1:
            dy = [SelfCommonDiseaseCell defaultHeight];
            break;
            
        case 2:
            dy = [SelfDiseasePhotoCell defaultHeightForTableView:tableView];
            break;
            
        default:
            break;
    }
    return dy;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    switch (section) {
        case 1:
            title = NSLocalizedString(@"常见疾病史", nil);
            break;
            
        case 2:
            title = NSLocalizedString(@"X光、MRI片子等", nil);
            break;
            
        default:
            break;
    }
    return title;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 1;
    switch (section) {
        case 0:
            count = _itemArray.count;
            break;
            
        default:
            break;
    }
    return count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0, 0 , 0, 0);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyInfoTag tag = indexPath.row;
    NSString *identifier = WRCellIdentifier;
    switch (indexPath.section) {
        case 0:
            identifier = [NSString stringWithFormat:@"cell%d", (int)tag];
            break;
            
        case 1:
            identifier = [SelfCommonDiseaseCell className];
            break;
            
        case 2:
            identifier = [SelfDiseasePhotoCell className];
            break;
            
        default:
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    __weak __typeof(self) weakSelf = self;
    if (!cell) {
        if ([identifier isEqualToString:[SelfCommonDiseaseCell className]])
        {
            SelfCommonDiseaseCell *diseaseCell = [[SelfCommonDiseaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell = diseaseCell;
            
            diseaseCell.clickBlock = ^(UIButton* sender) {
                DiseaseSelectorController *viewController = [[DiseaseSelectorController alloc] init];
                WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];
                viewController.completion = ^() {
                    [weakSelf.tableView reloadData];
                };
                [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
            };
        }
        else if ([identifier isEqualToString:[SelfDiseasePhotoCell className]])
        {
            SelfDiseasePhotoCell *photoCell = [[SelfDiseasePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            photoCell.clickBlock = ^(UIImageView *sender) {
                NSInteger index = sender.tag;
                if (index >= [ShareUserData userData].diseasePhotoArray.count) {
                    [weakSelf showImagePicker:NO];
                } else {
                    [weakSelf showImageBrowser:index superView:sender.superview];
                }
            };
            cell = photoCell;
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.textLabel.textColor = [UIColor wr_themeColor];
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
    else if([cell isKindOfClass:[SelfDiseasePhotoCell class]])
    {
        SelfDiseasePhotoCell *photoCell = (SelfDiseasePhotoCell*)cell;
        [photoCell setImages:[ShareUserData userData].diseasePhotoArray];
    }
    else
    {
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
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *birthDayDate = [dateFormatter dateFromString:birthDay];
            //当前时间
            NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
            NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
            NSTimeInterval time = [currentDate timeIntervalSinceDate:birthDayDate];
            int age = ((int)time)/(3600*24*365);
            birthDay = [@(age) stringValue];
        }
        
        NSArray *array = @[
                           _userInfo.name,
                           sexDesc,
                           birthDay,
                           location,
                           heightDesc,
                           weightDesc,
                           bmiDesc,
                           @""
                           ];
        
        switch (tag)
        {
            case TagHistory:
            {
                WRUserDiseaseHistoryCell *diseaseCell = (WRUserDiseaseHistoryCell*)cell;
                diseaseCell.titleLabel.text = _itemArray[tag];
                diseaseCell.contentLabel.text = [self getDisease];
                break;
            }
                
            default:
                cell.textLabel.text = _itemArray[tag];
                cell.detailTextLabel.text = array[tag];
                break;
        }
    }
    if (indexPath.section == 0 && indexPath.row < 6) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font = [UIFont wr_textFont];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont wr_textFont];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        return;
    }
    MyInfoTag tag = indexPath.row;
    __weak __typeof(self) weakSelf = self;
    switch (tag) {
        case TagNickName: {
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
                [WRUserInfo selfInfo].name = text;
                [[WRUserInfo selfInfo] save];
                [weakSelf.tableView reloadData];
                [self onClickedSubmitButton:nil];
            }];
            [controller addAction:cancelAction];
            [controller addAction:submitAction];
            [self presentViewController:controller animated:YES completion:nil];
            break;
        }
            
        case TagSex: {
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
            
        case TagBirthDay: {
            /*
             UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 40, 216)];
             datePicker.datePickerMode = UIDatePickerModeDate;
             NSDate *now = [NSDate date];
             datePicker.date = [now dateByAddingYears:-DefaultAge];
             [WRSheetView showWithCustomView:datePicker completion:^{
             NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
             [dateFormat setDateFormat:@"yyyy-MM-dd"];
             NSString *dateString = [dateFormat stringFromDate:datePicker.date];
             _userInfo.birthDay = dateString;
             [weakSelf.tableView reloadData];
             }];
             */
            __weak __typeof(self) weakSelf = self;
            [ActionSheetDatePicker showPickerWithTitle:@"选择生日" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                NSString *dateString = [dateFormat stringFromDate:selectedDate];
                _userInfo.birthDay = dateString;
                [weakSelf.tableView reloadData];
                [self onClickedSubmitButton:nil];
                [WRUserInfo selfInfo].birthDay = dateString;
                [[WRUserInfo selfInfo] save];
            } cancelBlock:^(ActionSheetDatePicker *picker) {
                
            } origin:self.navigationController.view];
            break;
        }
            
        case TagCity: {
            [WRCitySelectorView showWithCompletion:^(WRLocation *location) {
                _userInfo.province = location.state;
                _userInfo.city = location.city;
                [weakSelf.tableView reloadData];
                [weakSelf onClickedSubmitButton:nil];
                [WRUserInfo selfInfo].province = location.state;
                [WRUserInfo selfInfo].city = location.city;
                [[WRUserInfo selfInfo] save];
            }];
            break;
        }
            
        case TagHeight:
        case TagWeight:
        {
            UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 40, 216)];
            picker.tag = tag;
            picker.dataSource = self;
            picker.delegate = self;
            NSUInteger defaultValue = (tag == TagHeight)?_userInfo.height:_userInfo.weight;
            if(defaultValue == 0) {
                defaultValue += (tag == TagHeight)?170:55;
                defaultValue -= (tag == TagHeight)?MinHeight:MinWeight;
                _tempValue = defaultValue;
            }
            [picker selectRow:defaultValue inComponent:0 animated:NO];
            [WRSheetView showWithCustomView:picker completion:^{
                switch (picker.tag) {
                    case TagHeight:
                        _userInfo.height = _tempValue + MinHeight;
                        [WRUserInfo selfInfo].height = _tempValue + MinHeight;
                        [[WRUserInfo selfInfo] save];
                        break;
                        
                    case TagWeight:
                        _userInfo.weight = _tempValue + MinWeight;
                        [WRUserInfo selfInfo].weight = _tempValue + MinHeight;
                        [[WRUserInfo selfInfo] save];
                        break;
                        
                    default:
                        break;
                }
                [weakSelf.tableView reloadData];
                [weakSelf onClickedSubmitButton:nil];
            }];
            break;
        }
            
        case TagHistory:
        {
            WRInputViewController *vc = [[WRInputViewController alloc] init];
            __weak __typeof(vc) weakObject = vc;
            vc.completion = ^() {
                _userInfo.diseaseHistory = weakObject.textView.text;
                [weakSelf.tableView reloadData];
                [weakSelf onClickedSubmitButton:nil];
                [WRUserInfo selfInfo].diseaseHistory = weakObject.textView.text;
                [[WRUserInfo selfInfo] save];
            };
            
            WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            vc.title = NSLocalizedString(@"请输入您的病史", nil);
            vc.textView.text = _userInfo.diseaseHistory;
            break;
        }
            
        default:break;
    }
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
    [self showImagePicker:YES];
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
    if(![Utility IsEmptyString:value] && ![value isEqualToString:selfInfo.name]) {
        params[@"name"] = value;
    }
    
    value = _userInfo.diseaseHistory;
    if(![Utility IsEmptyString:value] && ![value isEqualToString:selfInfo.diseaseHistory]) {
        params[@"diseaseHistory"] = value;
    }
    
    if(selfInfo.sex != _userInfo.sex) {
        params[@"sex"] = @(_userInfo.sex);
    }
    
    value = _userInfo.birthDay;
    if(![Utility IsEmptyString:value] && ![value isEqualToString:selfInfo.birthDay]) {
        params[@"birthDay"] = value;
    }
    
    value = _userInfo.province;
    if(![Utility IsEmptyString:value] && ![value isEqualToString:selfInfo.city]) {
        params[@"province"] = value;
    }
    
    value = _userInfo.city;
    if(![Utility IsEmptyString:value] && ![value isEqualToString:selfInfo.city]) {
        params[@"city"] = value;
    }
    
    if(selfInfo.height != _userInfo.height) {
        params[@"height"] = @(_userInfo.height);
    }
    if(selfInfo.weight != _userInfo.weight) {
        params[@"weight"] = @(_userInfo.weight);
    }
    
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
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"修改成功", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }]];
                [weakSelf presentViewController:controller animated:YES completion:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:WRUpdateSelfInfoNotification object:nil];
            }
        }];
    }
}

#pragma mark -
-(void)updateSelfInfo {
    WRSelfInfoPanelView *headerView = (WRSelfInfoPanelView*)self.tableView.tableHeaderView;
    [headerView update];
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


#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    UIViewController *controller = self.navigationController;
    __weak __typeof(self) weakSelf = self;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = weakSelf;
    //imagePicker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case 0://照相机
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        }
            
        case 2://摄像机
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
            break;
        }
            
        case 1://本地相簿
        case 3://本地视频
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        }
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [controller presentViewController:imagePicker animated:YES completion:nil];
    }];
}

#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    CGSize destImageSize = _isUserHead ? CGSizeMake(320, 320) : CGSizeMake(576, 720);
    UIImage *smallImage = [self.class imageByScalingAndCroppingForSize:destImageSize image:image];
    NSLog(@"pick photo size %@ %@", NSStringFromCGSize(image.size), NSStringFromCGSize(smallImage.size));
    [self uploadImage:smallImage];
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

-(void)uploadImage:(UIImage*)image {
    [SVProgressHUD showProgress:0 status:NSLocalizedString(@"正在上传图片", nil)];
    
    __weak __typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [WRNetworkService getFormatURLString: _isUserHead ? urlUploadHeadImage : urlUserUploadFile];
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
            if (!_isUserHead) {
                
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
                    NSString *idString = [imageIdArray componentsJoinedByString:@"|"];
                    [WRViewModel operationWithType:WROperationTypeUserDiseasePhoto indexId:idString flag:YES contentType:@"" completion:^(NSError * _Nonnull error) {
                        [SVProgressHUD dismiss];
                        if (error) {
                            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"上传图片失败", nil) completion:^{
                                [weakSelf uploadImage:image];
                            }];
                        } else {
                            NSMutableArray *photoArray = [ShareUserData userData].diseasePhotoArray;
                            [photoArray addObjectsFromArray:imageUrlArray];
                            [weakSelf.tableView reloadData];
                        }
                    }];
                    
                }while (NO);
                
                if (!flag) {
                    [SVProgressHUD dismiss];
                    [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"上传图片失败", nil) completion:^{
                        [weakSelf uploadImage:image];
                    }];
                }
                
            } else {
                NSString *fileId = dict[@"fileId"];
                NSArray *imageUrlsArray = dict[@"fileUrlList"];
                if (imageUrlsArray.count > 0)
                {
                    NSString *imageUrl = imageUrlsArray.firstObject;
                    NSLog(@"%@", imageUrl);
                    [WRViewModel modifySelfBasicInfo:@{@"imageId":fileId} completion:^(NSError * _Nonnull error) {
                        [SVProgressHUD dismiss];
                        if (error) {
                            
                        } else {
                            [WRUserInfo selfInfo].headImageUrl = imageUrl;
                            [[WRUserInfo selfInfo] save];
                            [weakSelf updateSelfInfo];
                            [[NSNotificationCenter defaultCenter] postNotificationName:WRUpdateSelfInfoNotification object:nil];
                        }
                    }];
                } else {
                    [SVProgressHUD dismiss];
                }
            }
            
        } else {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"上传图片失败", nil)];
        }
        NSLog(@"success %@", json);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"上传图片失败", nil)];
        NSLog(@"failed %@", error.localizedDescription);
    }];
}

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage*)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
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
-(void)showImagePicker:(BOOL)flag
{
    _isUserHead = flag;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"本地相簿",nil];
    [actionSheet showInView:self.navigationController.view];
}

-(void)showImageBrowser:(NSInteger)index superView:(UIView*)superView
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = superView;
    browser.imageCount = [ShareUserData userData].diseasePhotoArray.count;
    browser.currentImageIndex = index;
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
}

@end