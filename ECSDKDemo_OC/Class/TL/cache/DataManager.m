//
//  DataManager.m
//  alijk
//
//  Created by easy on 14/7/23.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "DataManager.h"
#import "NetHttpClient.h"
#import "NetRequestHelper.h"
#import "AddressDataHelper.h"
#import "UserDataHelper.h"
#import "TLHelper.h"

@interface DataManager ()

@property (nonatomic, strong) NSMutableDictionary *requestQueue;

@end



@implementation DataManager


#pragma mark-
#pragma mark shareManager

+(DataManager*)sharedManager
{
    static DataManager *_shareDMInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareDMInstance = [[DataManager alloc] init];
    });
    
    return _shareDMInstance;
}


#pragma mark-
#pragma mark init

-(id)init
{
    if (self = [super init])
    {
        self.requestQueue = [NSMutableDictionary dictionary];
        self.httpClient = [NetHttpClient sharedHTTPClient];
    }
    
    return self;
}

-(void)dealloc
{
    //
}

/* 登录成功后预加载一些数据
 */
- (void)preloadInfoWhenLogin
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
       
    });
}



#pragma mark-
#pragma mark get data

/* 异步发送数据请求
 参数：
 adapterType: 获取数据的网络接口类型
 requestDTO: 网络接口需要的DTO，若没有为nil
 succeedBlock: 获取数据完成后需要执行的操作；responseDTO：网络返回附带的DTO
 failedBlock: 获取数据失败后需要执行的操作；responseDTO：网络返回附带的DTO
 
 返回值：
 网络请求的tag；需要取消该请求时会使用该tag
 */
-(NSNumber*)asyncRequestByType:(int)adapterType andObject:(id)requestDTO success:(Async_Block)succeedBlock failure:(Async_Block)failedBlock
{
    
//    if (!GUserDataHelper.isLoginSucceed&&adapterType!=NetAdapter_User_Login) {
//        [RTLHelper autoLogin];
//        return 0;
//    }
    
    NSNumber *requestTag = [self generateRequestTag];
    
    NetRequestHelper *requestHelper = [[NetRequestHelper alloc] init];
    requestHelper.resuestTag = requestTag;
    requestHelper.succeedBlock = succeedBlock;
    requestHelper.failedBlock= failedBlock;
    [self.requestQueue setObject:requestHelper forKey:requestTag];
    
    [_httpClient requestByType:adapterType andObject:requestDTO requestHelper:requestHelper onCompletion:^(BOOL value) {
        // 移除队列中的helper对象
        [self.requestQueue removeObjectForKey:requestTag];
        
        // 执行成功
        if (value) {
            // 登录成功后需要执行的一些操作
            if (NetAdapter_User_Login == adapterType) {
                //[self preloadInfoWhenLogin];
            }
        }
        // 执行失败
        else {
            //
        }
    }];
    
    return requestTag;
}

/* 取消数据请求
 参数：
 生成该请求时生成的requestTag
 
 返回值：
 YES/NO
 */
-(BOOL)cancelAsyncRequestByTag:(NSNumber*)requestTag
{
    NetRequestHelper *request =[self.requestQueue objectForKey:requestTag];
    if (request) {
        [_httpClient cancelTask:request.task];
        return YES;
    }
    
    return NO;
}


#pragma mark-
#pragma mark tools

- (NSNumber*)generateRequestTag{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    return [NSNumber numberWithDouble:timeInterval];
}

@end
