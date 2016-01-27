//
//  ZXTextFieldDelegateHelper.h
//  alijk
//
//  Created by zhongxin on 14-9-17.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXTextField.h"

@interface ZXTextFieldDelegateHelper : NSObject<UITextFieldDelegate>

@property (nonatomic, assign)NSInteger largeTextLength;//最大长度

@property (nonatomic, assign)ZXTextField *textField;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
