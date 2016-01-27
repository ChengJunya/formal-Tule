//
//  UILabel+StringFrame.h
//  alijk
//
//  Created by zhangyang on 14-7-25.
//  Copyright (c) 2014年 zhangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size;
+ (UILabel *)labelWithFrame:(CGRect)frame Text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *) font;
+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;
/**
 *  设置多行文字之间的行间距
 *
 *  @param label    label
 *  @param string   文字
 *  @param spaceNum 行间距
 *
 *  @return <#return value description#>
 */
+ (UILabel *)worldSpaceWithLable:(UILabel *)label string:(NSString *)string lineSpace:(NSInteger)spaceNum;
@end