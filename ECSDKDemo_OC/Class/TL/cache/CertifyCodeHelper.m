//
//  CertifyCodeHelper.m
//  alijk
//
//  Created by easy on 14-9-12.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "CertifyCodeHelper.h"
#import "UserDataHelper.h"

#define K_GetCodeTimes          @"GetCertifyCodeTimes"
#define K_RegisterGetCodeTimes  @"RegisterGetCodeTimes"
#define K_FogotPwdGetCodeTimes  @"FogotPwdGetCodeTimes"
#define K_DateCertifyCode       @"date"
#define K_TimesCertifyCode      @"times"
#define K_AllowGetTimes         10

@interface CertifyCodeHelper ()
{
    
}

@property (nonatomic, strong)NSMutableDictionary *getCodeTimesDic;

@end


@implementation CertifyCodeHelper

ZX_IMPLEMENT_SINGLETON(CertifyCodeHelper)

#pragma mark -
#pragma mark - fogot password

/*
 * 预加载信息
 */
- (id)init
{
    if (self = [super init])
    {
        [self initTimesDic];
    }
    
    return self;
}

- (void)initTimesDic
{
    _getCodeTimesDic = [NSMutableDictionary dictionaryWithDictionary:[GUserDefault objectForKey:K_GetCodeTimes]];
    
    if (!_getCodeTimesDic)
    {
        _getCodeTimesDic = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *forgetDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *registDic = [NSMutableDictionary dictionary];
        
        [_getCodeTimesDic setObject:forgetDic forKey:K_FogotPwdGetCodeTimes];
        [_getCodeTimesDic setObject:registDic forKey:K_RegisterGetCodeTimes];
        
        [GUserDefault setObject:_getCodeTimesDic forKey:K_GetCodeTimes];
        [GUserDefault synchronize];
    }
}

- (BOOL)saveVerifySmsSuccess:(NSString *)phoneNum PageType:(E_CallVCType)pageType
{
    NSString *keyStr = (pageType == K_CT_RegistVC) ? K_RegisterGetCodeTimes:K_FogotPwdGetCodeTimes;
    
    NSMutableDictionary *timesDic = [_getCodeTimesDic objectForKey:keyStr];
    NSMutableDictionary *phoneNumDic = [timesDic objectForKey:phoneNum];
    
    if (phoneNumDic)
    {
        NSString *date = [phoneNumDic objectForKey:K_DateCertifyCode];
        int times = [[phoneNumDic objectForKey:K_TimesCertifyCode] intValue];
        
        if ([[self today] isEqualToString:date])
        {
            [phoneNumDic setObject:[NSString stringWithFormat:@"%d", ++times] forKey:K_TimesCertifyCode];
        }
        else
        {
            [phoneNumDic setObject:[self today] forKey:K_DateCertifyCode];
            [phoneNumDic setObject:[NSString stringWithFormat:@"%d", 1] forKey:K_TimesCertifyCode];
        }
    }
    else
    {
        phoneNumDic = [NSMutableDictionary dictionary];
        [phoneNumDic setObject:[self today] forKey:K_DateCertifyCode];
        [phoneNumDic setObject:[NSString stringWithFormat:@"%d", 1] forKey:K_TimesCertifyCode];
        
        [timesDic setObject:phoneNumDic forKey:phoneNum];
    }
    
    [GUserDefault setObject:_getCodeTimesDic forKey:K_GetCodeTimes];
    [GUserDefault synchronize];
    
    return YES;
}

- (NSInteger)getCertifyCodeTimes:(NSString *)phoneNum PageType:(E_CallVCType)pageType
{
    NSString *keyStr = (pageType == K_CT_RegistVC) ? K_RegisterGetCodeTimes:K_FogotPwdGetCodeTimes;

    NSMutableDictionary *timesDic = [_getCodeTimesDic objectForKey:keyStr];
    NSDictionary *phoneNumDic = [timesDic objectForKey:phoneNum];
    
    if (phoneNumDic)
    {
        NSString *date = [phoneNumDic objectForKey:K_DateCertifyCode];
        int times = [[phoneNumDic objectForKey:K_TimesCertifyCode] intValue];
        
        if ([date isEqualToString:[self today]])
        {
            return (K_AllowGetTimes-times);
        }
    }
    
    return K_AllowGetTimes;
}

- (NSString*)today
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return ([formatter stringFromDate:[NSDate date]]);
}

@end
