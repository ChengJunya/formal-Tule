//
//  MSTUtils.h
//  MSTChart
//
//  Created by Rainbow on 6/23/14.
//  Copyright (c) 2014 MST Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@interface BoncUtils : NSObject
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha;
+ (NSString *)formatYAxisLabel:(double)yValue;
@end
