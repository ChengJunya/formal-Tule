//
//  ZXSingleCheckbox.h
//  alijk
//
//  Created by easy on 14-7-31.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXSingleCheckbox : UIControl

@property (nonatomic, assign) BOOL isChecked;

/*
 * 选中或者不选时调用的block
 */
@property (nonatomic, strong) Bool_Block block;

/*
 * 边框宽度和颜色值
 */
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *strokeColor;

/*
 * 中间的对号颜色
 */
@property (nonatomic, strong) UIColor *checkColor;

/*
 * 选中和不选中时填充的颜色
 */
@property (nonatomic, strong) UIColor *fillColorNormal;
@property (nonatomic, strong) UIColor *fillColorSelected;

/*
 * checkBox的边长
 */
@property (nonatomic, assign) CGFloat side;

/*
 * checkBox的弧度
 */
@property (nonatomic, assign) CGFloat radius;

/*
 * 附带的文字
 */
@property (nonatomic, strong) UILabel *textLabel;

@end
