//
//  DemoGlobalClass.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceChatHelper.h"
#import "DeviceDBHelper.h"

#define voipKey         @"voipAccount" //@"voip_account"
#define pwdKey          @"voipToken" //@"voip_token"
#define nameKey         @"userName" //@"voip_name"
#define imageKey        @"userIcon" //@"image_key"
#define subAccountKey   @"subAccount" //@"sub_account"
#define subTokenKey     @"subToken" //@"sub_token"

//子账号列表
#define UserDefault_Connacts    @"UserDefault_Connacts"
//用户登陆KEY
#define UserDefault_LoginUser   @"UserDefault_LoginUser"//保存用户和密码
#define UserDefault_UserInfo   @"UserDefault_UserInfo"//保存用户信息
#define UserDefault_LastUserLoginId   @"UserDefault_UserLoginId"//保存用户信息

#define KNotice_GetGroupName  @"KNotice_GetGroupName"

#define K_IS_HAS_LAUNCH @"isHasLaunch"
#define IS_AUTO_LOGIN @"isAutoLogin"
#define LAST_UPLOAD_TIME @"lastUploadTime"

@class ECLoginInfo;

@interface DemoGlobalClass : NSObject
/**
 *@brief 获取DemoGlobalClass单例句柄
 */
+(DemoGlobalClass*)sharedInstance;


/**
 *@brief 主账号信息
 */
@property (nonatomic, strong) NSMutableDictionary* mainAccontDictionary;

/**
 *@brief 测试应用下子账号信息
 */
@property (nonatomic, strong) NSMutableArray* subAccontsArray;

/**
 *@brief 测试应用下子账号信息 登陆用户信息
 */
@property (nonatomic, strong) NSDictionary* loginInfoDic;

/**
 *@brief 测试应用信息
 */
@property (nonatomic, strong) NSMutableDictionary* appInfoDictionary;

@property (nonatomic, strong) NSMutableDictionary* allSessions;

//是否已经登录
@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, assign) ECNetworkType netType;
/**
 *@brief 根据VoIP获取联系人姓名
 *@param voip 联系人VoIP
 */
-(NSString*)getOtherNameWithVoip:(NSString*)voip;

/**
 *@brief 根据VoIP获取联系人信息
 *@param voip 联系人VoIP
 */
-(NSMutableDictionary*)getOtherDictionaryWithVoip:(NSString*)voip;

/**
 *@brief 根据VoIP获取联系人头像
 *@param voip 联系人VoIP、群组id
 */
-(UIImage*)getOtherImageWithVoip:(NSString*)voip;
-(NSString*)getOtherImageNameWithVoip:(NSString*)voip;
@end
