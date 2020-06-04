//
//  Utility.m
//  UTVgo
//
//  Created by wen on 13-3-29.
//  Copyright (c) 2013年 UTVGO. All rights reserved.
//

#import "Utility.h"
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>
#import <sys/utsname.h>
#import <AudioToolbox/AudioToolbox.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

static CGFloat edgeSizeFromCornerRadius(CGFloat cornerRadius) {
    return cornerRadius * 2 + 1;
}

static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}

@implementation Utility

#pragma mark - String
+(NSString *)MD5Encrypt:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString *)URLEncode:(NSString *)src
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[src UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

#pragma mark - Check
+(BOOL)IsEmptyString:(NSString *)string
{
    return string == nil || string.length == 0;
}

+(BOOL)IsString:(NSString *)string
{
    BOOL bResult = NO;
    do {
        if(!string)
            break;
        
        if([string isKindOfClass:[NSString class]])
        {
            if(string.length > 0)
            {
                bResult = YES;
                break;
            }
        }
    } while (NO);
    return bResult;
}

+ (BOOL)ValidateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSUInteger length = 0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length != 15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)]; // 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

+(NSURL *)ValidateUrl:(NSString *)strURL
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    result = nil;
    
    if(strURL)
    {
        trimmedStr = [strURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ( (trimmedStr != nil) && (trimmedStr.length != 0) )
        {
            schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
            
            if (schemeMarkerRange.location == NSNotFound)
            {
                //result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
            }
            else
            {
                scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
                assert(scheme != nil);
                
                if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                    || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) )
                {
                    result = [NSURL URLWithString:trimmedStr];
                }
                else
                {
                    // It looks like this is some unsupported URL scheme.
                }
            }
        }
    }
    return result;
}

+(BOOL)validateString:(NSString*)value regEx:(NSString*)regEx
{
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regEx];
    return [test evaluateWithObject:value];
}

