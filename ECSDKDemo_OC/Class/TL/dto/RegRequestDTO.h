//
//  RegRequestDTO.h
//  alijk
//
//  Created by easy on 14/7/28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "BaseDTOModel.h"

/*
 * 登录患者端请求的结构 对应原型<注册.html>
 */
@interface RegRequestDTO : RequestDTO

//@property (nonatomic, copy) NSString *devicesid ;  //手机串号
//@property (nonatomic, copy) NSString *key ;  //验证码
//@property (nonatomic, copy) NSString *password;  //密码
//@property (nonatomic, copy) NSString *mobilephone;  //手机
//@property (nonatomic, copy) NSString *recommendCode;  //推荐码
//@property (nonatomic, copy) NSString *areaCode;//区域ID
//@property (nonatomic, copy) NSString *fromChannel;//渠道
//@property (nonatomic, copy) NSString *versionNum;//版本
//@property (nonatomic, assign) NSInteger clientType;//andriod=1 or ios=2

@property (nonatomic, copy) NSString *phoneNum ;  //手机串号
@property (nonatomic, copy) NSString *provinceId ;  //手机串号
@property (nonatomic, copy) NSString *cityId ;  //手机串号
@property (nonatomic, copy) NSString *districtId ;  //手机串号
@property (nonatomic, copy) NSString *pwd ;  //手机串号
@property (nonatomic,copy) NSString *isChinaPhoneNum;


@end
