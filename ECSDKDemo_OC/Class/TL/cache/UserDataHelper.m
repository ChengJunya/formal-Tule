//
//  LoginDataHelper.m
//  alijk
//
//  Created by easy on 14/8/14.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "UserDataHelper.h"

#import "LoginRequestDTO.h"
#import "LoginResponseDTO.h"
#import "RegRequestDTO.h"
#import "RegResponseDTO.h"
#import "UpdatePasswordRequestDTO.h"
#import "UpdatePasswordResponseDTO.h"
#import "ZXCryptUtils.h"
#import "NSString+Json.h"
#import "AddressDataHelper.h"
#import "TLHelper.h"

#import "TLPersonCountDTO.h"


#import "NetHttpClient.h"
#import "UserGuideViewController.h"




#import "AppVersionHelper.h"
#import "DUNavigationController.h"
#import "UpdateNewPasswordRequestDTO.h"
#import "TLMyFriendListRequestDTO.h"

#import "TLModuleDataHelper.h"
#import "TLSimpleUserDTO.h"
#import "TLAddGrowRequestDTO.h"
#import "TLAddGrowResultDTO.h"

#import <CoreLocation/CoreLocation.h>
#import "TLWaitingImageResponseDTO.h"
#import "BPush.h"

#import "TLLogoutRequestDTO.h"

#define K_IsHaveLuanched    @"K_IsHaveLuanched"
#define K_IsHaveShared      @"K_IsHaveShared"
#define K_IsNavMsgClicked   @"K_IsNavMsgClicked"
#define K_IsScanCodeClicked @"K_IsScanCodeClicked"


#define GetSettingInfo(_p, key) { \
_p = [[GUserDefault objectForKey:key] boolValue]; \
}

#define SetSettingInfo(_p, key) { \
if (!_p) { \
[GUserDefault setObject:[NSNumber numberWithBool:YES] forKey:key]; \
[GUserDefault synchronize]; \
_p = YES; \
} \
}



@interface UserDataHelper ()<CLLocationManagerDelegate>{
    NSString * currentLatitude;
    NSString * currentLongitude;
    
    //CLLocationManager *locManager;
}
@property (nonatomic, strong) CLLocationManager  *locationManager;
@property (nonatomic, assign) NSInteger lastUserStatus; // 0：未登录 1：被动退出 2：主动退出
@property (nonatomic, copy) NSString *lastUserID;
@property (nonatomic, strong) NSString *userLoginId;

@property (nonatomic, assign) BOOL isShared; // 是否点击过分享
@property (nonatomic, assign) BOOL isNavMsgClicked; // 是否点击过msg按钮
@property (nonatomic, assign) BOOL isScanCodeClicked; // 是否点击过扫一扫操作

@end


@implementation UserDataHelper

ZX_IMPLEMENT_SINGLETON(UserDataHelper)

- (id)init
{
    if (self = [super init]) {
        [self initSettingInfo];
        self.keyValueDic = [NSMutableDictionary dictionary];
        [self initLoaction];
    }
    
    return self;
}


-(void)initLoaction{
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10;
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    if ([[phoneVersion substringToIndex:1] isEqualToString:@"8"] || [[phoneVersion substringToIndex:1] isEqualToString:@"9"]) {
        [_locationManager requestAlwaysAuthorization];//添加这句
    }

    [_locationManager startUpdatingLocation];
    
   
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    currentLatitude = [NSString stringWithFormat:@"%f",currLocation.coordinate.latitude];
    currentLongitude  = [NSString stringWithFormat:@"%f",currLocation.coordinate.longitude];
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}



#pragma mark-
#pragma mark get data

/*
 * 生成用户登录信息
 */
- (LoginRequestDTO*)genLoginInfoWithUsername:(NSString*)username password:(NSString*)password
{
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        return nil;
    }
    
    LoginRequestDTO *reqDTO = [[LoginRequestDTO alloc] init];
    reqDTO.loginId = username;
    reqDTO.loginPwd = password;
    //reqDTO.password = [self encryptPasswordWithName:username password:password];
//    reqDTO.msgUserid = [GAPNsHelper deviceToken];
    //reqDTO.channelId = @"0";
    
    self.loginInfo = reqDTO;
    
    return reqDTO;
}



/*
 * 用户密码加密
 */
