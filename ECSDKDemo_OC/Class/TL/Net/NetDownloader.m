//
//  NetDownloader.m
//  alijk
//
//  Created by easy on 10/19/14.
//  Copyright (c) 2014 zhongxin. All rights reserved.
//

#import "NetDownloader.h"


@interface NetDownloader ()

@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@property (nonatomic, strong) NSMutableDictionary *retryCountDict;

@end


@implementation NetDownloader

static NSInteger NETDOWNLOAD_MAX_RETRY_COUNT = 5;

#pragma mark-
#pragma mark shareManager

+ (NetDownloader*)sharedManager
{
    static NetDownloader *_shareDownloader = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareDownloader = [[NetDownloader alloc] init];
    });
    
    return _shareDownloader;
}


#pragma mark-
#pragma mark init

- (id)init
{
    NSURLSessionConfiguration *sessionConfig;
    NSString *sessionIdentifier = @"com.http.downloader.configuration";
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([NSURLSessionConfiguration resolveClassMethod:@selector(backgroundSessionConfigurationWithIdentifier:)]) {
        sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:sessionIdentifier];
    }
    else {
        sessionConfig = [NSURLSessionConfiguration backgroundSessionConfiguration:sessionIdentifier];
    }
#else
    sessionConfig = [NSURLSessionConfiguration backgroundSessionConfiguration:sessionIdentifier];
#endif
    
    if (self = [super initWithSessionConfiguration:sessionConfig]) {
        self.downloadQueue = [[NSOperationQueue alloc] init];
        self.downloadQueue.maxConcurrentOperationCount = 10;
        
        self.retryCountDict = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)download:(NSURL *)downloadURL
       toSaveURL:(NSURL *)saveURL
        progress:(NSProgress * __autoreleasing *)progress
completionHandler:(DownloadCompletionBlock)completionHandler
{
    if ([GNSFileManager fileExistsAtPath:[saveURL path]]) {
        completionHandler(saveURL, nil);
        return;
    }
    
    NSString *fileName = [saveURL lastPathComponent];
    if (![self.retryCountDict objectForKey:fileName]) {
        [self.retryCountDict setObject:@"0" forKey:fileName];
    }
    
    __weak typeof(self) weakSelf = self;
    NSOperation *operation = [[NetDownloadOperation alloc] initWithDownloadURL:downloadURL toSaveURL:saveURL sessionManager:self completionHandler:^(NSURL *filePath, NSError *error) {
        BOOL isDownFinish = YES;
        if (error) {
            NSInteger retryCount = [weakSelf.retryCountDict[fileName] integerValue];
            if (retryCount++ < NETDOWNLOAD_MAX_RETRY_COUNT) {
                isDownFinish = NO;
                [weakSelf.retryCountDict setObject:[NSNumber numberWithInteger:retryCount] forKey:fileName];
                [weakSelf download:downloadURL toSaveURL:saveURL progress:progress completionHandler:completionHandler];
            }
        }
        
        if (isDownFinish) {
            [weakSelf.retryCountDict removeObjectForKey:fileName];
            if (completionHandler) {
                completionHandler(filePath, error);
            }
        }
    }];
    [self.downloadQueue addOperation:operation];
}

@end
