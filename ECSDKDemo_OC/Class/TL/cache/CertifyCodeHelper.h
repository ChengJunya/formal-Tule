//
//  CertifyCodeHelper.h
//  alijk
//
//  Created by easy on 14-9-12.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperDataHelper.h"

typedef enum __callVCType
{
    K_CT_ForgetVC = 0,
    K_CT_RegistVC
    
}E_CallVCType;

@interface CertifyCodeHelper : SuperDataHelper

@property (nonatomic, assign) NSInteger fpGetCodeTimes;
@property (nonatomic, assign) NSInteger regGetCodeTimes;

ZX_DECLARE_SINGLETON(CertifyCodeHelper)

/*
 * 保存获取验证码成功手机号
 */
- (BOOL)saveVerifySmsSuccess:(NSString *)phoneNum PageType:(E_CallVCType)pageType;

/*
 * 今天剩余的请求次数
 */
- (NSInteger)getCertifyCodeTimes:(NSString *)phoneNum PageType:(E_CallVCType)pageType;

@end
