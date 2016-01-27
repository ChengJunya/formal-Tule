//
//  ZXTextField.m
//  alijk
//
//  Created by easy on 14-8-6.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "ZXTextField.h"
#import "ZXTextFieldDelegateHelper.h"


//@interface MHTextField (SuperPrivate)
//
//- (void) doneButtonIsClicked:(id)sender;
//
//@end


@interface ZXTextField () <UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITapGestureRecognizer* gesRecognizer;
@property (nonatomic, strong) ZXTextFieldDelegateHelper *textFieldDelegateHelper;
@property (nonatomic,assign) CGFloat leftMargin;
@end


@implementation ZXTextField

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self applyStyle];
        [self addNotification];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.textFieldDelegateHelper = [[ZXTextFieldDelegateHelper alloc] init];
        self.delegate = self.textFieldDelegateHelper;
        self.textFieldDelegateHelper.textField = self;
        _zxBorderWidth = 0.8f;
        _leftMargin = 10.f;
        
        
       

    }
    
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    self.retBlock = nil;
    [self removeGesRecognizer];
    [self removeNotification];
}

- (void)setLargeTextLength:(NSInteger)largeTextLength
{
    _largeTextLength = largeTextLength;
    self.textFieldDelegateHelper.largeTextLength = largeTextLength;
}

- (void)setZxBorderWidth:(CGFloat)zxBorderWidth
{
    _zxBorderWidth = zxBorderWidth;
    [self setNeedsDisplay];
}

- (void)applyStyle
{
    [self setBorderStyle:UITextBorderStyleNone];
    [self setFont:FONT_14];
    if ([self respondsToSelector:@selector(setTintColor:)])
        [self setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    
    [self setBackgroundColor:[UIColor whiteColor]];
}

//- (void)setNeedsAppearance:(id)sender
//{
//    MHTextField *textField = (MHTextField*)sender;
//    
//    if (![textField isEnabled])
//        [self setBackgroundColor:[UIColor lightGrayColor]];
//    else
//        [self setBackgroundColor:[UIColor whiteColor]];
//}

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, _leftMargin, 5);
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, _leftMargin, 5);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    
    [layer setBorderWidth: _zxBorderWidth];
    [layer setBorderColor: [UIColor colorWithWhite:0.1 alpha:0.2].CGColor];
    [layer setCornerRadius:5.0];
    
    if (_zxBorderWidth > 0.f) {
        [layer setShadowOpacity:1.0];
        [layer setShadowColor:[UIColor redColor].CGColor];
        [layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.autoHideKeyboard) {
//        [self addGesRecognizer];
    }
}

-(void)setLeftIconName:(NSString *)leftIconName{
    _leftIconName = leftIconName;
    UIImage *icon = [UIImage imageNamed:leftIconName];
    
    //make an imageview to show an icon on the left side of textfield
    UIImageView * iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f,CGRectGetHeight(self.frame) , CGRectGetHeight(self.frame))];
    [iconImage setImage:icon];
    [iconImage setContentMode:UIViewContentModeCenter];
    self.leftView = iconImage;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    _leftMargin = CGRectGetHeight(self.frame);
    
    [self setNeedsDisplay];
    
    
    
}

-(void)setUnderLineIconName:(NSString *)underLineIconName{
    _leftIconName = underLineIconName;
    UIImage *icon = [UIImage imageNamed:underLineIconName];
    
    //make an imageview to show an icon on the left side of textfield
    UIImageView * iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.frame)-2.f,CGRectGetWidth(self.frame) , 2.f)];
    [iconImage setImage:icon];
    [iconImage setContentMode:UIViewContentModeBottom];
    [self addSubview:iconImage];
    _zxBorderWidth = 0;
    //self.rightViewMode = UITextFieldViewModeAlways;
    [self setBackgroundColor:[UIColor clearColor]];
    
    
    [self setNeedsDisplay];
    
    
    
}


#pragma mark -
#pragma mark - notification

- (void)addNotification
{
    [self addTarget:self action:@selector(textFieldEndEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)removeNotification
{
    [self removeTarget:self action:@selector(textFieldEndEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textFieldEndEdit:(ZXTextField*)textField
{
    [self closeKeyboard];
    if (self.retBlock) {
        self.retBlock();
    }
}
/*
- (void)textFieldEditDidEnd:(ZXTextField*)textField{
    if (self.largeTextLength > 0) {
        NSString *text = textField.text;
        if (text != nil && text.length > self.largeTextLength) {
            if (self.largeTextTip) {
                [GHUDAlertUtils showLoadingAlertInView:[self superview] title:self.largeTextTip];
            }else{
                [GHUDAlertUtils showLoadingAlertInView:[self superview] title:[NSString stringWithFormat:@"该输入框最大为%d个字符", self.largeTextLength]];
            }
            textField.text = [text substringToIndex:self.largeTextLength];
        }
    }
}*/



- (void)closeKeyboard
{
    if ([self respondsToSelector:@selector(doneButtonIsClicked:)]) {
        [self performSelector:@selector(doneButtonIsClicked:) withObject:nil];
    }
}

#pragma mark -
#pragma mark - gesRecognizer

- (void)addGesRecognizer
{
    self.gesRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedOutside:)];
    self.gesRecognizer.delegate = self;
    [[self superview] addGestureRecognizer:self.gesRecognizer];
}

- (void)removeGesRecognizer
{
    self.gesRecognizer.delegate = nil;
    [[self superview] removeGestureRecognizer:self.gesRecognizer];
    self.gesRecognizer = nil;
}

#pragma mark -
#pragma mark gesture call back

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[ZXTextField class]] ||
        (self.gesRecognizerBlock && !self.gesRecognizerBlock(gestureRecognizer, touch)))
    {
        return NO;
    }

    return YES;
}

- (void)touchedOutside:(UIGestureRecognizer *)recognizer
{
    [self closeKeyboard];
}

@end
