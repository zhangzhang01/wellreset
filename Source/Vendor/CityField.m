//
//  CityField.m
//  Gofind
//
//  Created by shizaihao on 2016/11/17.
//  Copyright © 2016年 shizaihaoshizaihao. All rights reserved.
//
#import "CityField.h"
#import "Province.h"
#import "City.h"
#import "Area.h"
@interface CityField () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign) NSInteger selProvinceIndex;
@property (nonatomic, assign) NSInteger selCityIndex;
@property (nonatomic, assign) NSInteger selAreaIndex;
// 保存所有省模型
@property (nonatomic, strong) NSMutableArray *provinces;
@property UIPickerView* pickerView;
@end

@implementation CityField

- (NSMutableArray *)provinces
{
    if (_provinces == nil) {
        _provinces = [NSMutableArray array];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"provinces.plist" ofType:nil];
        // 加载字典数组
        NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *dict in dictArr) {
            Province *p = [Province provinceWithDict:dict];
            
            [_provinces addObject:p];
        }
        
    }
    
    return _provinces;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

// 初始化操作
- (void)setUp
{
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    self.pickerView = pickerView;
    // 自定义城市键盘
    self.inputView = pickerView;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 返回第component列有多少行
// 第0列: 省 第1列:当前第0列选中的省会的城市
// 第0列:有多少省模型就有多少行
// 第1列:看下当前选中省有多少个城市就有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) { // 省
        
        return self.provinces.count;
        
    }else if(component == 1){ // 当前第0列选中省的城市
        // 获取当前第0列选中哪个省
        Province *p = self.provinces[_selProvinceIndex];
        
        return p.city.count;
    }
    else
    {
        Province *p = self.provinces[_selProvinceIndex];
        City* c = p.city[_selCityIndex];
        return c.area.count;
    }
}

#pragma mark - UIPickerViewDelegate

// 返回每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) { // row:省
        
        Province *p = self.provinces[row];
        
        return p.name;
        
    }else if(component == 1){ // row:城市
        
        // 获取当前第0列选中哪个省
        Province *p = self.provinces[_selProvinceIndex];
        City* c = p.city[row];
        return c.name;
        
    }
    else
    {
        Province *p = self.provinces[_selProvinceIndex];
        City* c = p.city[_selCityIndex];
        Area* a = c.area[row];
        return a.name;
    }
}

// 用户选中某一行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) { // 滚动省
        // 记录当前选中的省(行)
        _selProvinceIndex = row;
        _selCityIndex = 0;
        _selAreaIndex = 0;
        // 刷新第12列
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    else if(component == 1)
    {// 刷新第2列
        _selCityIndex = row;
        _selAreaIndex = 0;
        [pickerView reloadComponent:2];
        
    }
    else
    {
        _selAreaIndex = row;
    }
    
    
    // 给文本框赋值
    
    // 获取当前第0列选中的省
    Province *p = self.provinces[_selProvinceIndex];
    
    // 省会名称
    NSString *pName = p.name;
    
    // 获取第1列选中的城市
    NSInteger cityIndex = _selCityIndex;
    
    // 获取城市名称
    City* c = p.city[cityIndex];
    NSString *cityName = c.name;
    NSInteger areaIndex = _selAreaIndex;
    Area* a = c.area[areaIndex];
    NSString *areaName = a.name;
    self.text = [NSString stringWithFormat:@"%@ %@ %@",pName,cityName,areaName];
    
    
}

// 初始化文本框文字
- (void)setUpText
{
    [self pickerView:_pickerView didSelectRow:_selProvinceIndex inComponent:0];
    
}

@end

