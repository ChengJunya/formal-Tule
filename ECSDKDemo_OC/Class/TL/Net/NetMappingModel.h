//
//  NetMappingModel.h
//  alijk
//
//  Created by easy on 14/7/24.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 基本的mapping信息，供NetAdapterList.plist使用
 */
@interface NetMappingModel : NSObject

@property (nonatomic, copy) NSString *requestDTO;
@property (nonatomic, copy) NSString *responseDTO;
@property (nonatomic, copy) NSString *pathPattern;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, assign) NSInteger requestType; // 0：常规请求 1：formData请求 2：上传文件请求 3：扫码结果

@end