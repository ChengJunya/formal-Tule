//
//  NetUploader.m
//  alijk
//
//  Created by easy on 14-10-11.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "NetUploader.h"

@interface AFURLSessionManager (SuperPrivate) //类别 SuperPrivate 类别的名称

//类别的方法
- (void)addDelegateForUploadTask:(NSURLSessionUploadTask *)uploadTask
                        progress:(NSProgress * __autoreleasing *)progress
               completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;
@end


@interface NetUploader () <NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURL *baseURL;                       //网络请求url
@property (nonatomic, strong) NSMutableArray *upPrepareQueue;       //准备队列
@property (nonatomic, strong) NSMutableArray *upProcessingQueue;    //处理队列

@end


@implementation NetUploader

static CGFloat NETUPLOAD_OPERATION_TIMEOUT = 120.f; //上传请求超时时间
static NSInteger NETUPLOAD_MAX_OPERATION_COUNT = 2; //上传最大操作数量

//处理上传任务的操作队列 移步创建
static dispatch_queue_t net_uploader_processing_task() {
    static dispatch_queue_t _net_uploader_processing_task;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _net_uploader_processing_task = dispatch_queue_create("com.httpclient.uploader.processing.task", DISPATCH_QUEUE_SERIAL);
    });
    
    return _net_uploader_processing_task;
}
//上传处理操作队列
static dispatch_queue_t net_uploader_processing_queue() {
    static dispatch_queue_t _net_uploader_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _net_uploader_processing_queue = dispatch_queue_create("com.httpclient.uploader.processing.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return _net_uploader_processing_queue;
}

#pragma mark -
#pragma mark - init

- (id)initWithBaseURL:(NSURL*)url
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = NETUPLOAD_OPERATION_TIMEOUT;
    sessionConfig.timeoutIntervalForResource = NETUPLOAD_OPERATION_TIMEOUT;
    
    if (self = [super initWithSessionConfiguration:sessionConfig]) {
        if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
            url = [url URLByAppendingPathComponent:@""];
        }
        self.baseURL = url;
        
        self.upPrepareQueue = [NSMutableArray array];
        self.upProcessingQueue = [NSMutableArray array];
        
        self.operationQueue.maxConcurrentOperationCount = 5;
    }
    
    return self;
}


#pragma mark - 
#pragma mark - upload

- (NSURLSessionUploadTask*)upload:(NSString *)URLString
                         fromData:(NSData *)bodyData
                         progress:(NSProgress * __autoreleasing *)progress
                completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    NSString *url = [[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    
    __block NSURLSessionUploadTask *uploadTask = nil;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        uploadTask = [self.session uploadTaskWithRequest:request fromData:bodyData];
    });
    
    /*
    SEL selector = @selector(addDelegateForUploadTask:progress:completionHandler:);
    if ([self respondsToSelector:selector]) {
        IMP method = [super methodForSelector:selector];
        method(self, selector, uploadTask, progress, completionHandler);
    }
     */
    [self addDelegateForUploadTask:uploadTask progress:progress completionHandler:completionHandler];
    
    [self addTaskToQueue:uploadTask];
    
    
    return uploadTask;
}

- (void)addTaskToQueue:(NSURLSessionUploadTask*)task
{
    dispatch_sync(net_uploader_processing_task(), ^{
        if ([self.upProcessingQueue count] < NETUPLOAD_MAX_OPERATION_COUNT) {
            [self.upProcessingQueue addObject:task];
            dispatch_async(net_uploader_processing_queue(), ^{
                [task resume];
                ZXLog(@"processing task: %@", task);
            });
        }
        else {
            [self.upPrepareQueue addObject:task];
        }
    });
}

- (void)processTask:(NSURLSessionTask*)task
{
    dispatch_sync(net_uploader_processing_task(), ^{
        [self.upProcessingQueue removeObject:task];
        
        if ([self.upPrepareQueue count] > 0 && [self.upProcessingQueue count] < NETUPLOAD_MAX_OPERATION_COUNT) {
            NSURLSessionTask *newTask = self.upPrepareQueue[0];
            [self.upPrepareQueue removeObject:newTask];
            
            [self.upProcessingQueue addObject:newTask];
            dispatch_async(net_uploader_processing_queue(), ^{
                [newTask resume];
                ZXLog(@"processing task: %@", newTask);
            });
        }
    });
}


#pragma mark -
#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    [self processTask:task];
    [super URLSession:session task:task didCompleteWithError:error];
}

@end
