//
//  TLTuleAdView.m
//  TL
//
//  Created by Rainbow on 2/12/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLTuleAdView.h"
#define LOGO_IMAGE_HEIGHT 60.f
#define LOGO_TEXT_HEIGHT 30.f
@implementation TLTuleAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGBA(0xCCCCCC, 1.f);
        //line
        CALayer *hlineLayer = [CALayer layer];
        
        hlineLayer.frame = CGRectMake(0.f, 2.f, CGRectGetWidth(frame), 1.f);
        hlineLayer.backgroundColor = UIColorFromRGBA(0x000000, 0.1).CGColor;
        [self.layer addSublayer:hlineLayer];

        
        
        UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame)-120)/2, (CGRectGetHeight(frame)-LOGO_IMAGE_HEIGHT-LOGO_TEXT_HEIGHT)/2, 120.f, LOGO_IMAGE_HEIGHT)];
        logoImage.image = [UIImage imageNamed:@"ico_loading_logo"];
        [self addSubview:logoImage];
        UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(logoImage.frame), CGRectGetWidth(frame), LOGO_TEXT_HEIGHT)];
        logoLabel.textAlignment = NSTextAlignmentCenter;
        logoLabel.font = FONT_14;
        logoLabel.text = @"一起发现，分享途上的乐趣";
        logoLabel.textColor = COLOR_MAIN_TEXT;
        [self addSubview:logoLabel];
        
    }
    return self;
}

@end
