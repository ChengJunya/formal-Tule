//
//  NetUploader.h
//  alijk
//
//  Created by easy on 14-10-11.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetUploader : AFURLSessionManager

//序列化对象
@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;

//初始化
- (id)initWithBaseURL:(NSURL*)url;

//上传对象
- (NSURLSessionUploadTask*)upload:(NSString *)URLString
                         fromData:(NSData *)bodyData
                         progress:(NSProgress * __autoreleasing *)progress
                completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;
@end
