//
//  ZXTextFieldDelegateHelper.m
//  alijk
//
//  Created by zhongxin on 14-9-17.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "ZXTextFieldDelegateHelper.h"

@implementation ZXTextFieldDelegateHelper

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""])
        return YES;
    
    NSInteger strLength = textField.text.length - range.length + string.length;
    if (self.largeTextLength > 0) {
        if ([string length] > 1 && strLength > self.largeTextLength) {
            [self.textField resignFirstResponder];
            
//            [GHUDAlertUtils toggleMessage:[NSString stringWithFormat:@"当前输入框最大长度为%d", self.largeTextLength]];
        }
        return (strLength <= self.largeTextLength);
    }else{
        return YES;
    }
}

@end
