//
//  ZXTextView.h
//  自定义textView
//
//  Created by ZhongxinMac on 14-9-18.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//
typedef BOOL (^GesRecognizer_Block)(UIGestureRecognizer*, UITouch*);
typedef void (^Void_Block)(void);
#import <UIKit/UIKit.h>

@interface ZXTextView : UITextView

@property (nonatomic, strong) GesRecognizer_Block gesRecognizerBlock;

@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,strong) UIColor *placeholderColor;
@property(nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, assign) BOOL autoHideKeyboard;
@property (nonatomic, assign) NSInteger largeTextLength;//textView 最大输入长度
@end
