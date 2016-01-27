//
//  ZXCryptUtils.m
//  alijk
//
//  Created by easy on 14/11/27.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "ZXCryptUtils.h"


@implementation ZXCryptUtils

#pragma mark -
#pragma mark - md5

/*
 * 32位md5加密方式
 */
+ (NSString*)md5_32:(NSString*)input
{
    const char *str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

/*
 * 16位md5加密方式
 */
+ (NSString*)md5_16:(NSString*)input
{
    const char *str = [input UTF8String];
    unsigned char result[16];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


#pragma mark -
#pragma mark - sha

/*
 * sha1加密方式
 */
+ (NSString*)sha1:(NSString*)input
{
    return ([self sha:input type:1]);
}

/*
 * sha256加密方式
 */
+ (NSString*)sha256:(NSString*)input
{
    return ([self sha:input type:256]);
}

/*
 * sha384加密方式
 */
+ (NSString*)sha384:(NSString*)input
{
    return ([self sha:input type:384]);
}

/*
 * sha512加密方式
 */
+ (NSString*)sha512:(NSString*)input
{
    return ([self sha:input type:512]);
}

/*
 * 通用sha加密方式
 */
+ (NSString*)sha:(NSString*)input type:(NSInteger)type
{
    const char *str = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *hashData = [NSData dataWithBytes:str length:input.length];
    
    uint8_t *digest;
    NSInteger length = 0;
    switch (type) {
        case 1: {
            length = CC_SHA1_DIGEST_LENGTH;
            digest = malloc(length * sizeof(uint8_t));
            CC_SHA1(hashData.bytes, (CC_LONG)hashData.length, digest);
        }
            break;
        case 256: {
            length = CC_SHA256_DIGEST_LENGTH;
            digest = malloc(length * sizeof(uint8_t));
            CC_SHA256(hashData.bytes, (CC_LONG)hashData.length, digest);
        }
            break;
        case 384: {
            length = CC_SHA384_DIGEST_LENGTH;
            digest = malloc(length * sizeof(uint8_t));
            CC_SHA384(hashData.bytes, (CC_LONG)hashData.length, digest);
        }
            break;
        case 512: {
            length = CC_SHA512_DIGEST_LENGTH;
            digest = malloc(length * sizeof(uint8_t));
            CC_SHA512(hashData.bytes, (CC_LONG)hashData.length, digest);
        }
            break;
        default:
            break;
    }
    
    if (NULL == digest || 0 == length) {
        return nil;
    }
    
    NSMutableString *result = [NSMutableString stringWithCapacity:length * 2];
    for(int i = 0; i < length; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    if (digest) {
        free(digest);
    }
    
    return result;
    
}


#pragma mark -
#pragma mark - aes

+ (NSString*)aesEncrypt:(NSString*)data key:(NSString*)key iv:(NSString*)iv
{
    NSData *aesData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesIV = [iv dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *result = [self aesEncryptWithData:aesData key:aesKey iv:aesIV];
    return ([[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
}

+ (NSData*)aesEncryptWithData:(NSData*)data key:(NSData*)key iv:(NSData*)iv
{
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    uint8_t *buffer = malloc(bufferSize *sizeof(uint8_t));
    memset((void*)buffer, 0, bufferSize);
    
    NSData *result = nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],     // Key
                                          [key length],    // kCCKeySizeAES
                                          [iv bytes],       // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (kCCSuccess == cryptStatus) {
        result = [[NSData alloc] initWithBytes:buffer length:encryptedSize];
    }
    
    if (buffer) {
        free(buffer);
    }
    
    return result;
}

+ (NSString*)aesDecrypt:(NSString*)data key:(NSString*)key iv:(NSString*)iv
{
    NSData *aesData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesIV = [iv dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *result = [self aesDecryptWithData:aesData key:aesKey iv:aesIV];
    return ([[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
}

+ (NSData*)aesDecryptWithData:(NSData*)data key:(NSData*)key iv:(NSData*)iv
{
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    uint8_t *buffer = malloc(bufferSize *sizeof(uint8_t));
    memset((void*)buffer, 0, bufferSize);
    
    NSData *result = nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],     // Key
                                          [key length],    // kCCKeySizeAES
                                          [iv bytes],       // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc] initWithBytes:buffer length:encryptedSize];
    }
    
    if (buffer) {
        free(buffer);
    }
    
    return result;
}


#pragma mark -
#pragma mark - rsa

+ (NSString*)rsaEncrypt:(NSString*)data key:(SecKeyRef)key
{
    NSData *rsaData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self rsaEncryptWithData:rsaData key:key];
    return ([result base64EncodedStringWithOptions:0]);
}

+ (NSData*)rsaEncryptWithData:(NSData*)data key:(SecKeyRef)key
{
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = data;
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [NSMutableData dataWithCapacity:0];
    
    for (int i=0; i<blockCount; i++) {
        int bufferSize = (int)MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        
        OSStatus status = SecKeyEncrypt(key,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        
        if (status == noErr){
            NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
            
        }else{
            
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer) {
        free(cipherBuffer);
    }
    
    return encryptedData;
}

- (NSString*)rsaDecrypt:(NSString*)data key:(SecKeyRef)key
{
    NSData *rsaData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self rsaDecryptWithData:rsaData key:key];
    return ([[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
}

- (NSData*)rsaDecryptWithData:(NSData*)data key:(SecKeyRef)key
{
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    size_t keyBufferSize = [data length];
    
    NSMutableData *bits = [NSMutableData dataWithLength:keyBufferSize];
    OSStatus sanityCheck = SecKeyDecrypt(key,
                                         kSecPaddingPKCS1,
                                         (const uint8_t *) [data bytes],
                                         cipherBufferSize,
                                         [bits mutableBytes],
                                         &keyBufferSize);
    
    if (sanityCheck != 0) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:sanityCheck userInfo:nil];
        ZXLog(@"Error: %@", [error description]);
    }
    [bits setLength:keyBufferSize];
    
    return bits;
}

@end
