//
//  DataManager.h
//  alijk
//
//  Created by easy on 14/7/23.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetHttpClient;
@interface DataManager : NSObject

@property (nonatomic, strong) NetHttpClient *httpClient;

+(DataManager*)sharedManager;

/* 异步发送数据请求
 参数：
 adapterType: 获取数据的网络接口类型
 requestDTO: 网络接口需要的DTO，若没有为nil
 succeedBlock: 获取数据完成后需要执行的操作；responseDTO：网络返回附带的DTO
 failedBlock: 获取数据失败后需要执行的操作；responseDTO：网络返回附带的DTO
 
 返回值：
 网络请求的tag；需要取消该请求时会使用该tag
 */
-(NSNumber*)asyncRequestByType:(int)adapterType andObject:(id)requestDTO success:(Async_Block)succeedBlock failure:(Async_Block)failedBlock;

/* 取消数据请求
 参数：
 生成该请求时生成的requestTag
 
 返回值：
 YES/NO
 */
-(BOOL)cancelAsyncRequestByTag:(NSNumber*)requestTag;

@end
