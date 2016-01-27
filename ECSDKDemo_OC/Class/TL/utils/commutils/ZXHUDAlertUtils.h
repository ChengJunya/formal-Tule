//
//  ZXHUDAlertUtils.h
//  alijk
//
//  Created by easy on 14/11/13.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXColorAlert.h"

typedef enum
{
    TOAST_ON_TOP = 0,
    TOAST_UNDER_NAV
    
} TOAST_LOC;

typedef enum
{
    RED_BUTTON_TYPE = 0,
    GREEN_BUTTON_TYPE,
    SAME_BUTTON_TYPE
    
}COLORBUTTONTYPE;

@interface BlockAlertView : UIAlertView

@property(nonatomic,strong)AlertBlock block;

@end


@interface ZXHUDAlertUtils : NSObject

+ (id)shareInstance;

/*
 * 显示loading hud
 */
- (void)toggleLoadingInView:(UIView*)view;

/*
 * 隐藏loading hud
 */
- (void)hideLoadingInView:(UIView*)view;

/*
 * 程序重后台进入前台时，重启loading view
 */
- (void)resumeHUDWhenAppBecomeActive;

/*
 * 进入新的VC时，将之前所有存在的HUD删除
 */
- (void)dismissAllHUDWhenEnterVC;

/*
 * 显示可自动消失的提示框
 */
- (void)toggleMessage:(NSString*)message;

/*
 * 显示自定义的提示框
 * 如果只想要一个确定键，那么就给cancletitle 传入 nil；
 */
- (void)showZXColorAlert:(NSString*)title subTitle:(NSString*)subtitle cancleButton:(NSString*)cancleTitle sureButtonTitle:(NSString*)sureTitle COLORButtonType:(COLORBUTTONTYPE)type buttonHeight:(CGFloat)height clickedBlock:(ZXAlertBlock)block;

/*
 * 使zxcolorAler消失
 */
- (void)hideAlert;

@end
