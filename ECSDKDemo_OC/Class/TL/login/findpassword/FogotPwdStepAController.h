//
//  FogotPwdStepAController.h
//  alijk
//
//  Created by easy on 14-7-30.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "SuperViewController.h"


typedef enum  {
    PhoneVerify4ForgetPwd,
    PhoneVerify4TaoBinding
} PhoneVerifyPurpose;

@interface FogotPwdStepAController : SuperViewController

@property(nonatomic, assign) PhoneVerifyPurpose forPurpose;



@end
