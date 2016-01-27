//
//  CNavigationView.h
//  ContractManager
//
//  Created by Rainbow on 12/16/14.
//  Copyright (c) 2014 MST Inc. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////// MST INC //////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//          ____________      ____________     ________________  ____     _________________________   //
//         /            \    /           /    /    ___________ \/   /    /                        /   //
//        /____          \  /       ____/    |    /           \____/    /   _____       _____    /    //
//            /   /\      \/   /|   |        |    |_______________     /___/    /      /    /___/     //
//           /   /  \         / |   |        |                    \            /      /               //
//          /   /    \       /  |   |         \________________    |          /      /                //
//     ____/   /____  \     /___|   |____     ____             |   |     ____/      /____             //
//    /            /   \   //           /    /    \____________/   |    /               /             //
//   /____________/     \_//___________/    /___/\________________/    /_______________/              //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////// Copyright (c) 2014 MST Inc. All rights reserved. /////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#define CNAVIGATION_GAP 5.0f
#define CNAVIGATION_V_GAP 2.0f
#define CSTATUS_HEIGHT 20.0f
#define IOS_VERSION_CNavigationView [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 * 通用的导航栏组件，
 * 通过部分属性可以简单定制导航栏
 */
@interface CNavigationView : UIView

///状态栏高度
@property (nonatomic,assign) CGFloat statusHeight;
///导航栏高度
@property (nonatomic,assign) CGFloat navHeight;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) NSArray *actionBtns;



/** 
 通过属性初始化导航栏
 @param frame 导航栏大小 
 @param title 导航标题
 @param fontSize 导航标题文字大小
 @param color 导航字体大小
 @param imageName 导航中间图片
 @param backBtn 返回按钮
 @param actionBtns 右侧操作按钮列表 最右侧放到数组的最前面 index=0 是最右侧的按钮
 @param bgColor 背景颜色
 @param isShowStatusBar 是否显示导航栏 如果有导航栏frame的高度=状态栏高+本身的高度 64=20+44
 */
-(instancetype)initWithFrameAndProperties:(CGRect)frame title:(NSString*)title font:(UIFont*)font color:(UIColor *)color imageName:(NSString*)imageName backBtn:(UIButton*)backBtn actionBtns:(NSArray *)btns bgColor:(UIColor*)bgColor isShowStatusBar:(BOOL)isShowStatusBar viewController:(UIViewController*)viewController;
@end
