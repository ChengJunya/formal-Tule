//
//  NSString+Time.m
//  alijk
//
//  Created by ZhongxinMac on 14-8-26.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)
+ (NSString *)convertTime:(NSString *)originTime
{
    if ([originTime isEqualToString:@""]) {
        return @"1970-01-01 00:00";
    }
    NSString *time = [originTime substringToIndex:16];
    return time;
}
/**
 *  添加转化时间字符串格式
 *
 *  @param originalFormat 原始时间格式
 *  @param newFormat      需要转化的格式
 *  @param string         需要转化的字符串
 *
 *  @return <#return value description#>
 */
+ (NSString *)timeConvertformat:(NSString *)originalFormat newFormat:(NSString *)newFormat string:(NSString *)string
{
    if ([string isEqualToString:@""]||[string isEqualToString:@"(null)"]||string == nil) {
        NSDate *nowdate=[ NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *nowTime= [dateformatter stringFromDate:nowdate];
        return nowTime;
    }
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:originalFormat];
    NSDate *formatterDate = [inputFormatter dateFromString:string];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:newFormat];
    NSString *newDateString = [outputFormatter stringFromDate:formatterDate];
    return newDateString;
}
/**
 *  转化年月日
 *
 */
+ (NSString *)convertDateWithString:(NSString *)string
{
    NSString *newString = [NSString timeConvertformat:@"yyyy年MM月dd日" newFormat:@"yyyy-MM-dd" string:string];
    return newString;
}
@end
