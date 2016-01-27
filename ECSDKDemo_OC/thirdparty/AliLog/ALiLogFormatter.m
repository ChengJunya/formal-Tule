//
//  ALiLogFormatter.m
//  NSLogTester
//
//  Created by Rainbow on 4/24/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "ALiLogFormatter.h"

@implementation ALiLogFormatter

- (instancetype)init {
    self = [super init];
    
    if (self) {
    }
    return self;
    
}


-(NSString *)formatLogMessage:(DDLogMessage *)logMessage{
    
    return [self replaceUnicode:logMessage.message];
}


- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

@end
