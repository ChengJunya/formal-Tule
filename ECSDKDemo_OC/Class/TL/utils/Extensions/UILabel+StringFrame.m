//
//  UILabel+StringFrame.m
//  alijk
//
//  Created by zhangyang on 14-7-25.
//  Copyright (c) 2014年 zhangyang. All rights reserved.
//

#import "UILabel+StringFrame.h"
@implementation UILabel (StringFrame)
- (CGSize)boundingRectWithSize:(CGSize)size
{
    CGSize retSize;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {

        [self setNumberOfLines:0];
        NSDictionary *attribute = @{NSFontAttributeName: self.font};
        
        retSize = [self.text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else{
        
        //设置自动行数与字符换行，为0标示无限制
        [self setNumberOfLines:0];
        self.lineBreakMode = NSLineBreakByWordWrapping;//换行方式
        
        CGSize asize = CGSizeMake(size.width,CGFLOAT_MAX);//LableWight标签宽度，固定的
        //计算实际frame大小，并将label的frame变成实际大小
        retSize = [self.text sizeWithFont:self.font constrainedToSize:asize lineBreakMode:self.lineBreakMode];
    }
    
    return retSize;
}
+ (UILabel *)labelWithFrame:(CGRect)frame Text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *) font
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    return label;
}

+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font
{
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    return label;
}
/**
 *  设置多行文字之间的行间距
 *
 *  @param label    label
 *  @param string   文字
 *  @param spaceNum 行间距
 *
 *  @return <#return value description#>
 */
+ (UILabel *)worldSpaceWithLable:(UILabel *)label string:(NSString *)string lineSpace:(NSInteger)spaceNum
{
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:spaceNum];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, string.length)];
    [label setAttributedText:attributedString1];
    [label sizeToFit];
    return label;
}
@end

