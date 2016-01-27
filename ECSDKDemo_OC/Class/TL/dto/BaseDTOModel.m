//
//  ResponseDTO.m
//  alijk
//
//  Created by easy on 14/7/25.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "BaseDTOModel.h"
#import "NSString+Json.h"

@implementation RequestDTO

- (NSDictionary*)paramter
{
    /* 方法1：某些情况下转化会有问题
     NSString *jsonString = requestDTO.toJSONString;
     */
    
    /* 方法2：ok
     */
    NSString *jsonString = [NSString jsonStringWithDictionary:self.toDictionary];//数据对象转换成json字符串
    ZXLog(@"Request JsonString: %@", jsonString);
    
    NSDictionary *parameter = self.toDictionary ;//[NSDictionary dictionaryWithObject:jsonString forKey:REQUEST_DATA];//参数字典 key=RE***
    return parameter;
}

- (id)formData:(id<AFMultipartFormData>)formData
{
    return nil;
}

@end



@implementation ResponseDTO

@end
