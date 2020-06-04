//
//  ViewController.m
//  MCDownloadManager
//
//  Created by 马超 on 16/9/5.
//  Copyright © 2016年 qikeyun. All rights reserved.
//

#import "WRDownlistController.h"
#import "TableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MCDownloader.h"
#import "WRDownloadArray.h"
#import "RehabObject.h"


@interface WRDownlistController () <TableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;



@property (strong, nonatomic) NSMutableArray *urls;
@property NSMutableArray* dataarr;
@end

@implementation WRDownlistController

- (NSMutableArray *)urls
{
    if (!_urls) {
        self.urls = [NSMutableArray array];
        for (int i = 1; i<=10; i++) {
            [self.urls addObject:[NSString stringWithFormat:@"http://120.25.226.186:32812/resources/videos/minion_%02d.mp4", i]];

//       [self.urls addObject:@"http://localhost/MJDownload-master.zip"];
        }
    }
    return _urls;
}
-  (instancetype)init
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"downlist"];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createBackBarButtonItem];
    self.title = @"下载管理";

    
    self.view.backgroundColor = [UIColor whiteColor];

}
-(void)viewDidAppear:(BOOL)animated
{
    NSMutableArray* listarr = [[NSUserDefaults standardUserDefaults]objectForKey:@"downlist"];
    self.dataarr = [NSMutableArray arrayWithArray:listarr] ;
    if (listarr) {
        WRDownloadArray* ARR = [WRDownloadArray sharedDownloadArray];
        for (NSString* str in listarr) {
            WRDownRehab * dr = [[WRDownRehab alloc]initWithDictionary:[str jsonValueDecoded]];
            int i = 0;
            for (WRDownRehab * dra in ARR) {
                if ([dr.indexid isEqualToString:dra.indexid]) {
                    i++;
                }
            }
            if (i==0) {
               [ARR addObject:dr ];
            }


        }
    }
    [self.tableView reloadData ];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [WRDownloadArray sharedDownloadArray].count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.rehab = [WRDownloadArray sharedDownloadArray][indexPath.row];
    cell.delegate = self;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    WRDownRehab* rehab = [WRDownloadArray sharedDownloadArray][indexPath.row];
//    NSMutableArray* arr = [[NSUserDefaults standardUserDefaults]objectForKey:rehab.indexid];
    return [WRDownloadArray sharedDownloadArray].count!=0;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WRDownRehab* rehab = [WRDownloadArray sharedDownloadArray][indexPath.row];
        NSMutableArray* arr = [[NSUserDefaults standardUserDefaults]objectForKey:rehab.indexid];
        for (NSString* url in arr) {
            NSString *imageDir = [NSString stringWithFormat:@"%@",url];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:imageDir error:nil];
        }
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:rehab.indexid];
        NSMutableArray* listarr =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"downlist"]];
        [[WRDownloadArray sharedDownloadArray]removeObject:rehab];
        
        for (NSString * url in rehab.downlist) {
            MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:url];
            [[MCDownloader sharedDownloader] remove:receipt completed:^{
                
            }];
        }
        
        [self.tableView deleteRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
        [self.dataarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj rangeOfString:rehab.title].length>0) {
                if ([self.dataarr containsObject:obj]) {
                    [self.dataarr removeObject:obj];
                    [[NSUserDefaults standardUserDefaults]setObject:self.dataarr forKey:@"downlist"];
                }
                
                
            }
        }];
        
        
        [AppDelegate show:@"成功删除本地视频"];
    }
}

- (IBAction)nextAction:(UIBarButtonItem *)sender {
    
    
  
    NSArray *urls = [self urls];
    
    if ([sender.title isEqualToString:@"Start"]) {
        
        sender.enabled = NO;
        
        for (NSString *url in urls) {
            [[MCDownloader sharedDownloader] downloadDataWithURL:[NSURL URLWithString:url] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
                
            } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
                NSLog(@"==%@", error.description);
            }];

        }
        
        sender.enabled = YES;
        sender.title = @"Stop";
    } else {
        
        sender.enabled = NO;
        
        [[MCDownloader sharedDownloader] cancelAllDownloads];
        
        sender.enabled = YES;
        sender.title = @"Start";
    }
   [self.tableView reloadData];
}


- (void)cell:(TableViewCell *)cell didClickedBtn:(UIButton *)btn {
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:cell.url];
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    MPMoviePlayerViewController *mpc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:receipt.filePath]];
    [vc presentViewController:mpc animated:YES completion:nil];
}


@end
