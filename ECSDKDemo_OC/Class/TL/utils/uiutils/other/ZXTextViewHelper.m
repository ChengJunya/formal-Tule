//
//  ZXTextViewHelper.m
//  自定义textView
//
//  Created by ZhongxinMac on 14-9-18.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "ZXTextViewHelper.h"
#import "ZXTextView.h"
@implementation ZXTextViewHelper

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""])
        return YES;
    
    NSInteger strLength = textView.text.length - range.length + text.length;
    if (self.largeTextLength > 0) {
        return (strLength <= self.largeTextLength);
    }else{
        return YES;
    }
}
@end
