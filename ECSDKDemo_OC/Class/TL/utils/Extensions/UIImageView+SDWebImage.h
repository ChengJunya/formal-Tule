//
//  UIImageView+SDWebImage.h
//  alijk
//
//  Created by easy on 14-8-25.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"

#define DOWNLOAD_ERROR_IMAGE [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:@"pic_download_error"]

@interface UIImageView (SDWebImage)

- (void)setZXImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options  completed:(SDWebImageCompletionBlock)completedBlock;



- (void)setZXImageWithURL:(NSURL*)url placeholderImage:(UIImage*)placeholder;

/**
 *     非公共方法   add By Jerry
 *
 *     下载完成后用image的宽和高 来设置UIImageView   父视图的scale = 0.8  ;
 *
 */
- (void)setLargeZXImageWithURL:(NSURL*)url placeholderImage:(UIImage*)placeholder;

@end
