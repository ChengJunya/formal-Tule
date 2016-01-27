//
//  RIconTextBtn.m
//  TL
//
//  Created by Rainbow on 2/10/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "RIconTextBtn.h"

@implementation RIconTextBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageSize = CGSizeMake(CGRectGetHeight(self.frame)-4, CGRectGetHeight(self.frame)-4);
        // 设置imageEdgeInsets
        CGFloat imageEdgeInsetsTop = 0.f;
        CGFloat imageEdgeInsetsLeft = 0.f;
        CGFloat imageEdgeInsetsBottom = 0.f;
        CGFloat imageEdgeInsetsRight = CGRectGetWidth(self.frame)-self.imageSize.width-4.f;
        self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
//        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 设置titleEdgeInsets
        CGFloat titleEdgeInsetsTop = 2.f;
        CGFloat titleEdgeInsetsLeft = 2.f;
        CGFloat titleEdgeInsetsBottom = 2.f;
        CGFloat titleEdgeInsetsRight = 2.f;
        self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);

        
        
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withImageSize:(CGSize)imageSize
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageSize = imageSize;
//        self.imageSize = CGSizeMake(CGRectGetHeight(self.frame)-4, CGRectGetHeight(self.frame)-4);
        // 设置imageEdgeInsets
        CGFloat imageEdgeInsetsTop = 0.f;
        CGFloat imageEdgeInsetsLeft = 4.f;
        CGFloat imageEdgeInsetsBottom = 0.f;
        CGFloat imageEdgeInsetsRight = CGRectGetWidth(self.frame)-self.imageSize.width-4.f;
        self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
        //        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 设置titleEdgeInsets
        CGFloat titleEdgeInsetsTop = 2.f;
        CGFloat titleEdgeInsetsLeft = 8.f;
        CGFloat titleEdgeInsetsBottom = 2.f;
        CGFloat titleEdgeInsetsRight = 2.f;
        self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
        
        
        
        
    }
    return self;
}

@end
