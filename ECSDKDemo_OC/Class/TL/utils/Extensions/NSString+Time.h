//
//  NSString+Time.h
//  alijk
//
//  Created by ZhongxinMac on 14-8-26.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Time)

/**
 *  返回一个不带秒的时间字符串
 *
 *  @param originTime 原始时间字符串
 *
 *  @return
 */
+ (NSString *)convertTime:(NSString *)originTime;
//转化时间字符串格式
+ (NSString *)timeConvertformat:(NSString *)originalFormat newFormat:(NSString *)newFormat string:(NSString *)string;
/**
 *  转化年月日
 *
 */
+ (NSString *)convertDateWithString:(NSString *)string;
@end
