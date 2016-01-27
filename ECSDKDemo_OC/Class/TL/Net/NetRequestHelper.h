//
//  NetRequestHelper.h
//  alijk
//
//  Created by easy on 14/7/24.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetRequestHelper : NSObject

@property (nonatomic, strong) NSNumber *resuestTag;         //返回tag
@property (nonatomic, copy) Async_Block succeedBlock;       //成功调用的block
@property (nonatomic, copy) Async_Block failedBlock;        //失败调用的block
@property (nonatomic, copy) NSString *responseDTO;          //反馈的DTO
@property (nonatomic, strong) NSURLSessionDataTask *task;   //sessiondata任务

-(BOOL)requestSucceed:(NSDictionary*)response;              //请求成功
-(void)requestFailed:(NSError*)error;                       //请求失败



@end
