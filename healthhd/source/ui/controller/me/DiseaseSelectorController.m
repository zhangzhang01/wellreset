//
//  DiseaseSelectorController.m
//  rehab
//
//  Created by 何寻 on 8/5/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "DiseaseSelectorController.h"
#import "ShareUserData.h"

@interface DiseaseSelectorController ()
{
    NSMutableArray *_sectionArray;
    NSMutableArray *_allDiseaseArray;
    NSString *_rawUserDiseaseString;
}
@end

@implementation DiseaseSelectorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createBackBarButtonItem];
    
    self.title = NSLocalizedString(@"常见疾病史", nil);
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onClickedBarButtomItem:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onClickedBarButtomItem:)];

    
    _sectionArray = [NSMutableArray array];
    _allDiseaseArray = [NSMutableArray array];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    [[ShareUserData userData].commonDiseases enumerateObjectsUsingBlock:^(WRCommonDisease*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = [obj convertDictionary];
        WRCommonDisease *newObj = [[WRCommonDisease alloc] initWithDictionary:dict];
        [_allDiseaseArray addObject:newObj];
        
        if ([Utility IsEmptyString:obj.parentId] || [obj.parentId isEqualToString:@"0"])
        {
            [_sectionArray addObject:obj];
        }
        
        if ([obj isChoosen]) {
            [tempArray addObject:obj];
        }
    }];
    _rawUserDiseaseString = [tempArray componentsJoinedByString:@"-"];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate&dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    WRCommonDisease *disease = _sectionArray[section];
    return disease.name;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WRCommonDisease *disease = _sectionArray[section];
    __block NSInteger count = 0;
    [_allDiseaseArray enumerateObjectsUsingBlock:^(WRCommonDisease *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([disease.uuid isEqualToString:obj.parentId]) {
            count++;
        }
    }];
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WRCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:WRCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    WRCommonDisease *disease = [self getDiseaseWithIndexPath:indexPath];
    if (disease) {
        cell.textLabel.text = disease.name;
        cell.accessoryType = [disease isChoosen] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WRCommonDisease *disease = [self getDiseaseWithIndexPath:indexPath];
    if (disease) {
        BOOL flag = [disease isChoosen];
        [disease setChoose:!flag];
        [tableView reloadData];
    }
}

#pragma mark - Event
-(IBAction)onClickedBarButtomItem:(UIBarButtonItem*)sender
{
    if (sender == self.navigationItem.leftBarButtonItem) {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (sender == self.navigationItem.rightBarButtonItem) {
        [SVProgressHUD showWithStatus:nil];
        
        __weak __typeof(self) weakSelf = self;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        [_allDiseaseArray enumerateObjectsUsingBlock:^(WRCommonDisease*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isChoosen]) {
                [tempArray addObject:obj.uuid];
            }
        }];
        
        NSString *uuidString = [tempArray componentsJoinedByString:@"|"];
        [WRViewModel operationWithType:WROperationTypeUserCommonDisease indexId:uuidString flag:YES contentType:@"" completion:^(NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            if(error) {
                [Utility Alert:NSLocalizedString(@"保存失败", nil)];
            } else {
                [[ShareUserData userData].commonDiseases enumerateObjectsUsingBlock:^(WRCommonDisease*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setChoose:[tempArray containsObject:obj.uuid]];
                }];
                
                if (weakSelf.completion) {
                    weakSelf.completion();
                }
                [weakSelf.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

#pragma mark - 
-(WRCommonDisease*)getDiseaseWithIndexPath:(NSIndexPath*)indexPath
{
    WRCommonDisease *disease = _sectionArray[indexPath.section];
    NSInteger index = 0;
    for(NSUInteger i = 0; i < _allDiseaseArray.count; i++)
    {
        WRCommonDisease *obj = _allDiseaseArray[i];
        if ([disease.uuid isEqualToString:obj.parentId])
        {
            if (index == indexPath.row)
            {
                return obj;
            }
            index++;
        }
    }
    return nil;
}


@end