- (NSString*)encryptPasswordWithName:(NSString*)username password:(NSString*)password
{
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        return @"";
    }
    
    NSString *firstEncrypt = [ZXCryptUtils md5_32:[username stringByAppendingString:password]];
    NSString *secondEncrypt = [ZXCryptUtils md5_32:[[username stringByAppendingString:password] stringByAppendingString:firstEncrypt]];
    
    return ([secondEncrypt uppercaseString]);
    
}

/*
 * 保存用户登录信息
 */
- (void)saveLoginInfo:(LoginRequestDTO*)loginInfo
{
    if (nil == loginInfo) {
        return;
    }
    
    self.loginInfo = loginInfo;
    self.isLoginSucceed = YES;
    [GUserDefault setObject:loginInfo.toDictionary forKey:UserDefault_LoginUser];
    [GUserDefault setObject:[loginInfo loginId]  forKey:UserDefault_LastUserLoginId];
    [GUserDefault setObject:self.tlUserInfo.toDictionary forKey:UserDefault_UserInfo];
    
    [GUserDefault synchronize];
}


-(void)addGrow:(NSString *)loginId{
    TLAddGrowRequestDTO *request = [[TLAddGrowRequestDTO alloc] init];
    request.loginId = loginId;
    [GTLModuleDataHelper addGrow:request requestArr:[NSMutableArray array] block:^(id obj, BOOL ret) {
        if (ret) {
            TLAddGrowResultDTO *result = obj;
            NSLog(@"%@",result.growth);
        }else{
            NSLog(@"请求失败");
        }
    }];
}

/*
 * 生成用户登录信息
 */
- (LoginRequestDTO*)autoLogin:(DataHelper_Block)block
{
    BOOL isAutoLogin = [[GUserDefault objectForKey:IS_AUTO_LOGIN] boolValue];
    if (!isAutoLogin) {
        return nil;
    }
    NSDictionary *loginInfo = [GUserDefault objectForKey:UserDefault_LoginUser];
    if (nil == loginInfo) {
        [RTLHelper gotoLoginViewController];
        return nil;
    }
    

    
    NSString *username = [loginInfo valueForKey:@"loginId"];
    NSString *password = [loginInfo valueForKey:@"loginPwd"];
    
    [self addGrow:username];
    
    LoginRequestDTO *loginInfoDto = [[LoginRequestDTO alloc] init];
    loginInfoDto.loginId = username;
    loginInfoDto.loginPwd = password;
    [self loginWithUsername:username password:password type:2 block:block];
    return loginInfoDto;
}

/*
 * 登录完成后判断是否要清除上一个用户内存中的信息
 */
- (BOOL)checkToClearLastUserInfoWhenLogin
{
    BOOL isNeedClear = YES;
    switch (self.lastUserStatus) {
        case 0: {
            isNeedClear = NO;
        }
            break;
        case 1: {
            isNeedClear = !([self.lastUserID isEqualToString:self.loginInfo.loginId]);
        }
            break;
            
        default:
            break;
    }
    
    // 清空内存中的数据
    if (isNeedClear) {
        [GAddressHelper clearAllMemoryData];
    }
    
    return isNeedClear;
}

/*
 * 退出登录
 * 1.主动退出当前账号
 * 2.被动退出当前账号：被踢掉或登录超时
 */
- (void)exitLogin:(BOOL)isManual
{
    
    
    
//    if (!self.isLoginSucceed) {
//        return;
//    }
    
    // 保存上次登录的用户名
    self.lastUserID = self.loginInfo.loginId;
    
    
    // 清除网络请求的cookies
    [GHttpClient deleteCookies];
    
    // 清除本地存储的登录信息
    [GUserDefault removeObjectForKey:UserDefault_LoginUser];
    [GUserDefault synchronize];
    
    // 清除当前用户的所有信息
    [self clearAllMemoryData];
    
    
    /**
     *  删除百度推送tag
     */
    [BPush delTag:self.tlUserInfo.loginId];
    // 主动退出当前账号再次登录
    if (isManual) {
        [RTLHelper gotoLoginViewController];
    }

}


