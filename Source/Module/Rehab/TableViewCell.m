//
//  TableViewCell.m
//  MCDownloadManager
//
//  Created by 马超 on 16/9/6.
//  Copyright © 2016年 qikeyun. All rights reserved.
//

#import "TableViewCell.h"
#import "MCDownloader.h"

@interface TableViewCell ()<UIScrollViewDelegate,UIAlertViewDelegate>
{
    //    UIScrollView *_scrollView;
    
    long _re;
    long _ex;
}
@end
@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 4.0f);
    self.progressView.transform = transform;
    self.progressView.layer.cornerRadius = 2;
    self.progressView.layer.masksToBounds =YES;
    self.button.clipsToBounds = YES;
    self.button.layer.cornerRadius = 10;
    self.button.layer.borderWidth = 1;
    self.button.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.button.clickDurationTime = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRehab:(WRDownRehab *)rehab {
    _rehab = rehab;
    
    
    NSMutableArray* arr = [NSMutableArray array];
    for (NSString* url in _rehab.downlist) {
        MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:url];
        [arr addObject:receipt];
    }
    
//    NSLog(@"%@", receipt.filePath);
    self.nameLabel.text = rehab.title;
    self.speedLable.text = nil;
    self.bytesLable.text = nil;
    self.progressView.progress = 0;
    
//    self.progressView.progress = receipt.progress.fractionCompleted;
    
//    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:receipt.filePath]];
    
//    if (receipt.state == MCDownloadStateDownloading || receipt.state == MCDownloadStateWillResume) {
//        [self.button setTitle:@"Stop" forState:UIControlStateNormal];
//    }else if (receipt.state == MCDownloadStateCompleted) {
//         [self.button setTitle:@"Play" forState:UIControlStateNormal];
//        self.nameLabel.text = @"Download Finished";
//    }else {
//         [self.button setTitle:@"Start" forState:UIControlStateNormal];
//    }
    int i = 0;

    for (MCDownloadReceipt* receipt in arr) {
        
        
        __weak typeof(receipt) weakReceipt = receipt;
        receipt.downloaderProgressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
            __strong typeof(weakReceipt) strongReceipt = weakReceipt;
//            _re += receivedSize;
            
            _ex = _rehab.size;
            NSLog(@"%ld/%ld %.1f %ld/s",_re,_ex, _re*200.0/_ex , speed);
            _re = 0;
            for (MCDownloadReceipt* receipt in arr) {
                _re+=[self fileSizeAtPath:receipt.filePath];
                
                NSLog(@"%ld",_re);
                NSLog(@"%ld",_ex);
            }
            
                
                
            self.bytesLable.text = [NSString stringWithFormat:@"%.0lf%%",_re*100.0/_ex>100?100:_re*100.0/_ex];
            self.progressView.progress = _re*100.0/_ex>100?100:_re*100.0/_ex*1.0/100;
            self.speedLable.text = [NSString stringWithFormat:@"%.1lf/%.1lfMB",_re*1.0/1024/1024,_ex*1.0/1024/1024];
            
            
        };
        
        receipt.downloaderCompletedBlock = ^(MCDownloadReceipt *receipt, NSError * _Nullable error, BOOL finished) {
            
            self.speedLable.text = @"已完成";
            self.bytesLable.text = @"100%";
            self.progressView.progress = 1;
        };
        
        
        
        if (receipt.state == MCDownloadStateCompleted) {
           i++;
        }
        
    }
    MCDownloadReceipt* receipt = [[MCDownloader sharedDownloader]downloadReceiptForURLString:_rehab.downlist[0]];
    if (receipt.state == MCDownloadStateNone||i==arr.count) {
        self.speedLable.text = @"已完成";
        self.bytesLable.text = @"100%";
        self.progressView.progress = 1;
    }
    
    


}
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (IBAction)buttonAction:(UIButton *)sender {
    
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:self.url];
    if (receipt.state == MCDownloadStateDownloading) {
        
        [[MCDownloader sharedDownloader] cancel:receipt completed:^{
            [self.button setTitle:@"Start" forState:UIControlStateNormal];
        }];
    }else if (receipt.state == MCDownloadStateCompleted) {

        if ([self.delegate respondsToSelector:@selector(cell:didClickedBtn:)]) {
            [self.delegate cell:self didClickedBtn:sender];
        }
    }else {
        [self.button setTitle:@"Stop" forState:UIControlStateNormal];
        [self download];
    }

}

- (void)download {
    
    [[MCDownloader sharedDownloader] downloadDataWithURL:[NSURL URLWithString:self.url] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {

    } completed:^(MCDownloadReceipt *receipt, NSError * _Nullable error, BOOL finished) {
        NSLog(@"==%@", error.description);
    }];
   

}
@end
