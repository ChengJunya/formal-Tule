//
//  ZXTextView.m
//  自定义textView
//
//  Created by ZhongxinMac on 14-9-18.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "ZXTextView.h"
#import "UIImage+Pres.h"
#import "ZXTextViewHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface ZXTextView()<UITextViewDelegate>
@property (nonatomic,strong) ZXTextViewHelper *helper;
@property (nonatomic, strong) Void_Block retBlock;
@end
@implementation ZXTextView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.helper = [[ZXTextViewHelper alloc] init];
        self.delegate = self.helper;
        [self setScrollEnabled:YES];
        self.userInteractionEnabled = YES;
        self.showsVerticalScrollIndicator = YES;
        self.contentSize = CGSizeMake(0, 600);
        self.layer.borderColor =  UIColor.lightGrayColor.CGColor;
        self.layer.borderWidth = 0.5;
        [self.layer setCornerRadius:5.0];
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged:)name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
/**
 *
 *
 *  @param notification
 */
- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder]length] == 0)
    {
        return;
    }
    
    if([[self text] length] ==0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder]length] > 0 )
    {
        if ( self.placeHolderLabel == nil )
        {
            self.placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            
            self.placeHolderLabel.numberOfLines = 0;
            self.placeHolderLabel.font = self.font;
            self.placeHolderLabel.backgroundColor = [UIColor clearColor];
            self.placeHolderLabel.textColor = self.placeholderColor;
            self.placeHolderLabel.alpha = 0;
            self.placeHolderLabel.tag = 999;
            [self addSubview:self.placeHolderLabel];
        }
        
        self.placeHolderLabel.text = self.placeholder;
        [self.placeHolderLabel sizeToFit];
        [self sendSubviewToBack:self.placeHolderLabel];
    }
    
    if( [[self text] length] == 0&& [[self placeholder] length]> 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

- (void)setLargeTextLength:(NSInteger)largeTextLength
{
    _largeTextLength = largeTextLength;
    self.helper.largeTextLength = largeTextLength;
}

-(void)textViewEndEdit:(ZXTextView *)textView
{
    if (self.retBlock) {
        self.retBlock();
    }
}

- (void)dealloc
{
    self.placeholder = nil;
    self.placeholderColor = nil;
    self.placeHolderLabel = nil;
    self.delegate = nil;
    self.retBlock = nil;
}

@end
