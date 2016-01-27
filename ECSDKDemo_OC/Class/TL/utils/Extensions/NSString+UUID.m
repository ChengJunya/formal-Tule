//
//  NSString+UUID.m
//  alijk
//
//  Created by easy on 14/11/10.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)

+ (NSString*)uuid
{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return uuid;
}

@end
