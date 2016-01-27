//
//  BaseDTOModel.h
//  alijk
//
//  Created by easy on 14/7/25.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
//发送请求的数据对象 父类 包含惨数据 form数据
@interface RequestDTO : JSONModel

- (NSDictionary*)paramter;                          //参数
- (id)formData:(id<AFMultipartFormData>)formData;   //formData 数据

@end




//反馈的数据对象父类
@interface ResponseDTO : JSONModel

//@property (nonatomic, assign) NSInteger retCode;    //returnCode 返回编码
//@property (nonatomic, copy) NSString *retMessage;   //returnMessage 返回信息


@property (nonatomic, copy) NSString *resultType;   //1-成功 0-失败

/**
 100000    代表返回成功
 100001    代表服务器发生异常
 100002    参数异常
 100003    代表未登录
 100004    代表访问未授权的资源
 100005    代表用户当前已经注册过该系统
 100006    不存在已发送的短信验证码
 100007    短信验证码已过期
 100008    短信验证码错误
 100009    距离上次发送未过短信发送间隔
 */
@property (nonatomic, copy) NSString *resultCode;   //100000-成功
@property (nonatomic, copy) NSString *resultDesc;   //返回的描述


@end

