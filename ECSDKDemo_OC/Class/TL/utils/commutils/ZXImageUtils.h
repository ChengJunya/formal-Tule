//
//  IOSUtils.h
//  IOSUtils
//
//  Created by easy on 14/11/4.
//  Copyright (c) 2014年 easy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ZXImageUtils : NSObject

+ (UIImage*)createWithImage:(UIImage*)image toReplaceColor:(int[])toReplaceColor relpaceColor:(int[])replaceColor range:(CGFloat)range;

+ (UIImage*)blendImages:(NSArray*)images frames:(NSArray*)frames canvasSize:(CGSize)canvaSize;

+ (UIImage *)circleImageWithRadius:(CGFloat)radius red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIImage*)orangeCircleWithRadius:(CGFloat)radius;

+ (UIImage*)hollowBlurImageWithRect:(CGRect)rect hollowRect:(CGRect)hollowRect;

@end
