//
//  MBHUDView.m
//  Notestand
//
//  Created by M B. Bitar on 9/30/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import "MBHUDView.h"
#import "MBSpinningCircle.h"
#import <QuartzCore/QuartzCore.h>
#import "MBCheckmarkView.h"
#import "UIView+Animations.h"
#import "MBAlertViewSubclass.h"

@interface MBHUDView ()
{
    UIButton *_backgroundButton;
    MBCheckMarkView *_checkMark;
    MBSpinningCircle *_activityIndicator;
}
@end

@implementation MBHUDView
@synthesize bodyLabelButton = _bodyLabelButton, imageView = _imageView, bodyFont = _bodyFont;

+(MBHUDView*)hudWithSuperView:(UIView *)view  show:(BOOL)show{
    MBHUDView *alert = [[MBHUDView alloc] init];
    alert.superView = view;
    alert.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    alert.hudType = MBAlertViewHUDTypeActivityIndicator;
    if(show)
        [alert addToDisplayQueue];
    return alert;
}

+(MBHUDView*)hudWithBody:(NSString*)body type:(MBAlertViewHUDType)type hidesAfter:(float)delay show:(BOOL)show
{
    MBHUDView *alert = [[MBHUDView alloc] init];
    alert.bodyText = body;
    alert.hudType = type;
    alert.hudHideDelay = delay;
    alert.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    
    if(type == MBAlertViewHUDTypeExclamationMark)
    {
        alert.hudType = MBAlertViewHUDTypeLabelIcon;
        alert.iconLabel.textColor = [UIColor whiteColor];
        alert.iconLabel.text = @"!";
        alert.iconLabel.font = [UIFont boldSystemFontOfSize:60];
        alert.bodyOffset = CGSizeMake(0, 0);
    }
    
    if(show)
        [alert addToDisplayQueue];
    return alert;
}

-(CGSize)hudSize
{
    if(CGSizeEqualToSize(self.size, CGSizeZero))
        return CGSizeMake(125, 125);
    return self.size;
}

-(UILabel*)iconLabel
{
    if(_iconLabel)
        return _iconLabel;
    _iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _iconLabel.backgroundColor = [UIColor clearColor];
    _iconLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    return _iconLabel;
}

-(UIFont*)bodyFont
{
    if(_bodyFont)
        return _bodyFont;
    float size = 0;
    [self.bodyText sizeWithFont:[UIFont boldSystemFontOfSize:26] minFontSize:6 actualFontSize:&size forWidth:self.contentRect.size.width / 1.3 lineBreakMode:NSLineBreakByTruncatingTail];
    _bodyFont = [UIFont boldSystemFontOfSize:size];
    return _bodyFont;
}

-(UIButton*)bodyLabelButton
{
    if(_bodyLabelButton)
        return _bodyLabelButton;
    
    UIFont *font = self.bodyFont;
    CGRect bounds = self.contentRect;
    CGSize size = [self.bodyText sizeWithFont:font];
    _bodyLabelButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x + bounds.size.width/2.0 - size.width/2.0, bounds.size.height/2.0 - size.height/2.0 - 8, size.width, size.height)];

    [_bodyLabelButton setTitle:self.bodyText forState:UIControlStateNormal];
    _bodyLabelButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    _bodyLabelButton.titleLabel.text = self.bodyText;
    _bodyLabelButton.titleLabel.font = font;
    _bodyLabelButton.titleLabel.numberOfLines = 0;

    _bodyLabelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_bodyLabelButton];
    return _bodyLabelButton;
}


-(UIImageView*)imageView
{
    if(_imageView)
        return _imageView;
    _imageView = [[UIImageView alloc] init];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    return _imageView;
}

-(void)loadView
{
//    self.view.height = self.superView.height;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:bounds];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    CGRect rect;
    rect.size = CGSizeMake(50.5, 50.5);
    if (self.superView) {
        rect.origin = CGPointMake(self.view.bounds.size.width/2.0 - rect.size.width/2.0, self.superView.height/2.0 - rect.size.height/2.0);
    }else{
        rect.origin = CGPointMake(self.view.bounds.size.width/2.0 - rect.size.width/2.0, self.view.bounds.size.height/2.0 - rect.size.height/2.0);
    }
    self.contentRect = rect;
    _backgroundButton = [[UIButton alloc] initWithFrame:self.contentRect];
    _backgroundButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    _backgroundButton.alpha = 0.85;
    _backgroundButton.backgroundColor = [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:0.9];
    [self.view addSubview:_backgroundButton];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
//    CGPoint point = [self.view convertPoint:_backgroundButton.origin toView:window];
    
//    CGRect point = [self.view convertRect:_backgroundButton.frame toView:window];
    
//    _backgroundButton.top = point.origin.y;
//   _backgroundButton.left = point.origin.x;
    
    _backgroundButton.layer.cornerRadius = 8;
}
/*
-(void)addToWindow
{
    [super addToWindow];
//    if(self.hudHideDelay > 0)
//        self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:self.hudHideDelay target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}*/

