//
//  LoginDataHelper.h
//  alijk
//
//  Created by easy on 14/8/14.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperDataHelper.h"
#import "UserInfoDTO.h"

typedef enum {
    ESIT_HAVE_SHARED = 0,
    ESIT_NAV_MSG_CLICKED,
    ESIT_HAVE_SCAN_CODE,
}ESettingInfoType;

@class UserInfoDTO;

@class LoginRequestDTO;

@interface UserDataHelper : SuperDataHelper

@property (nonatomic,strong ) UserInfoDTO *tlUserInfo;  //TL
@property (nonatomic, strong) LoginRequestDTO *loginInfo; // 用户登录信息
@property (nonatomic, assign) BOOL isLoginSucceed; // 是否登录完成
@property (nonatomic, strong) Id_Block blockedBlock; // 延迟登录后用到的block
@property (nonatomic, strong) NSMutableDictionary *keyValueDic;//key  array 缓存码表数据 

ZX_DECLARE_SINGLETON(UserDataHelper)

/*
 * 生成用户登录信息
 */
- (LoginRequestDTO*)genLoginInfoWithUsername:(NSString*)username password:(NSString*)password;

/*
 * 保存用户登录信息
 */
- (void)saveLoginInfo:(LoginRequestDTO*)loginInfo;

/*
 * 自动登录
 */
- (LoginRequestDTO*)autoLogin:(DataHelper_Block)block;

/*
 * 退出登录
 * 1.主动退出当前账号
 * 2.被动退出当前账号：被踢掉或登录超时
 */
- (void)exitLogin:(BOOL)isManual;

/*
 * 登录完成后判断是否要清除上一个用户内存中的信息
 */
- (BOOL)checkToClearLastUserInfoWhenLogin;





/*
 * 是否有有效的登录信息
 */
- (BOOL)hasValidLoginInfo;

/*
 * 用户登录
 * username:用户名
 * password：密码
 * block：成功返回userInfo，失败返回responseDTO
 */
- (void)loginWithUsername:(NSString*)username password:(NSString*)password type:(NSInteger)loginType block:(DataHelper_Block)block;

/*
 * 用户登录
 * loginInfo:用户登录dto
 * block：成功返回userInfo，失败返回responseDTO
 */
- (void)loginWithLoginInfo:(LoginRequestDTO*)loginInfo type:(NSInteger)loginType block:(DataHelper_Block)block;


/*
 * 更新用户密码
 * username：用户名
 * password：新密码
 * block：YES/NO
 */
- (void)updatePasswordWithUserName:(NSString*)username password:(NSString*)password block:(Bool_Block)block;

/*
 * 注册新用户
 * username：用户名
 * password：密码
 * certifyCode：验证码
 * block：obj：loginDTO; YES/NO
 */
//- (void)registerWithUserName:(NSString*)username password:(NSString*)password certifyCode:(NSString*)certifyCode recommendCode:(NSString *)recommendCode block:(DataHelper_Block)block;

- (void)registerWithPhone:(NSString*)phone password:(NSString*)password provinceId:(NSString*)provinceId cityId:(NSString*)cityId districtId:(NSString*)districtId type:(NSString*)isChinaPhone block:(DataHelper_Block)block;


/*
 * 修改密码
 * oldPassword：旧密码
 * newPassword：新密码
 * block：obj：loginDTO; YES/NO
 */
- (void)modifyPassword:(NSString *)oldPassword withNew:(NSString *)newPassword request:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 * 清空内存中的数据
 */
- (void)clearAllMemoryData;

/*
 * 获取（是否点击过某个按钮的）设置信息
 */
- (BOOL)userSettingInfo:(ESettingInfoType)type;

/*
 * 保存信息（是否点击过某个按钮）
 */
- (void)saveUserSettingInfo:(ESettingInfoType)type;

-(void)exitLoginServer:(DataHelper_Block)block;


-(void)getLocationInfo:(Location_Block)block;

-(BOOL)isLoginUser:(NSString *)loginId;

-(BOOL)isUserAuth;

-(NSArray*)getCommonCodeDataByType:(NSString*)type;

@end