+ (BOOL) ValidateEmail:(NSString *)email
{
    return [Utility validateString:email regEx:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

+ (BOOL) ValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //return [Utility validateString:mobile regEx:@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"];
    return [Utility validateString:mobile regEx:@"[1][34578]\\d{9}"];
}

+(BOOL)ValidateSmsCode:(NSString *)value
{
    return [Utility validateString:value regEx:@"^\\d{6}$"];
}

+(BOOL)ValidatePassword:(NSString *)value
{
    return [Utility validateString:value regEx:@"^[0-9A-Za-z]{4,16}$"];
}

+(BOOL)ValidateAccount:(NSString *)value
{
    return [Utility validateString:value regEx:@"^[A-z][A-Za-z0-9]{5,11}$"];
}

#pragma mark - Device
+(BOOL)IsMute
{
    /*
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    if(CFStringGetLength(state) > 0) {
        return NO;
    }
    return  YES;
     */
    return NO;
}

+(BOOL)CheckDeviceModel:(NSString *)model
{
    NSString* deviceType = [UIDevice currentDevice].model;
    NSRange range = [deviceType rangeOfString:model];
    return range.location != NSNotFound;
}

+(NSString *)GetCurrentDeviceName
{
    /*
     @"i386"      on the simulator
     @"iPod1,1"   on iPod Touch
     @"iPod2,1"   on iPod Touch Second Generation
     @"iPod3,1"   on iPod Touch Third Generation
     @"iPod4,1"   on iPod Touch Fourth Generation
     @"iPod5,1"   on iPod Touch Fifth Generation
     @"iPhone1,1" on iPhone
     @"iPhone1,2" on iPhone 3G
     @"iPhone2,1" on iPhone 3GS
     @"iPad1,1"   on iPad
     @"iPad2,1"   on iPad 2
     @"iPad3,1"   on 3rd Generation iPad
     @"iPad3,2":  on iPad 3(GSM+CDMA)
     @"iPad3,3":  on iPad 3(GSM)
     @"iPad3,4":  on iPad 4(WiFi)
     @"iPad3,5":  on iPad 4(GSM)
     @"iPad3,6":  on iPad 4(GSM+CDMA)
     @"iPhone3,1" on iPhone 4
     @"iPhone4,1" on iPhone 4S
     @"iPhone5,1" on iPhone 5
     @"iPad3,4"   on 4th Generation iPad
     @"iPad2,5"   on iPad Mini
     @"iPhone5,1" on iPhone 5(GSM)
     @"iPhone5,2" on iPhone 5(GSM+CDMA)
     @"iPhone5,3  on iPhone 5c(GSM)
     @"iPhone5,4" on iPhone 5c(GSM+CDMA)
     @"iPhone6,1" on iPhone 5s(GSM)
     @"iPhone6,2" on iPhone 5s(GSM+CDMA)
     */
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *result = [NSString stringWithCString:systemInfo.machine
                                          encoding:NSUTF8StringEncoding];
    
    NSDictionary *deviceNameData = @{
                                     @"i386":@"simulator",
                                     @"x86_64":@"simulator",
                                     @"iPod1,1":@"iPod Touch",
                                     @"iPod2,1":@"iPod Touch Second Generation",
                                     @"iPod3,1":@"iPod Touch Third Generation",
                                     @"iPod4,1":@"iPod Touch Fourth Generation",
                                     @"iPod5,1":@"iPod Touch Fifth Generation",
                                     @"iPhone1,1":@"iPhone",
                                     @"iPhone1,2":@"iPhone 3G",
                                     @"iPhone2,1":@"iPhone 3GS",
                                     @"iPad1,1":@"iPad",
                                     @"iPad2,1":@"iPad 2",
                                     @"iPad3,1":@"3rd Generation iPad",
                                     @"iPad3,2":@"iPad 3(GSM+CDMA)",
                                     @"iPad3,3":@"iPad 3(GSM)",
                                     @"iPad3,4":@"iPad 4(WiFi)",
                                     @"iPad3,5":@"iPad 4(GSM)",
                                     @"iPad3,6":@"iPad 4(GSM+CDMA)",
                                     @"iPad4,1":@"iPad Air (A1474)",
                                     @"iPad4,2":@"iPad Air (A1475)",
                                     @"iPad4,3":@"iPad Air (A1476)",
                                     @"iPad4,4":@"iPad Mini 2G (A1489)",
                                     @"iPad4,5":@"iPad Mini 2G (A1490)",
                                     @"iPad4,6":@"iPad Mini 2G (A1491)",
                                     @"iPhone3,1":@"iPhone 4",
                                     @"iPhone4,1":@"iPhone 4S",
                                     @"iPhone5,1":@"iPhone 5",
                                     @"iPad2,5":@"iPad Mini",
                                     @"iPhone5,1":@"iPhone 5(GSM)",
                                     @"iPhone5,2":@"iPhone 5(GSM+CDMA)",
                                     @"iPhone5,3":@"iPhone 5c(GSM)",
                                     @"iPhone5,4":@"iPhone 5c(GSM+CDMA)",
                                     @"iPhone6,1":@"iPhone 5s(GSM)",
                                     @"iPhone6,2":@"iPhone 5s(GSM+CDMA)",
                                     @"iPhone7,1":@"iPhone 6 Plus (A1522/A1524)",
                                     @"iPhone7,2":@"iPhone 6 (A1549/A1586)"
                                     };
    result = [deviceNameData objectForKey:result];
    return result;
}

+ (NSString *)GetLocalIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return address;
}

#pragma mark - UIView Utility
+(void)Alert:(NSString*)text
{
    [Utility Alert:text title:nil];
}

+(void)Alert:(NSString *)text title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
	[alert show];
}

+(void)alertWithViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
    [viewController presentViewController:controller animated:YES completion:nil];
}

+(void)alertWithViewController:(UIViewController *)viewController title:(NSString *)title {
    [Utility alertWithViewController:viewController title:title message:nil];
}

+(void)messageBoxWithViewController:(UIViewController *)viewController title:(NSString *)title  completion:(void (^)())completion {
    [Utility alertWithViewController:viewController title:title buttonText:NULL completion:completion];
}

