//
//  ZXUIHelper.h
//  alijk
//
//  Created by easy on 14/7/29.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXUIHelper : NSObject

+(UIImageView*)addUIImageViewWithImage:(UIImage*)image frame:(CGRect)frame toTarget:(UIView*)target;
+(UIImageView*)addUIImageViewWithImage:(UIImage*)image size:(CGSize)size center:(CGPoint)center toTarget:(UIView*)target;
+(UIImageView*)addUIImageViewWithImage:(UIImage*)image size:(CGSize)size center:(CGPoint)center anchorPoint:(CGPoint)anchorPoint toTarget:(UIView*)target;

+(UIButton*)addUIButtonWithNormalImage:(UIImage*)normalImage hilightImage:(UIImage*)hilightImage frame:(CGRect)frame toTarget:(UIView*)target;
+(UIButton*)addUIButtonWithNormalImage:(UIImage*)normalImage hilightImage:(UIImage*)hilightImage frame:(CGRect)frame title:(NSString*)title font:(UIFont*)font toTarget:(UIView*)target;
+(UILabel*)addUILabelWithText:(NSString*)text textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont*)font;

+(UILabel*)addUILabelWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont*)font;
+(UILabel*)createUILabelWithText:(NSString*)text textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont*)font width:(CGFloat)width;
+ (UISearchBar*)commSearchBarWithFrame:(CGRect)frame bookmarkIcon:(UIImage*)bookmarkIcon;

+ (UIColor*) getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image ;


@end
