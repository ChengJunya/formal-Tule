//
//  NSString+Json.h
//  alijk
//
//  Created by easy on 14/7/24.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)

+(NSString *)jsonStringWithArray:(NSArray*)array;
+(NSString *)jsonStringWithDictionary:(NSDictionary*)dictionary;
+(NSString *)jsonStringWithObject:(id)object;

@end
