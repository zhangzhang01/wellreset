//
//  DownloadMusicViewModel.m
//  rehab
//
//  Created by yefangyang on 2016/10/25.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "DownloadMusicViewModel.h"
#import "SSZipArchive.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface DownloadMusicViewModel()<SSZipArchiveDelegate>

@end

@implementation DownloadMusicViewModel

-(instancetype)init {
    if (self = [super init]) {
        NSString *strUrl = [WRNetworkService getFormatURLString:urlBgMusic];
        self.requestUrlString = strUrl;
//#if DEBUG
//        self.requestUrlString = @"http://192.168.1.217/download/bgmusic.json";
//#endif
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"musicData"];
        if (dict) {
            [self initFromDict:dict];
        }
    }
    return self;
}

#pragma mark -
-(void)initFromDict:(NSDictionary*)dic
{
    self.url = dic[@"url"];
    self.version = dic[@"version"];
    NSArray *array = dic[@"music"];
    NSMutableArray *dataArray = [NSMutableArray array];
    for(NSDictionary *obj in array)
    {
        WRMusic *object = [[WRMusic alloc] initWithDictionary:obj];
        [dataArray addObject:object];
    }
    self.musicArray = dataArray;
}

- (void)fetchDownloadDataWithCompletion:(void (^)(NSError *))completion
{
    __weak __typeof(self)weakself = self;
    NSString *strUrl = self.requestUrlString;
    
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        do {
            if(error)
            {
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:parser.resultObject forKey:@"musicData"];
            [weakself initFromDict:parser.resultObject];
            
            if (![Utility IsEmptyString:weakself.url]) {
                [weakself downloadPacketWithCompletion:completion];
                return;
            }
            
        } while (NO);
        if (completion)
        {
            completion(error);
        }
    }];
}


#pragma mark - download
- (void)downloadPacketWithCompletion:(void (^)(NSError *))completion
{
    NSURL *URL = [NSURL URLWithString:self.url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // 下载进度
        [SVProgressHUD showProgress:(float)(downloadProgress.completedUnitCount)/downloadProgress.totalUnitCount
                             status:NSLocalizedString(@"正在下载音乐包", nil)];
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        NSString *filePathString = [filePath path];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        [self releaseZipFilesWithUnzipFileAtPath:filePathString Destination:docDir completion:completion];
    }];
    [downloadTask resume];
}

// 解压
- (void)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath Destination:(NSString *)unzipPath completion:(void (^)(NSError *))completion{
    NSError *error;
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil error:&error delegate:self]) {
        [SVProgressHUD dismiss];
        [[NSUserDefaults standardUserDefaults] setObject:self.requestUrlString forKey:@"bgMusicUrl"];
        if (completion) {
            completion(nil);
        }
    }else {
        if (completion) {
            completion(error);
        }
        NSLog(@"%@",error);
    }
}

#pragma mark - SSZipArchiveDelegate
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo {
    NSLog(@"将要解压。");
    [SVProgressHUD show];
}
/*
- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath unzippedFilePath:(NSString *)unzippedFilePath{
    NSLog(@"%@ %@",archivePath,unzippedFilePath);
}

- (BOOL)zipArchiveShouldUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo
{
    NSLog(@"%d %d %@",(int)fileIndex,(int)totalFiles,archivePath);
    return YES;
}
*/

#pragma mark - public
-(BOOL)needReload
{
    NSString *bgMusicUrlString = self.requestUrlString;
    BOOL shouldDownload = NO;
    if (![Utility IsEmptyString:bgMusicUrlString])
    {
        shouldDownload = YES;
        NSString *remotePath = bgMusicUrlString;
        //remotePath = [remotePath stringByAppendingString:@"hh"];
        NSString *localBgMusicFile = [[NSUserDefaults standardUserDefaults] objectForKey:@"bgMusicUrl"];
        if (localBgMusicFile && [localBgMusicFile isEqualToString:remotePath]) {
            shouldDownload = NO;
        }
    }
    return shouldDownload;
}

@end