-(void)layoutView
{
    CGRect bodyRect = self.bodyLabelButton.frame;
    
    if(_imageView)
    {
        [_imageView sizeToFit];
        CGRect rect = self.imageView.frame;
        rect.origin = CGPointMake(self.contentRect.origin.x + (self.contentRect.size.width/2.0 - rect.size.width/2.0), 0);
        self.imageView.frame = rect;
        [self.view addSubview:self.imageView];
    }
    
    else if(_hudType == MBAlertViewHUDTypeActivityIndicator)
    {
        // modify by easy begin on 2014-11-19
        // 程序进入后台，再重新进入程序后，动画无法启动
        if (!_activityIndicator) {
            _activityIndicator = [MBSpinningCircle circleWithSize:NSSpinningCircleSizeLarge color:[UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1.0]];
            CGRect circleRect = _activityIndicator.frame;
            circleRect.origin = CGPointMake(_backgroundButton.width/2.0 - circleRect.size.width/2.0, _backgroundButton.height / 2 - _activityIndicator.height / 2);
            _activityIndicator.frame = circleRect;
            _activityIndicator.circleSize = NSSpinningCircleSizeLarge;
            _activityIndicator.isAnimating = YES;
            _activityIndicator.speed = 0.55;
            [_backgroundButton addSubview:_activityIndicator];
        }
        _activityIndicator.isAnimating = YES;
        // modify by easy end on 2014-11-19
    }
    
    else if(_hudType == MBAlertViewHUDTypeCheckmark)
    {
        _checkMark = [MBCheckMarkView checkMarkWithSize:MBCheckmarkSizeLarge color:[UIColor whiteColor]];
        _checkMark.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        CGRect rect = _checkMark.frame;
        rect.origin = CGPointMake(self.view.bounds.size.width/2.0 - rect.size.width/2.0, 50);
        _checkMark.frame = rect;
        [self.view addSubview:_checkMark];
        
        float height = _backgroundButton.frame.size.height;
        float totalHeight = _checkMark.frame.size.height + _bodyLabelButton.frame.size.height;
        rect.origin = CGPointMake(rect.origin.x, self.contentRect.origin.y + (height/2.0 - totalHeight/2.0));
        _checkMark.frame = rect;
        
        rect = _bodyLabelButton.frame;
        rect.origin = CGPointMake(rect.origin.x, _checkMark.frame.origin.y + _checkMark.frame.size.height);
        _bodyLabelButton.frame = rect;
    }
    else if(_hudType == MBAlertViewHUDTypeLabelIcon || self.iconLabel.text)
    {
        [self.iconLabel sizeToFit];
        CGRect rect = self.iconLabel.frame;
        rect.origin = CGPointMake(self.view.bounds.size.width/2.0 - rect.size.width/2.0 + self.iconOffset.width, bodyRect.origin.y - rect.size.height - 30 + self.iconOffset.height);
        self.iconLabel.frame = rect;
        [self.view addSubview:self.iconLabel];

    }
    
    
//    CALayer *layer = _bodyLabelButton.layer;
//    layer.shadowColor = [UIColor whiteColor].CGColor;
//    layer.shadowOffset = CGSizeMake(0, 0);
//    layer.shadowOpacity = 0.1;
//    layer.shadowPath = [UIBezierPath bezierPathWithRect:_bodyLabelButton.bounds].CGPath;
//    layer.shadowRadius = 10.0;
    
}

-(void)centerViews
{
    if(_imageView)
    {
        [_backgroundButton centerViewsVerticallyWithin:@[@{@"view" : self.imageView, @"offset" : [NSNumber numberWithFloat:self.iconOffset.height]}, @{@"view" : self.bodyLabelButton, @"offset" : [NSNumber numberWithFloat:10 + _bodyOffset.height]}]superView:self.superView];
    }
    else if(_hudType == MBAlertViewHUDTypeActivityIndicator)
    {
        [_backgroundButton centerViewsVerticallyWithin:@[@{@"view" : _activityIndicator, @"offset" : [NSNumber numberWithFloat:self.iconOffset.height]}, @{@"view" : self.bodyLabelButton, @"offset" : [NSNumber numberWithFloat:0]}]superView:self.superView];
    }
    else if(_hudType == MBAlertViewHUDTypeCheckmark)
    {
        [_backgroundButton centerViewsVerticallyWithin:@[@{@"view" : _checkMark, @"offset" : [NSNumber numberWithFloat:self.iconOffset.height]}, @{@"view" : self.bodyLabelButton, @"offset" : [NSNumber numberWithFloat:10]}]superView:self.superView];
    }
    else if(_hudType == MBAlertViewHUDTypeLabelIcon || self.iconLabel.text)
    {
        [_backgroundButton centerViewsVerticallyWithin:@[@{@"view" : self.iconLabel, @"offset" : [NSNumber numberWithFloat:self.iconOffset.height]}, @{@"view" : self.bodyLabelButton, @"offset" : [NSNumber numberWithFloat:self.bodyOffset.height]}]superView:self.superView];
    }
    else
    {
        [_backgroundButton centerViewsVerticallyWithin:@[@{@"view" : _bodyLabelButton, @"offset" : [NSNumber numberWithFloat:self.bodyOffset.height]}]superView:self.superView];
    }

}

- (void)viewDidLoad
{
    [self layoutView];
	// Do any additional setup after loading the view.
}

- (void)dealloc{
    
}

@end
