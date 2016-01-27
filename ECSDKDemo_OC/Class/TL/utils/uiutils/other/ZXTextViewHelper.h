//
//  ZXTextViewHelper.h
//  自定义textView
//
//  Created by ZhongxinMac on 14-9-18.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXTextViewHelper : NSObject<UITextViewDelegate>
@property (nonatomic, assign)NSInteger largeTextLength;//最大长度
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end
