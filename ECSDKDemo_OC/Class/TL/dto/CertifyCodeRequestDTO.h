//
//  CertifyCodeRequestDTO.h
//  alijk
//
//  Created by easy on 14/7/28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "BaseDTOModel.h"

/**
 * 验证手机号和验证码request
 */
@interface CertifyCodeRequestDTO : RequestDTO

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *validateMessage;
@property (nonatomic, copy) NSString *message;

@end
