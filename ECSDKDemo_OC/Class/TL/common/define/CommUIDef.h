//
//  CommUIDef.h
//  alijk
//
//  Created by yongfu on 14/7/24.
//  Copyright (c) 2014年 MST. All rights reserved.
//

#ifndef TL_CommUIDef_h
#define TL_CommUIDef_h

/*****************************设备相关宏定义*********************************/

// 基本设备信息
#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define DEVICE_WIDTH         ([[UIScreen mainScreen] bounds].size.width)
#define DEVICE_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)
#define DEVICE_IS_IPHONE4    ((int)DEVICE_HEIGHT%480==0) // 不要用，会废弃
#define DEVICE_IS_IPHONE5    ((int)DEVICE_HEIGHT%568==0 // 不要用，会废弃)

#define STATUSBAR_HEIGHT        20.f
#define NAVIGATIONBAR_HEIGHT    44.f
#define BOTTOMVIEW_HEIGHT       64.f
#define TABBAR_HEIGHT           49.f
#define DRAWER_LEFT_WIDTH       220.f


//查询条件高度
#define C_CONDITION_HEIGHT          40.0f
#define C_CONDITION_CONTENT_HEIGHT  200.0f
#define C_OK_BTN_HEIGHT             40.0f
#define C_OPARATION_HEIGHT          120.0f
#define C_SEARCHVIEW_HEIGHT         80.0f



#define SCREEN_WIDTH         DEVICE_WIDTH
#define SCREEN_HEIGHT        (DEVICE_HEIGHT - STATUSBAR_HEIGHT)


#define SCREEN_SCALE         ([UIScreen mainScreen].scale)

#define UI_DENSITY           ([UIScreen mainScreen].scale) // 屏幕像素密度
#define UI_SCALE_X           (1.f)
#define UI_SCALE_Y           (1.f)
#define UI_SCALE_W           (DEVICE_WIDTH / 320.f)  // 组件宽度缩放比例
#define UI_SCALE_H           (1.f)                   // 组件高度缩放比例
#define UI_SCALE_WH          (1.f)
#define UI_LAYOUT_MARGIN     (12.f) // UI布局时的通用边距

#define UI_COMM_BTN_WIDTH    (DEVICE_WIDTH - 2 * UI_LAYOUT_MARGIN)      // 通用长按钮的宽度
#define UI_COMM_BTN_HEIGHT   (40.f)                                     // 通用按钮的高度
#define UI_COMM_SHORT_BTN_HEIGHT   (120.f)
/*************************************************************************/


/*********************************UI相关***********************************/
#define CGRectSize(rect)            rect.size
#define CGRectOrigin(rect)          rect.origin
#define CGRectWidth(rect)           rect.size.width
#define CGRectHeight(rect)          rect.size.height
#define CGRectOriginX(rect)         rect.origin.x
#define CGRectOriginY(rect)         rect.origin.y
#define CGRectCenter(rect)          (CGPointMake(CGRectWidth(rect)/2.f, CGRectHeight(rect)/2.f))

#define CGRectLeftBottomY(rect)     rect.size.height+rect.origin.y
#define CGRectRightTopX(rect)       rect.size.width+rect.origin.x


#define CGSizeWidth(size)           size.width
#define CGSizeHeight(size)          size.height
#define CGSizeCenter(size)          (CGPointMake(CGSizeWidth(size)/2.f, CGSizeHeight(size)/2.f))


#define UIColorFromRGB(rgbValue)    ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])
#define UIColorFromRGBA(rgbValue,a)    ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)])

/*************************************************************************/


/**************************************页面布局相关********************************/

static const int TABLE_PAGE_SIZE = 8;
static const float UI_Comm_Margin = 12.f;       //边距

/********************************************************************************/




/*****************************使用到的字体颜色定义*****************************/
/*
 * 背景颜色
 */
#define COLOR_DEF_BG         (UIColorFromRGB(0xeeeeee))
#define COLOR_NAV_BAR        (UIColorFromRGBA(0xeeeeee,1))
#define COLOR_NAV_BAR_BOTOOM (UIColorFromRGBA(0x000000,0.5))
#define COLOR_WHITE_BG       ([UIColor whiteColor])
#define COLOR_TABLE_BG       ([UIColor whiteColor])
#define COLOR_TABLE_CELL     (UIColorFromRGB(0xffffff))

/*
 * 常用文字颜色
 */
#define COLOR_NAV_TEXT   (UIColorFromRGB(0xfb9500)) // 导航条文字颜色

