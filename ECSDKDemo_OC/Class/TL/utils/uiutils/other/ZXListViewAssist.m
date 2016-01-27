//
//  ZXListViewAssist.m
//  alijk
//
//  Created by easy on 14/11/14.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "ZXListViewAssist.h"

@interface ZXListViewAssist () {
    UIImageView *_imageView;
    UILabel *_showLabel;
}

@property (nonatomic, weak) UIView *attachView;
@property (nonatomic, strong) UITapGestureRecognizer *tapRetry;

@end

@implementation ZXListViewAssist

- (id)initWithAttachView:(UIView*)attachView {
    if (self = [super initWithFrame:attachView.bounds]) {
        self.attachView = attachView;
        self.backgroundColor = COLOR_DEF_BG;
        
        [self addAllUIResources];
        [self setShowType:ELAST_LOADING showLabel:nil];
    }
    
    return self;
}

- (void)dealloc
{
    
}

- (void)addAllUIResources {
    if (nil != _imageView) {
        return;
    }
   
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 90.f, 90.f)];
    imageView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame)/3.f);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    _imageView = imageView;
    
    CGRect lableRect = CGRectMake(0.f, CGRectGetMaxY(imageView.frame) + 10.f, SCREEN_WIDTH, 30.f);
    UILabel *showLabel = [[UILabel alloc] initWithFrame:lableRect];
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.backgroundColor = [UIColor clearColor];
    showLabel.font = FONT_16;
    showLabel.textColor = COLOR_ASSI_TEXT;
    [self addSubview:showLabel];
    _showLabel = showLabel;
    
}

- (void)setShowType:(EListAssistShowType)showType showLabel:(NSString*)showLabel
{
    switch (showType) {
        case ELAST_LOADING: {
            _imageView.image = [UIImage imageNamed:@"ico_loading_logo"];
            _showLabel.text = @"";
            
        }
            break;
        case ELAST_EMPTY: {
            _imageView.image = [UIImage imageNamed:@"ico_nodate"];
            _showLabel.text = showLabel;
            CGSize showLabelSize = [_showLabel boundingRectWithSize:CGSizeMake( (DEVICE_WIDTH - 4 * UI_LAYOUT_MARGIN), 1000)];
            _showLabel.frame = CGRectMake((DEVICE_WIDTH - showLabelSize.width)/2, CGRectGetMaxY(_imageView.frame) + 10.f, showLabelSize.width, showLabelSize.height);
        }
            break;
        case ELAST_RETRY: {
            _imageView.image = [UIImage imageNamed:@"ico_loading_logo"];
            _showLabel.text = @"点击屏幕，重新加载";
            _showLabel.frame = CGRectMake(0.f, CGRectGetMaxY(_imageView.frame) + 10.f, SCREEN_WIDTH, 30.f);
        }
            break;
        default:
            break;
    }
    self.hidden = (ELAST_HIDE == showType);
}

- (void)setRetryWithTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tapRetry = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapRetry];
    self.tapRetry = tapRetry;
}

@end
