//
//  BindClientViewController.m
//  rehab
//
//  Created by Matech on 3/3/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "BindClientViewController.h"
#import "WRViewModel.h"
#import "WToast.h"
#import "BaseCell.h"
#import <UMMobClick/MobClick.h>
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

@interface BindClientViewController ()
{
    NSArray *_typeArray, *_iconArray;
}
@property(nonatomic, copy) NSString *phone;
@end

@implementation BindClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    _typeArray = @[
                   NSLocalizedString(@"绑定手机", nil),
                   NSLocalizedString(@"绑定微信", nil),
                   NSLocalizedString(@"绑定QQ", nil)
    /*,NSLocalizedString(@"绑定微博", nil)*/];
    _iconArray = @[@"share_phone", @"share_wechat", @"share_qq", ];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [WRNetworkService pwiki:@"帐号绑定"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate&Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = PNG_IMAGE_NAMED(_iconArray[0]);
    return image.size.height + 2*WRUIOffset;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 0) {
        return 1;
    }
    return _typeArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 24;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = WRCellIdentifier;
    if (indexPath.section == 1) {
        identifier = [CenterTitleCell className];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        if ([identifier isEqualToString:[CenterTitleCell className]]) {
            cell = [[CenterTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.textLabel.text = NSLocalizedString(@"退出当前帐号", nil);
            cell.textLabel.textColor = [UIColor wr_themeColor];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([cell isKindOfClass:[CenterTitleCell class]]) {
        
    } else {
        NSString *text = _typeArray[indexPath.row];
        if (indexPath.row == 0)
        {
            if (![Utility IsEmptyString:[WRUserInfo selfInfo].phone]) {
                text = [WRUserInfo selfInfo].phone;
            }
        }
        cell.textLabel.text = text;
        cell.imageView.image = PNG_IMAGE_NAMED(_iconArray[indexPath.row]);
        
        WRUserInfo *selfInfo = [WRUserInfo selfInfo];
        NSArray *openIdArray = @[selfInfo.phone, selfInfo.weixinId, selfInfo.QQId];
        NSString *openId = openIdArray[indexPath.row];
        cell.accessoryType = ([Utility IsEmptyString:openId])?UITableViewCellAccessoryNone:UITableViewCellAccessoryCheckmark;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        WRUserInfo *selfInfo = [WRUserInfo selfInfo];
        NSArray *openIdArray = @[selfInfo.phone, selfInfo.weixinId, selfInfo.QQId];
        NSString *openId = openIdArray[indexPath.row];
        
        if (![Utility IsEmptyString:openId])
        {
            return;
        }
        
        if (indexPath.row == 0)
        {
            [self readyToBindPhone];
        }
        else
        {
            NSInteger index = indexPath.row;
            __weak __typeof(self) weakSelf = self;
            
            NSString *platform = index == 1 ? UMShareToWechatSession : UMShareToQQ;
            NSString *openType = index == 1 ? @"weixin":@"qq";
            NSString *type = (index == 1) ? @"wechat" : @"qq";
            [UMengUtils careForBindWithType:type];
            
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platform];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess)
                {
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                    
                    NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
                    
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"openType"] = openType;
                    params[@"type"] = @"bind";
                    if (snsAccount.usid) {
                        params[@"openId"] = snsAccount.usid;
                    }
                    if (snsAccount.userName) {
                        params[@"name"] = snsAccount.userName;
                    }
                    if (snsAccount.iconURL) {
                        params[@"icon"] = snsAccount.iconURL;
                    }
                    /*
                     Gender gender = GenderUnknown;
                     switch (user.gender) {
                     case SSDKGenderMale:
                     gender = GenderMale;
                     break;
                     
                     case SSDKGenderFemale:
                     gender = GenderFemale;
                     break;
                     
                     default:
                     gender = GenderUnknown;
                     break;
                     }
                     if (gender != GenderUnknown) {
                     params[@"sex"] = @(gender);
                     }
                     */
                    [SVProgressHUD show];
                    [WRViewModel userAuthorWithParams:params type:@"bind" completion:^(NSError * _Nonnull error) {
                        [SVProgressHUD dismiss];
                        if (error) {
                            NSString *text = error.domain;
                            if (!text) {
                                text = NSLocalizedString(@"绑定失败", nil);
                            }
                            [Utility Alert:text];
                        } else {
                            if (index == 1) {
                                selfInfo.weixinId = snsAccount.usid;
                            } else if (index == 2) {
                                selfInfo.QQId = snsAccount.usid;
                            }
                            [selfInfo save];
                            [weakSelf.tableView reloadData];
                        }
                    }];
                }
                else
                {
                    
                }
            });
        }
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        if ([[WRUserInfo selfInfo] isLogged]) {
            [Utility alertWithViewController:self.navigationController title:NSLocalizedString(@"是否要真的退出当前帐号", nil) buttonText:NSLocalizedString(@"退出", nil) completion:^{
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:WRLogOffNotification object:nil];
            }];
        }
    }
}

-(void)readyToBindPhone
{
    __weak __typeof(self) weakSelf = self;
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"输入新手机号码", nil) message:NSLocalizedString(@"", nil) preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypePhonePad;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = controller.textFields.firstObject;
        NSString *phone = textField.text;
        [weakSelf fetchSmsCode:phone];
    }];
    [controller addAction:cancelAction];
    [controller addAction:submitAction];
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)fetchSmsCode:(NSString*)phone
{
    [SVProgressHUD showWithStatus:@""];
    __weak __typeof(self) weakSelf = self;
    [WRViewModel requestSmsCodeWithPhone:phone type:@"bind" completion:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取验证码失败", nil) completion:^{
                [weakSelf fetchSmsCode:phone];
            }];
        }
        else
        {
            weakSelf.phone = phone;
            [weakSelf inputSmsCode];
        }
    }];
}

-(void)inputSmsCode {
    __weak __typeof(self) weakSelf = self;
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"输入验证码", nil) message:NSLocalizedString(@"", nil) preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypePhonePad;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = controller.textFields.firstObject;
        NSString *code = textField.text;
        [weakSelf requestForBindWithCode:code];
    }];
    [controller addAction:cancelAction];
    [controller addAction:submitAction];
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)requestForBindWithCode:(NSString*)code {
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:nil];
    [WRViewModel userBindPhone:self.phone code:code completion:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:error.domain completion:^{
                [weakSelf requestForBindWithCode:code];
            }];
        }
        else
        {
            [WRUserInfo selfInfo].phone = weakSelf.phone;
            [weakSelf.tableView reloadData];
        }
    }];
}

@end
