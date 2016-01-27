//
//  ZXTextField.h
//  alijk
//
//  Created by easy on 14-8-6.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "MHTextField.h"

@interface ZXTextField : UITextField

@property (nonatomic, assign) BOOL autoHideKeyboard;

@property (nonatomic, strong) Void_Block retBlock;
@property (nonatomic, strong) GesRecognizer_Block gesRecognizerBlock;

@property (nonatomic, assign) NSInteger largeTextLength;//textField 最大输入长度
@property (nonatomic, assign) CGFloat zxBorderWidth;

/*添加左侧图片*/
@property (nonatomic,strong) NSString *leftIconName;
/*下划线*/
@property (nonatomic,strong) NSString *underLineIconName;

@end