//
//  BaseLoginRequestDTO.h
//  alijk
//
//  Created by easy on 14/7/24.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface LoginRequestDTO : RequestDTO

//@property (nonatomic, copy) NSString *devicesid;//设备ID 目前无用
//@property (nonatomic, copy) NSString *username;//登录必填 同手机号
//@property (nonatomic, copy) NSString *password;//登录必填
//@property (nonatomic, copy) NSString *msgUserid;//消息用户号 字符串 － 推送使用：ios为deviceToken
//@property (nonatomic, copy) NSString *channelId;//消息设备号 数字 － 推送时android使用，ios传0

@property (nonatomic, copy) NSString *loginId;
@property (nonatomic, copy) NSString *loginPwd;

@property (nonatomic, copy) NSString *longtitude;//登录必填
@property (nonatomic, copy) NSString *latitude;//登录必填
@property (nonatomic, copy) NSString *deviceType;//登录必填


@end