//
//  BaseLoginResponseDTO.h
//  alijk
//
//  Created by easy on 14/7/24.
//  Copyright (c) 2014年 zhongxin. All rights reserved.

#import <Foundation/Foundation.h>
#import "TLLoginResultDTO.h"

@interface LoginResponseDTO : ResponseDTO

@property (strong, nonatomic) TLLoginResultDTO *result;

@end