//
//  WRCitySelector.m
//  rehab
//
//  Created by Matech on 3/16/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRCitySelectorView.h"
#import "WRLocationHelper.h"

@implementation WRLocation

@end

@interface WRCitySelectorView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *provinces;
    NSArray	*cities;
}
@property(nonatomic, copy) NSString *locateState, *locateCity;
@property(nonatomic, weak) UIButton *locateButton;
@property(nonatomic, weak) UILabel *locateLabel;

@end

@implementation WRCitySelectorView

-(instancetype)initWithCustomView:(UIView *)view {
    if (self = [super initWithCustomView:view]) {

        CGFloat x, y, cx = 0, cy = 0;
        UIView *panel = self.leftButton.superview;
        
        UIButton *button = [UIButton wr_lineBorderButtonWithTitle:NSLocalizedString(@"使用定位", nil)];

        cx = self.leftButton.frame.size.width*2;
        x = (self.leftButton.superview.bounds.size.width - cx)/2;
        cy = self.leftButton.frame.size.height;
        y = self.leftButton.frame.origin.y;
        button.frame = CGRectMake(x, y, cx, cy);
        [button addTarget:self action:@selector(onClickedLocateButton:) forControlEvents:UIControlEventTouchUpInside];
        [panel addSubview:button];
        _locateButton = button;
        
        x = self.leftButton.origin.x;
        y = CGRectGetMaxY(self.leftButton.frame) + 5;
        cx = CGRectGetMaxX(self.rightButton.frame) - CGRectGetMinX(self.leftButton.frame);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        label.text = NSLocalizedString(@"正在定位...", nil);;
        label.font = [UIFont wr_textFont];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        [label sizeToFit];
        label.frame = [Utility resizeRect:label.frame cx:cx height:label.frame.size.height];
        [panel addSubview:label];
        self.locateLabel = label;
        
        //y = CGRectGetMaxY(label.frame) + offset;

        provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvincesAndCities.plist" ofType:nil]];
        cities = [[provinces objectAtIndex:0] objectForKey:@"Cities"];
        
        //初始化默认数据
        self.locate = [[WRLocation alloc] init];
        self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"State"];
        self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
        self.locate.latitude = [[[cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
        self.locate.longitude = [[[cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
        
        __weak __typeof(self) weakSelf = self;
        __weak __typeof(WRLocationHelper*) weakLocationHelper = [WRLocationHelper defaultSerivce];
        weakLocationHelper.completion = ^(NSError *error){
            if (error) {
                weakSelf.locateLabel.text = [NSString stringWithFormat:@"定位失败"];
            } else {
                weakSelf.locateState = weakLocationHelper.currentState;
                weakSelf.locateCity = weakLocationHelper.currentCity;
                weakSelf.locateLabel.text = [NSString stringWithFormat:@"当前位置:%@ %@", weakSelf.locateState, weakSelf.locateCity];
            }
        };
        [[WRLocationHelper defaultSerivce] locate];
    }
    return self;
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[provinces objectAtIndex:row] objectForKey:@"State"];
            break;
        case 1:
            return [[cities objectAtIndex:row] objectForKey:@"city"];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            cities = [[provinces objectAtIndex:row] objectForKey:@"Cities"];
            [pickerView selectRow:0 inComponent:1 animated:NO];
            [pickerView reloadComponent:1];
            
            self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"State"];
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            self.locate.latitude = [[[cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
            self.locate.longitude = [[[cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
            break;
        case 1:
            self.locate.city = [[cities objectAtIndex:row] objectForKey:@"city"];
            self.locate.latitude = [[[cities objectAtIndex:row] objectForKey:@"lat"] doubleValue];
            self.locate.longitude = [[[cities objectAtIndex:row] objectForKey:@"lon"] doubleValue];
            break;
        default:
            break;
    }
}

#pragma mark -
-(IBAction)onClickedLocateButton:(UIButton*)sender {
    self.locate.city = self.locateCity;
    self.locate.state = self.locateState;
    if(self.completion)
    {
        self.completion();
    }
    [self dismiss];
}

#pragma mark -
+ (void)showWithCompletion:(void (^)(WRLocation* location))completion {
    CGRect frame = [UIScreen mainScreen].bounds;
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 30, 250)];
    WRCitySelectorView* sheet = [[[self class] alloc] initWithCustomView:picker];
    picker.delegate = sheet;
    picker.dataSource = sheet;
    __weak WRCitySelectorView *weakSelf = sheet;
    sheet.completion = ^() {
        if (completion) {
            completion(weakSelf.locate);
        }
    };
    [sheet show];
}

@end
