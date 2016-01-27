//
//  ZXCryptUtils.h
//  alijk
//
//  Created by easy on 14/11/27.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXCryptUtils : NSObject

+ (NSString*)md5_32:(NSString*)input;
+ (NSString*)md5_16:(NSString*)input;

+ (NSString*)sha1:(NSString*)input;
+ (NSString*)sha256:(NSString*)input;
+ (NSString*)sha384:(NSString*)input;
+ (NSString*)sha512:(NSString*)input;

+ (NSString*)aesEncrypt:(NSString*)data key:(NSString*)key iv:(NSString*)iv;
+ (NSString*)aesDecrypt:(NSString*)data key:(NSString*)key iv:(NSString*)iv;

+ (NSString*)rsaEncrypt:(NSString*)data key:(SecKeyRef)key;
+ (NSString*)rsaDecrypt:(NSString*)data key:(SecKeyRef)key;

@end
