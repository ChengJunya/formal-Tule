//
//  RUILabel.m
//  TL
//
//  Created by Rainbow on 2/25/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "RUILabel.h"

@implementation RUILabel

- (instancetype)initWithFrame:(CGRect)frame str:(NSString*)str font:(UIFont*)font color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        CGSize strSize = [str sizeWithAttributes:dic];
        self.bounds = CGRectMake(0.f, 0.f, strSize.width, strSize.height);
        self.frame = self.bounds;
        self.text = str;
        self.font = font;
        self.textColor = color;
    }
    return self;
}

@end
