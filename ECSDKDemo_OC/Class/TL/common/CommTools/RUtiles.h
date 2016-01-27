//
//  RUtiles.h
//  HiddenTalk
//
//  Created by Rainbow on 8/21/13.
//  Copyright (c) 2013 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RUtiles : NSObject


+(void)alert:(NSString*)title info:(NSString*)info;
+ (UIImage*) getImage:(UIImage*)originImg inRect:(CGRect)rect;

//-(void)commonAlert:(NSString*)title info:(NSString*)info;
+ (NSString *)getDateString:(NSDate *)date;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha;
+ (NSString *)formatYAxisLabel:(double)yValue;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringFromDateWithFormat:(NSDate *)date format:(NSString*)format;
+(NSDate*) dateFromString:(NSString*)uiDate;
+(NSDate*) dateFromString:(NSString*)uiDate format:(NSString *)format;
+(NSDateComponents *)getDateComponents:(NSDate *)date;

+(UIImage *)changeImage:(UIImage*)image height:(CGFloat)height width:(CGFloat)width;

@end
