//
//  UpdatePasswordRequestDTO.m
//  alijk
//
//  Created by easy on 14/7/28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "UpdatePasswordRequestDTO.h"

@implementation UpdatePasswordRequestDTO

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"phone": @"phone",
                                                       @"newPassWord": @"passwordNew"
                                                       }];
}

@end