#define COLOR_TITLEE     (UIColorFromRGB(0x333333)) // 标题文字颜色
#define COLOR_MAIN_TEXT  (UIColorFromRGB(0x5f646e)) // 主要文字颜色
#define COLOR_ASSI_TEXT  (UIColorFromRGB(0xaaaaaa)) // 辅助文字颜色
#define COLOR_COST_TEXT  (UIColorFromRGB(0xff5500)) // 突出显示的价格文字颜色
#define COLOR_GREEN_TEXT (UIColorFromRGB(0x0eb14f)) // 绿色文本
#define COLOR_WHITE_TEXT (UIColorFromRGB(0xffffff)) // 白色文本
#define COLOR_ORANGE_TEXT (UIColorFromRGB(0xfb9500)) // 白色文本

/*
 * Tab选择的颜色
 */
#define COLOR_TAB_TEXT_N    (UIColorFromRGB(0x5f646e)) // TAB框中文字正常颜色
#define COLOR_TAB_TEXT_P    (UIColorFromRGB(0xfb9600)) // TAB框中文字选中颜色
#define COLOR_TAB_BG_N      (UIColorFromRGB(0xf5f5f5)) // TAB框背景颜色
#define COLOR_TAB_BG_P      (UIColorFromRGB(0xfb9600)) // TAB框背景选中颜色
#define COLOR_TAB_LINE_N    (UIColorFromRGB(0xdddddd)) // TAB框边线颜色
#define COLOR_TAB_LINE_P    (UIColorFromRGB(0x0eb14f)) // TAB框边线选中颜色

/*
 * 按钮的颜色
 * 线框按钮、色块按钮
 */
#define COLOR_BTN_BOX_GREEN_SUFACE          (UIColorFromRGB(0xffffff)) // 线框焦点按钮内部颜色
#define COLOR_BTN_BOX_GREEN_BOARD           (UIColorFromRGB(0xfb9600)) // 线框焦点按钮边框颜色
#define COLOR_BTN_BOX_GREEN_TEXT            (UIColorFromRGB(0xfb9600)) // 线框焦点按钮文字颜色

#define COLOR_BTN_BOX_GRAY_SUFACE           (UIColorFromRGB(0xffffff)) // 线框次要按钮内部颜色
#define COLOR_BTN_BOX_GRAY_BOARD            (UIColorFromRGB(0xfb9600)) // 线框次要按钮边框颜色
#define COLOR_BTN_BOX_GRAY_TEXT             (UIColorFromRGB(0xfb9600)) // 线框次要按钮文字颜色

#define COLOR_BTN_BOX_DISABLE_SUFACE        (UIColorFromRGB(0xeeeeee)) // 线框无效按钮内部颜色
#define COLOR_BTN_BOX_DISABLE_BOARD         (UIColorFromRGB(0xdddddd)) // 线框无效按钮边框颜色
#define COLOR_BTN_BOX_DISABLE_TEXT          (UIColorFromRGB(0xdddddd)) // 线框无效按钮文字颜色

#define COLOR_BTN_SOLID_COMMON_TEXT         (UIColorFromRGB(0xffffff)) // 色块按钮文字颜色
#define COLOR_BTN_SOLID_DISABLE_TEXT        (UIColorFromRGB(0xf5f5f5)) // 色块按钮disable时文字颜色

#define COLOR_BTN_SOLID_TOP_GREEN_SUFACE    (UIColorFromRGB(0x63a851)) // 浅绿色块焦点按钮内部颜色
#define COLOR_BTN_SOLID_GREEN_SUFACE        (UIColorFromRGB(0xfb9600)) // 绿色块焦点按钮内部颜色
#define COLOR_BTN_SOLID_GRAY_SUFACE         (UIColorFromRGB(0x5f646e)) // 灰色块次要按钮内部颜色
#define COLOR_BTN_SOLID_ORANGE_SUFACE       (UIColorFromRGB(0xe34428)) // 橙色块警告按钮内部颜色
#define COLOR_BTN_SOLID_DISABLE_SUFACE      (UIColorFromRGB(0xdddddd)) // 色块无效按钮内部颜色




/*
 * 字体
 * 18号字体：导航栏title
 * 16号字体：标题
 * 14号字体：正文
 * 12号字体：次要
 */
//#define FONT_LIGHT(s)    {[UIFont fontWithName:@"STHeitiSC-Light" size:s];}
//#define FONT_BOLD(s)     {[UIFont fontWithName:@"STHeitiSC-Medium" size:s];}

#define FONT_LIGHT(s)    {[UIFont systemFontOfSize:s];}
#define FONT_BOLD(s)     {[UIFont boldSystemFontOfSize:s];}

#define FONT_22             (FONT_LIGHT(22))
#define FONT_18             (FONT_LIGHT(18))
#define FONT_16             (FONT_LIGHT(16))
#define FONT_14             (FONT_LIGHT(14))
#define FONT_12             (FONT_LIGHT(12))

#define FONT_30B            (FONT_BOLD(30))
#define FONT_18B            (FONT_BOLD(18))
#define FONT_16B            (FONT_BOLD(16))
#define FONT_14B            (FONT_BOLD(14))
#define FONT_12B            (FONT_BOLD(12))

/*******************************************************************************/

#endif
