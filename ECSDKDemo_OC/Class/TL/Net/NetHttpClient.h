//
//  NetHttpClient.h
//  alijk
//
//  Created by easy on 14/7/23.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequestHelper.h"


@class RequestDTO;//指示引用声明，实际用的时候才关心里面的内容

//继承AFnetworking框架的类
@interface NetHttpClient : AFHTTPSessionManager

+(NetHttpClient*)sharedHTTPClient;
-(instancetype)initWithBaseURL:(NSURL*)url;

/* 异步发送数据请求
 参数：
 adapterType: 获取数据的网络接口类型
 requestDTO: 网络接口需要的参数列表，若没有为nil
 requestHelper: request base model helper
 compBlock: 获取数据完成后需要执行的操作
 
 返回值：
 task: 请求task
 */
-(void)requestByType:(int)adapterType andObject:(RequestDTO*)requestDTO requestHelper:(__weak NetRequestHelper*)requestHelper onCompletion:(Bool_Block)compBlock;

- (void)cancelTask:(NSURLSessionDataTask*)task;

/* 删除cookies
 */
- (void)deleteCookies;

@end
