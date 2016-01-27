//
//  ImageViewZoom.h
//  alijk
//
//  Created by ZhongxinMac on 14-8-15.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageViewZoom : NSObject

/**
 *
 *
 *	图片放大缩小
 */
+ (void)showImage:(UIImageView*)gzyImageView;

/**
 *
 *
 *	图片放大缩小 传入大图url
 */
+ (void)showImage:(UIImageView *)gzyImageView withLargeImageUrl:(NSString *)urlStr;

@end
