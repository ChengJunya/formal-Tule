//
//  NetDownloadOperation.m
//  alijk
//
//  Created by easy on 10/19/14.
//  Copyright (c) 2014 zhongxin. All rights reserved.
//

#import "NetDownloadOperation.h"

@interface NetDownloadOperation ()
{
    BOOL _executing;
    BOOL _finished;
}

@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) DownloadCompletionBlock completionHandler;
@property (nonatomic, strong) NSURL *downloadURL;
@property (nonatomic, strong) NSURL *saveURL;

@end

@implementation NetDownloadOperation

- (id)initWithDownloadURL:(NSURL *)downloadURL
                toSaveURL:(NSURL *)saveURL
           sessionManager:(AFURLSessionManager *)manager
        completionHandler:(DownloadCompletionBlock)completionHandle
{
    if (self = [super init]) {
        self.sessionManager = manager;
        self.completionHandler = completionHandle;
        self.downloadURL = downloadURL;
        self.saveURL = saveURL;
    }
    
    return self;
}

- (void)done
{
    [self setExecuting:NO];
    [self setFinished:YES];
}


#pragma mark -
#pragma mark - NSOperarion

- (BOOL)isFinished
{
    return _finished;
}

- (BOOL)isExecuting
{
    return _executing;
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)main
{
    __weak typeof(self) weakSelf = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.downloadURL];
    NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return weakSelf.saveURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (weakSelf.completionHandler) {
            weakSelf.completionHandler(filePath, error);
        }
        [weakSelf done];
    }];
    
    [downloadTask resume];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
    if( [self isFinished] || [self isCancelled] ) { [self done]; return; }
    [self setExecuting:YES];
    
    [self main];
}

@end
