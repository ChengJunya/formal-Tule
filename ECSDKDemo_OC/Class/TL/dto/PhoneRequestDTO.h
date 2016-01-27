//
//  PhoneRequestDTO.h
//  alijk
//
//  Created by easy on 14/7/28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "BaseDTOModel.h"

/**
 * 忘记密码获取验证码
 */
@interface PhoneRequestDTO : RequestDTO

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *rand;

@end
