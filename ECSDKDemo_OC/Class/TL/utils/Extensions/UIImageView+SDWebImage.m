//
//  UIImageView+SDWebImage.m
//  alijk
//
//  Created by easy on 14-8-25.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "UIImageView+SDWebImage.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"

@implementation UIImageView (SDWebImage)

- (void)setZXImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options  completed:(SDWebImageCompletionBlock)completedBlock {
    if (url) {
//        __block UIActivityIndicatorView *activityIndicator;
        __weak UIImageView *weakSelf = self;
        
        [self loadErrorImage];
        
        __block UIImage *currentImage = self.image;

//        if (!activityIndicator) {
//            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//            if (self.width ==0 || self.height == 0) {
//                activityIndicator.frame = CGRectMake(SCREEN_WIDTH/2 - 20/2, SCREEN_HEIGHT/2 - 20/2, 20, 20);
//            }else{
//                activityIndicator.frame = CGRectMake(self.width/2 - 20/2, self.height/2 - 20/2, 20, 20);
//            }
//        }
//        [weakSelf addSubview:activityIndicator];
//        [activityIndicator startAnimating];

        [self sd_setImageWithURL:url
                placeholderImage:placeholder
                         options:SDWebImageProgressiveDownload
                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
//                             if (!activityIndicator) {
//                                 activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                                 activityIndicator.frame = CGRectMake(self.width/2 - 20/2, self.height/2 - 20/2, 20, 20);
//                             }
//                             [weakSelf addSubview:activityIndicator];
//                             [activityIndicator startAnimating];
                        }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           /*
                            if (currentImage == DOWNLOAD_ERROR_IMAGE || error) {
                            // 延迟0.5秒执行：
                                
                                double delayInSeconds = 5;
                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                    [activityIndicator removeFromSuperview];
                                    activityIndicator = nil;
                                });
                            }else{
                                [activityIndicator removeFromSuperview];
                                activityIndicator = nil;
                            }*/
//                           NSLog(@"activityIndicator  %@", activityIndicator);
                           if (error) {
                               if (currentImage) {
                                   self.image = currentImage;
                               }else{
                                   self.image = DOWNLOAD_ERROR_IMAGE;
                               }
                           }else{
                               self.contentMode = UIViewContentModeScaleAspectFit;
                               self.image = image;
                           }
                           completedBlock(image,error,cacheType,imageURL);
                       }];
    }
}

- (void)setZXImageWithURL:(NSURL*)url placeholderImage:(UIImage*)placeholder
{
    if (url) {
        __block UIActivityIndicatorView *activityIndicator;
        __weak UIImageView *weakSelf = self;
        
        __block UIImage *currentImage = self.image;
        
        [self loadErrorImage];
        
        if (self.image != nil && self.image == DOWNLOAD_ERROR_IMAGE) {
            if (!activityIndicator) {
                activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
               activityIndicator.frame = CGRectMake(self.width/2 - 20/2, self.height/2 - 20/2, 20, 20);
            }
            [weakSelf addSubview:activityIndicator];
            [activityIndicator startAnimating];
        }

        [self sd_setImageWithURL:url
                placeholderImage:placeholder
                         options:SDWebImageProgressiveDownload
                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                            if (!activityIndicator) {
                                activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                                activityIndicator.frame = CGRectMake(self.width/2 - 20/2, self.height/2 - 20/2, 20, 20);
                            }
                            [weakSelf addSubview:activityIndicator];
                            [activityIndicator startAnimating];
                        }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           
                           if (currentImage == DOWNLOAD_ERROR_IMAGE || error) {
                               // 延迟0.5秒执行：
                               double delayInSeconds = 0.5;
                               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                               dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                   [activityIndicator removeFromSuperview];
                                   activityIndicator = nil;
                               });
                           }else{
                               [activityIndicator removeFromSuperview];
                               activityIndicator = nil;
                           }
                           if (error) {
                               if (currentImage) {
                                   self.image = currentImage;
                               }else{
                                   self.image = (placeholder ? placeholder : DOWNLOAD_ERROR_IMAGE);
                               }
                           }else{
                               self.contentMode = UIViewContentModeScaleAspectFit;
                               self.image = image;
                           }
                       }];
     }
}

- (void)setLargeZXImageWithURL:(NSURL*)url placeholderImage:(UIImage*)placeholder
{
    if (url) {
        __block UIActivityIndicatorView *activityIndicator;
        __weak UIImageView *weakSelf = self;
        
        [self loadErrorImage];
        
        __block UIImage *currentImage = self.image;
        if (self.image != nil && self.image == DOWNLOAD_ERROR_IMAGE) {
            if (!activityIndicator) {
                activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.frame = CGRectMake(self.width/2 - 20/2, self.height/2 - 20/2, 20, 20);
            }
            [weakSelf addSubview:activityIndicator];
            [activityIndicator startAnimating];
        }
        [self sd_setImageWithURL:url
                placeholderImage:placeholder
                         options:SDWebImageProgressiveDownload
                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            if (!activityIndicator) {
                                activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                                activityIndicator.frame = CGRectMake(self.width/2 - 20/2 + 13, self.height/2 - 20/2 + 13, 20, 20);
                            }
                            
                            [weakSelf addSubview:activityIndicator];
                            [activityIndicator startAnimating];
                        }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           
                           if (currentImage == DOWNLOAD_ERROR_IMAGE || error) {
                               // 延迟0.5秒执行：
                               double delayInSeconds = 0.5;
                               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                               dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                   [activityIndicator removeFromSuperview];
                                   activityIndicator = nil;
                               });
                           }else{
                               [activityIndicator removeFromSuperview];
                               activityIndicator = nil;
                           }
                           if (error) {
                               if (currentImage) {
                                   self.image = currentImage;
                               }else{
                                   self.image = DOWNLOAD_ERROR_IMAGE;
                               }
                           }else{
                               self.contentMode = UIViewContentModeScaleAspectFit;
                               self.image = image;
                               [UIView animateWithDuration:0.3 animations:^{
                                   self.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
                               } completion:^(BOOL finished) {}];
                           }
                       }];
    }
}

- (void)loadErrorImage{
    UIImage *pic_download_error = DOWNLOAD_ERROR_IMAGE;
    if (!pic_download_error) {
        [[SDImageCache sharedImageCache] storeImage:[UIImage imageNamed:@"pic_download_error.png"] forKey:@"pic_download_error" toDisk:NO];
    }
}

- (void)loadActivityIndicator:(UIActivityIndicatorView *)activityIndicator WithWeakSelf:(UIImageView *) wself{
    if (!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(self.width/2 - 20/2, self.height/2 - 20/2, 20, 20);
    }
    [wself addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

@end