-(void)exitLoginServer:(DataHelper_Block)block{
    
    TLLogoutRequestDTO *request = [[TLLogoutRequestDTO alloc] init];
    request.deviceType = @"4";
    [GDataManager asyncRequestByType:NetAdapter_Logout andObject:request success:^(ResponseDTO *responseDTO) {

        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(ResponseDTO *responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
}




/*
 * 是否有有效的登录信息
 */
- (BOOL)hasValidLoginInfo
{
    return (nil != [GUserDefault objectForKey:UserDefault_LoginUser]);
}

/*
 * 用户登录
 * username:用户名
 * password：密码
 * type: 2-自动登录 1-手动登录
 * block：成功返回userInfo，失败返回responseDTO
 */
- (void)loginWithUsername:(NSString*)username password:(NSString*)password type:(NSInteger)loginType block:(DataHelper_Block)block
{
    LoginRequestDTO *reqDTO = [self genLoginInfoWithUsername:username password:password];
    [self loginWithLoginInfo:reqDTO type:loginType block:block];
}

-(void)getLocationInfo:(Location_Block)block{
    [self getGeoInfo];
    block(currentLongitude,currentLatitude);
}

-(void)getGeoInfo{
    
    
    currentLatitude = [[NSString alloc]
                       initWithFormat:@"%g",
                       self.locationManager.location.coordinate.latitude];
    currentLongitude = [[NSString alloc]
                        initWithFormat:@"%g",
                        self.locationManager.location.coordinate.longitude];
    
    if (currentLatitude.integerValue==0) {
        currentLatitude = @"-1";
    }
    
    if (currentLongitude.integerValue==0) {
        currentLongitude = @"-1";
    }
}

/*
 * 用户登录
 * loginInfo:用户登录dto
 * block：成功返回userInfo，失败返回responseDTO 
 * type ： 1-手动登录  2-自动登录
 */
- (void)loginWithLoginInfo:(LoginRequestDTO*)loginInfo type:(NSInteger)loginType  block:(DataHelper_Block)block
{
    if (nil == loginInfo) {
        if (block) {
            block(nil, NO);
        }
        return;
    }
    
    [self getGeoInfo];
    
    loginInfo.longtitude = currentLongitude;
    loginInfo.latitude = currentLatitude;
    loginInfo.deviceType = @"4";//ios
    
    [GDataManager asyncRequestByType:NetAdapter_User_Login andObject:loginInfo success:^(LoginResponseDTO *responseDTO) {
        self.tlUserInfo = responseDTO.result.userInfo;
        //[self getMyAccountInfo:nil]; // 用户常规登录成功（不是手淘账户登录）后，请求acount信息
        [self saveLoginInfo:loginInfo];
        [DemoGlobalClass sharedInstance].loginInfoDic = self.tlUserInfo.toDictionary;
        
        //获取其他相关信息
        [self loginIM:loginType];
        [self getCommonCode];
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(ResponseDTO *responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
}


/**
 *  logintype 1-手动 2-自动
 *
 *  @param loginType <#loginType description#>
 */
-(void)loginIM:(NSInteger)loginType
{
    
    
    UserInfoDTO *userInfo = [GUserDataHelper tlUserInfo];
    ECLoginInfo *loginInfo = [[ECLoginInfo alloc] initWithAccount:userInfo.voipAccount Password:userInfo.voipToken];
    loginInfo.serviceUrl = @"https://app.cloopen.com:8883";
    WEAK_SELF(self);
    loginInfo.subAccount = userInfo.subAccount;
    loginInfo.subToken = userInfo.subToken;
    [[DeviceDBHelper sharedInstance] openDataBasePath:userInfo.voipAccount];
    [[ECDevice sharedInstance] login:loginInfo completion:^(ECError *error) {

        if (error.errorCode == ECErrorType_NoError) {
            [DemoGlobalClass sharedInstance].loginInfoDic = userInfo.toDictionary;
            //[[DemoGlobalClass sharedInstance].subAccontsArray removeObjectAtIndex:_curIndex-BUTTON_SUNACCOUNT_BASE_TAG];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:[DemoGlobalClass sharedInstance].subAccontsArray] forKey:UserDefault_Connacts];
            //[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:[DemoGlobalClass sharedInstance].loginInfoDic] forKey:UserDefault_LoginUser];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            //如果是从登陆页面过来的 否则不需要页面跳转
            if (loginType==1) {
                [RTLHelper gotoRootViewController];
                //[BPush delTag:self.tlUserInfo.loginId];
                [BPush setTag:self.tlUserInfo.loginId];
                 [BPush bindChannel];
            }
            
            
            
            
            
            
            [weakSelf initUserData];
        }
        else{
            //[GHUDAlertUtils toggleMessage:@"登录失败！"];
        }
        
    }];
    
}



-(void)initUserData{
   
    
    
    [[DemoGlobalClass sharedInstance].mainAccontDictionary removeAllObjects];
    
    [[DemoGlobalClass sharedInstance].appInfoDictionary  removeAllObjects];
    
    //[[DemoGlobalClass sharedInstance].subAccontsArray removeAllObjects];
    
    //保存主账号信息
    NSMutableDictionary* AccountInfo = [DemoGlobalClass sharedInstance].mainAccontDictionary;
    [AccountInfo setObject: @"8a48b5514a61a814014a8083efe412c2" forKey:@"main_account"];
    [AccountInfo setObject: @"7960c6f0ceb24fc1a805087550e6a8ba" forKey:@"main_token"];
    [AccountInfo setObject: @"途乐" forKey:@"nick_name"];
    [AccountInfo setObject: @"18612701019" forKey:@"mobile"];
    [AccountInfo setObject: @"" forKey:@"test_number"];
    
    
    //保存应用信息
    NSMutableDictionary* ApplicationDict = [DemoGlobalClass sharedInstance].appInfoDictionary;
    [ApplicationDict setObject: @"8a48b5514d07eb90014d1deda6d90b90" forKey:@"appId"];
    [ApplicationDict setObject: @"途乐APP" forKey:@"appName"];
    
    
    TLMyFriendListRequestDTO *request = [[TLMyFriendListRequestDTO alloc] init];
    request.type = @"1";
    request.phoneArray = @"";
    request.searchText = @"";
    [GTLModuleDataHelper myFriendList:request requestArr:[NSMutableArray array] block:^(id obj, BOOL ret) {
        
        if (ret) {
            //保存子账号信息
            NSMutableArray* subAccountArray = [DemoGlobalClass sharedInstance].subAccontsArray;
            NSArray *friends = obj;
            [friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                TLSimpleUserDTO *dto = obj;
                NSDictionary *friend = [dto toDictionary];
                [subAccountArray addObject:friend];
            }];

            
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];
    
    

    
}



-(void)getCommonCode{
    /*
    activtyPersonNum：活动人数码表
    rentType：租赁类型（按日，按月）
    serviceType：商家服务类型
    merchantType：商户类型
    profession：用户职业类型
    gender：性别
     */
    
    
    NSArray *types = @[@"activtyPersonNum",@"rentType",@"serviceType",@"merchantType",@"carType",@"goodsType"];
    
    [types enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *type = obj;
        
        TLCommonCodeRequestDTO *request = [[TLCommonCodeRequestDTO alloc] init];
        request.type = type;
        [GTLModuleDataHelper commonCode:request requestArray:[NSMutableArray array] block:^(id obj, BOOL ret) {
            if (ret) {
                NSMutableArray *tmpArray = [NSMutableArray array];
                NSArray *array = obj;
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    TLPersonCountDTO *dto = obj;
                    NSDictionary *dic = @{@"ID":dto.codeValue,@"NAME":dto.codeName};
                    [tmpArray addObject:dic];
                }];
                
                
                [self.keyValueDic setObject:tmpArray forKey:type];
            }
        }];
        
        

    }];
    
    }


/*
 * 更新用户密码
 * username：用户名
 * password：新密码
 * block：YES/NO
 */
- (void)updatePasswordWithUserName:(NSString*)username password:(NSString*)password block:(Bool_Block)block
{
    UpdatePasswordRequestDTO *request = [[UpdatePasswordRequestDTO alloc] init];
    request.phone = username;
    request.passwordNew = [self encryptPasswordWithName:username password:password];
    
//    [GDataManager asyncRequestByType:NetAdapter_User_UpdatePassword andObject:request success:^(UpdatePasswordResponseDTO *responseDTO) {
//        if (block) {
//            block(YES);
//        }
//    } failure:^(ResponseDTO *responseDTO) {
//        if (block) {
//            block(NO);
//        }
//    }];
}




- (void)registerWithPhone:(NSString*)phone password:(NSString*)password provinceId:(NSString*)provinceId cityId:(NSString*)cityId districtId:(NSString*)districtId type:(NSString*)isChinaPhone block:(DataHelper_Block)block{
    RegRequestDTO *regDTO = [[RegRequestDTO alloc] init];
    regDTO.phoneNum = phone; //GDevicesID; // 使用手机号;
    regDTO.pwd = password;
    regDTO.provinceId = provinceId;
    regDTO.cityId = cityId;//[self encryptPasswordWithName:username password:password];
    regDTO.districtId = districtId;
    regDTO.isChinaPhoneNum = isChinaPhone;
    
    [GDataManager asyncRequestByType:NetAdapter_User_Register andObject:regDTO success:^(RegResponseDTO *responseDTO) {
        // 注册成功后再登录
        //LoginRequestDTO *loginDTO = [self genLoginInfoWithUsername:username password:password];
        if (block) {
            block(responseDTO, YES);
            self.userLoginId = responseDTO.result.loginId;
        }
//        [self loginWithLoginInfo:loginDTO block:^(id obj, BOOL ret) {
//            if (ret) {
//                [self saveLoginInfo:loginDTO];
//            }
//            if (block) {
//                block(responseDTO, ret);
//            }
//        }];
    } failure:^(ResponseDTO *responseDTO) {
        /*
         0：成功；1：验证码不正确；2：验证码失效（超过10分钟）；3：验证码失效（session为空）；4：获取验证码的手机号与你注册的手机号不匹配！；5：此账号已注册
         */
        if (block) {
            block(responseDTO, NO);
        }
    }];
}

/*
 * 修改密码
 * oldPassword：旧密码
 * newPassword：新密码
 * block：obj：loginDTO; YES/NO
 */
- (void)modifyPassword:(NSString *)oldPassword withNew:(NSString *)newPassword request:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block
{
    UpdateNewPasswordRequestDTO *regDTO = [[UpdateNewPasswordRequestDTO alloc] init];
    regDTO.oldPassWord = [self encryptPasswordWithName:self.loginInfo.loginId password:oldPassword];;
    regDTO.nPassWord = [self encryptPasswordWithName:self.loginInfo.loginId password:newPassword];;
    
//    [GDataManager asyncRequestByType:NetAdapter_User_Modify_Password andObject:regDTO success:^(ResponseDTO *responseDTO) {
//        if (block) {
//            block(responseDTO, YES);
//        }
//    } failure:^(ResponseDTO *responseDTO) {
//        if (block) {
//            block(responseDTO, NO);
//        }
//    }];
}

/*
 * 清空内存中的数据
 */
- (void)clearAllMemoryData
{

   self.loginInfo = nil;
    self.isLoginSucceed = NO;
    self.blockedBlock = nil;
}


#pragma mark -
#pragma mark - setting info

- (void)initSettingInfo
{
    GetSettingInfo(_isShared, K_IsHaveShared);
    GetSettingInfo(_isNavMsgClicked, K_IsNavMsgClicked);
    GetSettingInfo(_isScanCodeClicked, K_IsScanCodeClicked);
}

/*
 * 获取（是否点击过某个按钮的）设置信息
 */
- (BOOL)userSettingInfo:(ESettingInfoType)type
{
    BOOL retValue;
    switch (type) {
        case ESIT_HAVE_SHARED: { // 是否点击过分享
            retValue = _isShared;
        }
            break;
        case ESIT_NAV_MSG_CLICKED: { // 是否点击过msg按钮
            retValue = _isNavMsgClicked;
        }
            break;
        case ESIT_HAVE_SCAN_CODE: { // 是否点击过"扫一扫"
            retValue = _isScanCodeClicked;
        }
            break;
        default:
            break;
    }
    
    return retValue;
}

/*
 * 保存信息（是否点击过某个按钮）
 */
- (void)saveUserSettingInfo:(ESettingInfoType)type
{
    switch (type) {
        case ESIT_HAVE_SHARED: { // 是否点击过分享
            SetSettingInfo(_isShared, K_IsHaveShared);
        }
            break;
        case ESIT_NAV_MSG_CLICKED: { // 是否点击过msg按钮
            SetSettingInfo(_isNavMsgClicked, K_IsNavMsgClicked);
        }
            break;
        case ESIT_HAVE_SCAN_CODE: { // 是否点击过"扫一扫"
            SetSettingInfo(_isScanCodeClicked, K_IsScanCodeClicked);
        }
            break;
        default:
            break;
    }
}

-(BOOL)isLoginUser:(NSString *)loginId{
    if ([self.tlUserInfo.loginId isEqualToString:loginId]) {
        return YES;
    }else{
        return  NO;
    }
}
-(BOOL)isUserAuth{
    if (self.tlUserInfo.isAuth.integerValue==1) {
        return YES;
    }else{
        return NO;
    }
}

-(NSArray*)getCommonCodeDataByType:(NSString*)type{
    NSArray *array = [self.keyValueDic objectForKey:type];
    return array;
}
@end
