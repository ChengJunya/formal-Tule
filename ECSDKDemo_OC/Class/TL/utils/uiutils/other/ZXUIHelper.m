//
//  ZXUIHelper.m
//  alijk
//
//  Created by easy on 14/7/29.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "ZXUIHelper.h"

@implementation ZXUIHelper

+(UIImageView*)addUIImageViewWithImage:(UIImage*)image frame:(CGRect)frame toTarget:(UIView*)target
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    [target addSubview:imageView];
    
    return imageView;
}

+(UIImageView*)addUIImageViewWithImage:(UIImage*)image size:(CGSize)size center:(CGPoint)center toTarget:(UIView*)target
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:(CGRect){.origin = CGPointZero, .size = size}];
    imageView.image = image;
    imageView.center = center;
    [target addSubview:imageView];
    
    return imageView;
}

+(UIImageView*)addUIImageViewWithImage:(UIImage*)image size:(CGSize)size center:(CGPoint)center anchorPoint:(CGPoint)anchorPoint toTarget:(UIView*)target
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:(CGRect){.origin = CGPointZero, .size = size}];
    imageView.image = image;
    imageView.layer.anchorPoint = anchorPoint;
    imageView.center = center;
    [target addSubview:imageView];
    
    return imageView;
}

+(UIButton*)addUIButtonWithNormalImage:(UIImage*)normalImage hilightImage:(UIImage*)hilightImage frame:(CGRect)frame toTarget:(UIView*)target
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:hilightImage forState:UIControlStateHighlighted];
    
    [target addSubview:button];
    
    return button;
}

+(UIButton*)addUIButtonWithNormalImage:(UIImage*)normalImage hilightImage:(UIImage*)hilightImage frame:(CGRect)frame title:(NSString*)title font:(UIFont*)font toTarget:(UIView*)target
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:hilightImage forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    
    [target addSubview:button];
    
    return button;
}

+(UILabel*)addUILabelWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont*)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    
    return label;
}
+(UILabel*)addUILabelWithText:(NSString*)text textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont*)font{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize textSize = [text sizeWithAttributes:dic];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, textSize.width, textSize.height)];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    
    return label;
}



+(UILabel*)createUILabelWithText:(NSString*)text textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont*)font width:(CGFloat)width{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    //CGSize textSize = [text sizeWithAttributes:dic];
    
    CGRect newRect =  [text boundingRectWithSize:CGSizeMake(width,1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(newRect), CGRectGetHeight(newRect))];
    
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    
    return label;
}



+ (UISearchBar*)commSearchBarWithFrame:(CGRect)frame bookmarkIcon:(UIImage*)bookmarkIcon {
    // search bar
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:frame];
    search.translucent = YES;
    search.barStyle = UIBarStyleDefault;
    search.backgroundColor = [UIColor clearColor];
    search.keyboardType = UIKeyboardTypeDefault;
    search.placeholder = @"";
    search.text = @"";
    search.showsCancelButton = NO;
    search.tintColor = COLOR_ASSI_TEXT;
//    [search sizeToFit]; // 注意：ios7上会出问题
    
    if (bookmarkIcon) {
        search.showsBookmarkButton = YES;
        [search setImage:bookmarkIcon forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    }
    
    for (UIView *subview in search.subviews)
    {
        for (UIView *subSubView in [subview subviews]) {
            if ([subSubView isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subSubView removeFromSuperview];
            }
            if ([subSubView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]){
                UITextField *searchBarTextField = (UITextField *)subSubView;
                searchBarTextField.clearButtonMode = UITextFieldViewModeNever;
            }
        }
    }
    
    return search;
}


+ (UIColor*) getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image {
    UIColor* color = nil;
    CGImageRef inImage = image.CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:
                          inImage];
    if (cgctx == NULL) {
        return nil; /* error */
    }
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:
                 (blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) {
        free(data);
    }
    return color;
}
+ (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL){
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,pixelsWide,pixelsHigh,8,bitmapBytesPerRow,colorSpace,kCGImageAlphaPremultipliedFirst);
    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}
@end
