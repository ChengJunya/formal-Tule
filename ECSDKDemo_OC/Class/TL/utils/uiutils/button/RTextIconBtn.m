//
//  RTextIconBtn.m
//  TL
//
//  Created by Rainbow on 2/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "RTextIconBtn.h"

@implementation RTextIconBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageSize = CGSizeMake(CGRectGetHeight(self.frame)-4, CGRectGetHeight(self.frame)-4);
        // 设置imageEdgeInsets
        CGFloat imageEdgeInsetsTop = 2.f;
        CGFloat imageEdgeInsetsLeft = CGRectGetWidth(self.frame)-self.imageSize.width+10.f;
        CGFloat imageEdgeInsetsBottom = 2.f;
        CGFloat imageEdgeInsetsRight = 2.f;
        self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        // 设置titleEdgeInsets
        CGFloat titleEdgeInsetsTop = 2.f;
        CGFloat titleEdgeInsetsLeft = -self.imageSize.width;
        CGFloat titleEdgeInsetsBottom = 2.f;
        CGFloat titleEdgeInsetsRight = 2.f;
        self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
        
        
        
        
    }
    return self;
}

@end
