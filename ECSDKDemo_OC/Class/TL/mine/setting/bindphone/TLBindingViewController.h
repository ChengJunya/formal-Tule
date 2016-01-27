//
//  TLBindingViewController.h
//  TL
//
//  Created by YONGFU on 5/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "SuperViewController.h"




typedef enum  {
    PhoneVerify4ForgetPwd,
    PhoneVerify4TaoBinding
} PhoneVerifyPurpose;

@interface TLBindingViewController : SuperViewController

@property(nonatomic, assign) PhoneVerifyPurpose forPurpose;


@end