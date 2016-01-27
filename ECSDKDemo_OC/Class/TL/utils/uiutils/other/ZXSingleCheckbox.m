//
//  ZXSingleCheckbox.m
//  alijk
//
//  Created by easy on 14-7-31.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "ZXSingleCheckbox.h"

#define kZXSingleCheckboxDefaultSide                  20.f
#define kZXSingleCheckboxDefaultRadius                4.f
#define kZXSingleCheckboxDefaultStrokeWidth           1.f
#define kZXSingleCheckboxDefaultStrokeColor           RGBColor(110.f, 186.f, 89.f, 1.f)
#define kZXSingleCheckboxDefaultCheckColor            ([UIColor whiteColor])
#define kZXSingleCheckboxDefaultFillColorNormal       ([UIColor whiteColor])
#define kZXSingleCheckboxDefaultFillColorSelected     RGBColor(110.f, 186.f, 89.f, 1.f)


@interface ZXSingleCheckbox ()
{
    UILabel *_textLabel;
}
@end


@implementation ZXSingleCheckbox

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.strokeWidth = kZXSingleCheckboxDefaultStrokeWidth;
        self.strokeColor = kZXSingleCheckboxDefaultStrokeColor;
        
        self.checkColor = kZXSingleCheckboxDefaultCheckColor;
        
        self.fillColorNormal = kZXSingleCheckboxDefaultFillColorNormal;
        self.fillColorSelected = kZXSingleCheckboxDefaultFillColorSelected;
        
        self.side = kZXSingleCheckboxDefaultSide;
        self.radius = kZXSingleCheckboxDefaultRadius;
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
    }
    
    return self;
}

- (void)dealloc
{
    self.block = nil;
}


#pragma mark -
#pragma mark - drawRect

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat textLabelOriginX = self.side + 5.0;
    CGSize textLabelMaxSize = CGSizeMake(CGRectGetWidth(self.bounds) - textLabelOriginX, CGRectGetHeight(self.bounds));
    
    CGSize textLabelSize;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        textLabelSize = [self.textLabel.text sizeWithAttributes:@{NSFontAttributeName : self.textLabel.font}];
    } else {
        textLabelSize = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:textLabelMaxSize lineBreakMode:self.textLabel.lineBreakMode];
    }
    
    self.textLabel.frame = CGRectIntegral(CGRectMake(textLabelOriginX, (CGRectGetHeight(self.bounds) - textLabelSize.height) / 2.0, textLabelSize.width, textLabelSize.height));
}

- (void)drawRect:(CGRect)rect
{
    CGRect frame = CGRectIntegral(CGRectMake(0, (rect.size.height - self.side) / 2.0, self.side, self.side));
    
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.05000 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.05000 + 0.5), floor(CGRectGetWidth(frame) * 0.95000 + 0.5) - floor(CGRectGetWidth(frame) * 0.05000 + 0.5), floor(CGRectGetHeight(frame) * 0.95000 + 0.5) - floor(CGRectGetHeight(frame) * 0.05000 + 0.5)) cornerRadius:self.radius];
    roundedRectanglePath.lineWidth = 2 * self.side / kZXSingleCheckboxDefaultSide;
    [self.strokeColor setStroke];
    [roundedRectanglePath stroke];
    
    if (self.isChecked)
    {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(frame) + 0.75000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.21875 * CGRectGetHeight(frame))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.40000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52500 * CGRectGetHeight(frame))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.28125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37500 * CGRectGetHeight(frame))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.17500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47500 * CGRectGetHeight(frame))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.40000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.75000 * CGRectGetHeight(frame))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.81250 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.28125 * CGRectGetHeight(frame))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.75000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.21875 * CGRectGetHeight(frame))];
        [bezierPath closePath];
        
        [self.fillColorSelected setFill];
        [roundedRectanglePath fill];
        
        [self.checkColor setFill];
        [bezierPath fill];
    }
    else
    {
        [self.fillColorNormal setFill];
        [roundedRectanglePath fill];
    }
}

- (void)setIsChecked:(BOOL)value
{
    _isChecked = value;
    [self setNeedsDisplay];
}


#pragma mark -
#pragma mark - touch event

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, location)) {
        _isChecked = !self.isChecked;
        if (self.block) {
            self.block(self.isChecked);
        }
        [self setNeedsDisplay];
    }
}

@end
