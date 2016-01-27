//
//  TLLeftRawBox.m
//  TL
//
//  Created by Rainbow on 2/15/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLLeftRawBox.h"

@implementation TLLeftRawBox

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.arrawPaddingTop = self.arrawPaddingTop==0?10.f:self.arrawPaddingTop;
    CGFloat arrawWidth = 10.f;
    CGFloat arrawHeight = 10.f;

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(arrawWidth,0)];
    [bezierPath addLineToPoint:CGPointMake(arrawWidth,self.arrawPaddingTop)];
    [bezierPath addLineToPoint:CGPointMake(0.f,self.arrawPaddingTop+arrawHeight/2)];
    [bezierPath addLineToPoint:CGPointMake(arrawWidth,self.arrawPaddingTop+arrawHeight)];
    [bezierPath addLineToPoint:CGPointMake(arrawWidth,CGRectGetHeight(self.frame))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame),CGRectGetHeight(self.frame))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame),0)];
    [bezierPath addLineToPoint:CGPointMake(arrawWidth,0)];
    [bezierPath closePath];
    [UIColorFromRGBA(0xCCCCCC, 0.5) setFill];
    [bezierPath fill];
    
}


@end
