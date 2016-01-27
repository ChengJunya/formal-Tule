//
//  TLStarLevel.m
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLStarLevel.h"

@implementation TLStarLevel

- (instancetype)initWithFrame:(CGRect)frame level:(NSUInteger)level currentLevel:(NSUInteger)currentLevel
{
    self = [super initWithFrame:frame];
    if (self) {

        self.level = level;
        self.currentLevel = currentLevel;
        self.isStarSelect = NO;
        [self setupView];
    }
    return self;
}

-(void)setupView{
    CGFloat xOffSet = 10.f;
    CGFloat hGap = 10.f;
    CGFloat vGap = 10.f;
    CGFloat starHeight = CGRectGetHeight(self.frame)-vGap*2;
    
    for (int i=0; i<self.level; i++) {
        if ([self viewWithTag:(i+1)]) {
            [[self viewWithTag:(i+1)] removeFromSuperview];
        }
    }
    
    for (int i=0; i<self.level; i++) {
        UIImageView *star = [[UIImageView alloc] initWithFrame:CGRectMake(xOffSet+(hGap+starHeight)*i, vGap, starHeight, starHeight)];
        star.tag = i+1;
        star.onTouchTapBlock = ^(UIImageView *imageView){
            if (self.isStarSelect) {
                self.currentLevel = imageView.tag;
                [self setupView];
            }
           
        };
        if (i<self.currentLevel) {
            star.image = [UIImage imageNamed:@"star1"];
        }else{
            star.image = [UIImage imageNamed:@"star2"];
        }
        [self addSubview:star];
    }
}



@end
