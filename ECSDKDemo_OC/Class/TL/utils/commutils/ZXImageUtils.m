//
//  IOSUtils.m
//  IOSUtils
//
//  Created by easy on 14/11/4.
//  Copyright (c) 2014年 easy. All rights reserved.
//

#import "ZXImageUtils.h"
#import "UIImage+ImageEffects.h"

@implementation ZXImageUtils

+ (void)dealWithPixel:(UInt8*)pixelBuf offset:(int)offset toReplaceColor:(int[])toReplaceColor relpaceColor:(int[])replaceColor range:(CGFloat)range
{
    int r = offset;         // red
    int g = offset + 1;     // green
    int b = offset + 2;     // blue
    int a = offset + 3;     // alpha
    
    int red = pixelBuf[r];
    int green = pixelBuf[g];
    int blue = pixelBuf[b];
    
    if (fabs(red-toReplaceColor[0]) < range  &&
        fabs(green-toReplaceColor[1]) < range &&
        fabs(blue-toReplaceColor[2]) < range) {
        pixelBuf[r] = replaceColor[0];
        pixelBuf[g] = replaceColor[1];
        pixelBuf[b] = replaceColor[2];
        pixelBuf[a] = replaceColor[3];
    }
}

+ (UIImage*)createWithImage:(UIImage*)image toReplaceColor:(int[])toReplaceColor relpaceColor:(int[])replaceColor range:(CGFloat)range
{
    if (nil == image) {
        return nil;
    }
    
    CGImageRef imageRef = [image CGImage];
    CGDataProviderRef providerRef = CGImageGetDataProvider(imageRef);
    CFDataRef dataRef = CGDataProviderCopyData(providerRef);
    CFMutableDataRef mutableData = CFDataCreateMutableCopy(0, 0, dataRef);
    CFRelease(dataRef);
    
    UInt8* pixelBuf = (UInt8*)CFDataGetMutableBytePtr(mutableData);
    NSInteger length = CFDataGetLength(mutableData);
    for (int i = 0; i < length; i += 4)
    {
        [self dealWithPixel:pixelBuf offset:i toReplaceColor:toReplaceColor relpaceColor:replaceColor range:range];
    }
    
    CGContextRef ctx = CGBitmapContextCreate(pixelBuf,
                                             CGImageGetWidth(imageRef),
                                             CGImageGetHeight(imageRef),
                                             CGImageGetBitsPerComponent(imageRef),
                                             CGImageGetBytesPerRow(imageRef),
                                             CGImageGetColorSpace(imageRef),
                                             (CGBitmapInfo)kCGImageAlphaPremultipliedLast
                                             );
    
    CGImageRef newImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    CFRelease(mutableData);
    
    return ([UIImage imageWithCGImage:newImage]);
}

+ (UIImage*)blendImages:(NSArray*)images frames:(NSArray*)frames canvasSize:(CGSize)canvaSize
{
    if ([images count] != [frames count]) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0.f, 0.f, canvaSize.width, canvaSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 2.f);
    for (NSInteger index = 0; index < [images count]; index++) {
        UIImage *image = images[index];
        CGRect frame = [frames[index] CGRectValue];
        [image drawInRect:frame];
    }
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)circleImageWithRadius:(CGFloat)radius red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    CGRect rect = CGRectMake(0.f, 0.f, (NSInteger)radius * 2.f, (NSInteger)radius * 2.f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    CGContextFillEllipseInRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)orangeCircleWithRadius:(CGFloat)radius
{
    return ([self circleImageWithRadius:radius red:1.f green:80.f/255.f blue:4.f/255.f alpha:1.f]);
}


+ (UIImage*)hollowBlurImageWithRect:(CGRect)rect hollowRect:(CGRect)hollowRect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetRGBFillColor(context, 1.f, 1.f, 1.f, 0.2f);
    CGContextFillRect(context, rect);
    
    UIImage *baseImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurImae = [baseImage applyDarkEffect];
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    [blurImae drawInRect:rect];
    [baseImage drawInRect:hollowRect blendMode:kCGBlendModeDestinationIn alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
