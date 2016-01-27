//
//  NetRequestHelper.m
//  alijk
//
//  Created by easy on 14/7/24.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "NetRequestHelper.h"
#import "NetMappingModel.h"
#import "NSString+Json.h"
#import "TLHelper.h"

@implementation NetRequestHelper

-(BOOL)requestSucceed:(NSDictionary*)response
{
    
    //判断状态
    //@property (nonatomic, copy) NSString *resultType;   //1-成功 0-失败
    
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
    //@property (nonatomic, copy) NSString *resultCode;   //100000-成功
    //@property (nonatomic, copy) NSString *resultDesc;   //返回的描述
    
    
    // 请求返回成功
    if (1 ==[[response objectForKey:@"resultType"] integerValue])
    {
        // 获取返回后的值
        NSError *error = [[NSError alloc] init];
        ResponseDTO *jsonModel = [[NSClassFromString(self.responseDTO) alloc] initWithDictionary:response  error:&error];
        

        
        if (0 != error.code) {
            ZXLog(@"Json Convert Error: %@", error);
        }
        ZXLog(@"Response JsonModel: %@", jsonModel);
        
        self.succeedBlock(jsonModel);
        
        return YES;
    }
    // 请求返回失败
    else
    {
         NSError *error = [[NSError alloc] init];
        ResponseDTO *jsonModel = [[ResponseDTO alloc] init];
        jsonModel.resultCode = [response objectForKey:@"resultCode"];
        jsonModel.resultDesc = [response objectForKey:@"resultDesc"];
        jsonModel.resultType = [response objectForKey:@"resultType"];

        self.failedBlock(jsonModel);
        if (0 != error.code) {
            ZXLog(@"Json Convert Error: %@", error);
        }
        ZXLog(@"Response failed: %@", [response objectForKey:@"retMessage"]);
        
        if (jsonModel.resultCode.integerValue==100003) {
            [RTLHelper autoLogin];
        }
        
        return NO;
    }
}

/* 处理网络异常
 * 630 未登录
 * 631 另外一台设备登录
 */
extern NSString * const AFNetworkingOperationFailingURLResponseErrorKey;
-(void)requestFailed:(NSError*)error
{
    if (nil == error) {
        return;
    }
    
    ResponseDTO *jsonModel = [[ResponseDTO alloc] init];
    
    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    switch(response.statusCode) {
        case 630://未登录或登录超时
        {
            jsonModel.resultCode = [NSString stringWithFormat:@"%ld",response.statusCode ];
            jsonModel.resultDesc = MultiLanguage(netLoginTimeOut);
            
            // 发送通知返回登录页面
            [GNotifyCenter postNotificationName:NOTIFICATION_BEKICKOFF object:jsonModel];
        }
            break;
        case 631://账号在其他客户端登录
        {
            jsonModel.resultCode = [NSString stringWithFormat:@"%ld",response.statusCode];
            jsonModel.resultDesc = MultiLanguage(netErrBeKickoff);
            
            // 发送通知返回登录页面
            [GNotifyCenter postNotificationName:NOTIFICATION_BEKICKOFF object:jsonModel];
        }
            break;
        case 999://网络连接失败
        {
            jsonModel.resultCode = [NSString stringWithFormat:@"%ld",[error code]];
            jsonModel.resultDesc = MultiLanguage(netConnectErr);
        }
            break;
        case 998://网络连接超时
        {
            jsonModel.resultCode = [NSString stringWithFormat:@"%ld",[error code]];
//            jsonModel.retMessage = MultiLanguage(netConnectTimeOut);
            jsonModel.resultDesc = @"";
        }
            break;
        default:
        {
            jsonModel.resultCode = [NSString stringWithFormat:@"%ld",[error code]];
            jsonModel.resultDesc = MultiLanguage(netErrUnknowError);
        }
            break;
    }
    
    self.failedBlock(jsonModel);
}

@end
