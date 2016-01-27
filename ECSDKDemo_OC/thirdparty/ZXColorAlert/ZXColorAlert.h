//
//  ZXColorAlert.h
//  alijk
//
//  Created by zhangyang on 14-8-28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXColorAlert : UIView

typedef void (^ZXAlertBlock)(ZXColorAlert* alert ,NSUInteger index);

@property(nonatomic,copy)ZXAlertBlock block;


-(id)initWithButtonTitles:(NSArray*)btnArr alertTitle:(NSString*)title subTitle:(NSString*)subTitle buttonHeight:(CGFloat)height;
-(void)setButtonBackGroundImage:(UIImage*)image forState:(UIControlState)state;
-(void)showAlertInView:(UIView*)superView;
-(void)alertSelectBlock:(ZXAlertBlock)block;



@end