+(void)alertWithViewController:(UIViewController *)viewController title:(NSString *)title buttonText:(NSString*)buttonText completion:(void (^)())completion {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    if ([Utility IsEmptyString:buttonText]) {
        buttonText = NSLocalizedString(@"确定", nil);
    }
    [controller addAction:[UIAlertAction actionWithTitle:buttonText style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    [viewController presentViewController:controller animated:YES completion:nil];
}

+(void)retryAlertWithViewController:(UIViewController *)viewController title:(NSString *)title completion:(void (^)())completion {
    [Utility alertWithViewController:viewController title:title buttonText:NSLocalizedString(@"重试", nil) completion:completion];
}


+(void)showToast:(NSString*)text position:(ToastPosition)position
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UILabel* label = [UILabel new];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    label.textColor = [UIColor whiteColor];
    label.alpha = 0;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5;
    label.font = [UIFont wr_smallFont];
    CGFloat x = 5;
    CGSize size = [label sizeThatFits:CGSizeMake((window.bounds.size.width - 2*x)/2, CGFLOAT_MAX)];
    x = (window.bounds.size.width - size.width)/2;
    CGFloat y;
    switch (position) {
        case ToastPositionTop: {
            y = 5;
            break;
        }
        case ToastPositionCenter: {
            y = (window.bounds.size.height - size.height)/2;
            break;
        }
        case ToastPositionBottom: {
            y = (window.bounds.size.height - size.height - 20);
            break;
        }
    }
    label.frame = CGRectMake(x, y, size.width, size.height);
    
    [[self class] viewAddToSuperViewWithAnimation:label superView:window completion:^{
        [[self class] removeFromSuperViewWithAnimation:label completion:nil];
    }];
}

+(UIViewController *)getSelfViewController:(UIView *)view
{
    for (UIView* next = [view superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

+(void)viewAddToSuperViewWithAnimation:(UIView *)view superView:(UIView *)superView completion:(void (^)())completion
{
    view.alpha = 0;
    [superView addSubview:view];
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = 1;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

+(void)removeFromSuperViewWithAnimation:(UIView *)view completion:(void (^)())completion
{
    view.alpha = 1;
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

+(void)showInTop:(UIView *)view
{
    [[self class] viewAddToSuperViewWithAnimation:view superView:[UIApplication sharedApplication].keyWindow completion:nil];
}

+(CGRect)CenterRect:(CGPoint)point srcSize:(CGSize)srcSize parentSize:(CGSize)parentSize
{
    CGFloat x = point.x + (parentSize.width - srcSize.width)/2;
    CGFloat y = point.y + (parentSize.height - srcSize.height)/2;
    return CGRectMake(x, y, srcSize.width, srcSize.height);
}


+(void)HideKeybord
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark - UI Utility
+(NSUInteger)GetBestRowCount:(CGFloat)width minCx:(CGFloat)minCx maxCx:(CGFloat)maxCx
{
    NSUInteger rowItemCount = 0;
    CGFloat minValue = (width - maxCx)/(2*maxCx);
    CGFloat maxValue = (width - minCx)/(minCx + maxCx);
    rowItemCount = MAX(ceil(minValue), floor(maxValue));
    return rowItemCount;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    return [[self class] createImageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

+(UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    CGFloat minEdgeSize = edgeSizeFromCornerRadius(cornerRadius);
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (UIColor *)ColorFromHexCode:(NSString *)hexString
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(UIColor *)ColorWithRGB:(NSUInteger)r g:(NSUInteger)g b:(NSUInteger)b
{
    return [UIColor colorWithRed:(CGFloat)(r/255.f) green:(CGFloat)(g/255.f) blue:(CGFloat)(b/255.f) alpha:1.0];
}

+(UIColor *)ColorWithRGBA:(NSUInteger)r g:(NSUInteger)g b:(NSUInteger)b alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(CGFloat)(r/255.f) green:(CGFloat)(g/255.f) blue:(CGFloat)(b/255.f) alpha:alpha];
}

+(CGRect)moveRect:(CGRect)src x:(CGFloat)x y:(CGFloat)y {
    if (x < 0) {
        x = src.origin.x;
    }
    if (y < 0) {
        y = src.origin.y;
    }
    return CGRectMake(x, y, src.size.width, src.size.height);
}

+(CGRect)resizeRect:(CGRect)src cx:(CGFloat)cx height:(CGFloat)cy {
    if (cx < 0) {
        cx = src.size.width;
    }
    if (cy < 0) {
        cy = src.size.height;
    }
    return CGRectMake(src.origin.x, src.origin.y, cx, cy);
}

+(NSString *)formatTimeSeconds:(NSInteger)seconds
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (seconds/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    return [formatter stringFromDate:d];
}

+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}


+(UIColor*)mostColor:(UIImage*)image{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(40, 40);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    UIColor *color = nil;
    if (data)
    {
        NSArray *MaxColor=nil;
        // NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
        float maxScore=0;
        for (int x=0; x<thumbSize.width*thumbSize.height; x++) {
            
            
            int offset = 4*x;
            
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            
            if (alpha<25)continue;
            
            float h,s,v;
            RGBtoHSV(red, green, blue, &h, &s, &v);
            
            float y = MIN(abs(red*2104+green*4130+blue*802+4096+131072)>>13, 235);
            y= (y-16)/(235-16);
            if (y>0.9) continue;
            
            float score = (s+0.1)*x;
            if (score>maxScore) {
                maxScore = score;
            }
            MaxColor=@[@(red),@(green),@(blue),@(alpha)];
            //[cls addObject:clr];
        }
        color = [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
    }
    CGContextRelease(context);
    return color;
}
@end