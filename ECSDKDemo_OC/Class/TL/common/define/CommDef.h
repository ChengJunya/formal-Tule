//
//  CommDef.h
//  alijk
//
//  Created by easy on 14/7/24.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#ifndef TL_CommDef_h
#define TL_CommDef_h


/****************************常用block********************************/
typedef void (^Void_Block)(void);
typedef void (^Bool_Block)(BOOL value);
typedef void (^Int_Block)(NSInteger value);
typedef void (^Id_Block)(id obj);
typedef void (^Async_Block)(id responseDTO);
typedef BOOL (^GesRecognizer_Block)(UIGestureRecognizer*, UITouch*);
typedef void (^AlertBlock)(UIAlertView* alertView, NSInteger index);
typedef void (^DataHelper_Block)(id obj, BOOL ret);
typedef void (^DataHelper_Block_Page)(id obj, BOOL ret, int pageNumber);
typedef void (^DataHelper_Block_Auth)(id obj, BOOL ret, NSInteger index);
typedef void (^Location_Block)(id currentLongitude,id currentLatitude);
/*******************************************************************/

/*******/
#define TL_SERVER_BASE_URL  @"http://210.73.202.85:9080/travel" // 生产服务器测试ip http://210.73.202.85:9080/travel/
#define TL_GROUP_ICON_URL @"/action/groupIconAcquire" //获取群组图片url


/****************************公用头文件********************************/





#import "CommUIDef.h"
#import "UIImage+Pres.h"
#import "UIView+CBFrameHelpers.h"
#import "UIView+Extension.h"
#import "JSONModel+networking.h"
#import "MBAlertView.h"
#import "MBHUDView.h"
#import "ZXSingletonMacro.h"
#import "UILabel+StringFrame.h"
#import "MBProgressHUD.h"
#import "UIImage+ImageFrameCategory.h"
#import "CustomActionSheet.h"
#import "UIImageView+SDWebImage.h"
#import "UIViewController+CWPopup.h"
#import "AFNetworking.h"
#import "THProgressView.h"
#import "UIImageView+LK.h"
#import "ZXHUDAlertUtils.h"
#import "UIImage+Blur.h"
#import "UIImage+BoxBlur.h"
#import "DataManager.h"
#import "NetAdapterType.h"
#import "BaseDTOModel.h"
#import "JSONModel.h"
#import "SBJsonParser.h"
#import "TLDataModuleHelper.h"
#import <StoreKit/StoreKit.h>


/*******************************************************************/



/****************************友盟事件记录**************************************/
// 友盟事件记录
#ifdef APP_To_Publish

#define MobClickBeginLogPageView(title) { \
if (title && ![title isEqualToString:@""]) { \
[MobClick beginLogPageView:title]; } \
}

#define MobClickEndLogPageView(title) { \
if (title && ![title isEqualToString:@""]) { \
[MobClick endLogPageView:title]; } \
}

#define MobClickEvent(ev) { \
[MobClick event:ev]; \
}

#define MobClickEventLabel(ev, la) { \
[MobClick event:ev label:la]; \
}

#else

#define MobClickBeginLogPageView(title) {}
#define MobClickEndLogPageView(title) {}
#define MobClickEvent(event) {}
#define MobClickEventLabel(event, label) {}

#endif
/******************************************************************/

/*****************************简化方法宏定义*******************************/

#define GDataManager         ([DataManager sharedManager])
#define GHttpClient          ([DataManager sharedManager].httpClient)
#define GDownloader          ([NetDownloader sharedManager])


#define GUserDataHelper      ZX_CALL_SINGLETON(UserDataHelper)          // 用户相关信息
#define GAddressHelper       ZX_CALL_SINGLETON(AddressDataHelper)       // 地址信息
#define GAppversionHelper    ZX_CALL_SINGLETON(AppVersionHelper)        // app版本相关的信息
#define GCertifyCodeHelper   ZX_CALL_SINGLETON(CertifyCodeHelper)       // 获取验证码信息
#define GTLHomeHelper        ZX_CALL_SINGLETON(TLHomeHelper)       //首页信息获取
#define GTLModuleDataHelper        ZX_CALL_SINGLETON(TLModuleDataHelper)       //首页信息获取
#define GTLCoreDataHelper     ZX_CALL_SINGLETON(TLDataModuleHelper)       //首页信息获取


#define GHUDAlertUtils       ([ZXHUDAlertUtils shareInstance])

#define RTLHelper             ZX_CALL_SINGLETON(TLHelper)

#define GNotifyCenter        ([NSNotificationCenter defaultCenter])
#define GDevicesID           ([OpenUDID value])
#define GUserDefault         ([NSUserDefaults standardUserDefaults])
#define GApplication         ([UIApplication sharedApplication])
#define GNSFileManager       ([NSFileManager defaultManager])
#define TLAppDelegate         ((AppDelegate*)[UIApplication sharedApplication].delegate)
#define GHUDAlertUtils       ([ZXHUDAlertUtils shareInstance])

#define MultiLanguage(key)   NSLocalizedString(@""#key"", nil)

#define SafeArrayItem(array, index) ((index >= 0 && index < [array count]) ? array[index]: nil)

#define WEAK_SELF(instance)  __weak typeof(self) weakSelf = instance;

#ifdef DEBUG
#define ZXLog(...) NSLog(__VA_ARGS__)
#else
#define ZXLog(...)
#endif

/************************************************************************/


/******************/
 #define RGBColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
 
 //判断系统版本
 #define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
 /*********************/

/***********************************通知相关********************************/

#define NOTIFICATION_UPDATE_UNREADMSGCOUNT      @"NotifyToUpdateUnreadMsgCount"
#define NOTIFICATIONREFRESH_UI_MSG_ARRIVE       @"NotifyToRefreshUIWhenMsgArrive"
#define NOTIFICATION_GOTO_NEXTVC_MSG_ARRIVE     @"NotifyToGotoNextVCWhenMsgArrive"
#define NOTIFICATION_BEKICKOFF                  @"NotifyToBeKickOff"
#define NOTIFICATION_TALL_ACTION                @"NotifyToTallAction"
#define NOTIFICATION_GOTO_HOME_SUBVC            @"NotifyToGotoHomeSubVC"

#define NOTIFICATION_COMMENT_FINISH             @"NotifyToCommentFinish"
#define NOTIFICATION_PUSH_FINISH                @"NotifyToPushFinish"

#define NOTIFICATION_CART_UPDATE                @"NotifyToCartUpdate"
#define NOTIFICATION_CART_STATUS                @"NotifyToCartStatus"



#define TL_DRAWER_OPEN_LEFT                     @"TLDrawerOpenLeftView"
#define TL_DRAWER_OPEN_RIGHT                    @"TLDrawerOpenRightView"

#define NOTIFICATION_SHARE                      @"NotificationShare"
#define NOTIFICATION_CHECK_VERSION                      @"NotificationCheckVersion" //检查版本更新

/*************************************************************************/



/****************************************常量************************************/

#define APPLEID                 @"920305451"
#define UMESSAGE_APPKEY         @"54f5419dfd98c5b7230008f7" // 友盟推送appkey 途乐
#define UMSOCIAL_WXAPP_ID       @"wx83474efeb7589d6d"       // 微信应用id
#define UMSOCIAL_WXAPP_SECRET   @"1325c0a938c65bf0cd9130fe90ffdb35"  // 微信应用secret
#define UMSOCIAL_WXAPP_URL      @"https://itunes.apple.com/cn/app/tu-le/id994473639?l=en&mt=8"       // 缺省url地址


#define UMSOCIAL_SINAAPP_ID             @"367905493"
#define UMSOCIAL_SINAAPP_SECRET         @"9fd0eb24f5cb587c236a140f74fda35e"

#define BPUSH_APIKEY @"2IKPGB1XtKGQno4ghDqDASX4" //百度云推送apikey



#define REQUEST_DATA     @"requestdata"

#define RET_CODE         @"retCode"
#define RET_MESSAGE      @"retMessage"

#define _IPHONE80_ 80000

#define DELAY_LOGIN_ONE_NAV 1


/**
 *  设置页面里用到的key
 */

#define IS_HIDDEN_MODULE_KEY @"isHiddenModuleKey"    //隐身模式
#define IS_GROUP_MESSAGE_NOTICE_KEY @"isGroupMessageNoticeKey" //是否群组消息提醒
#define IS_ALL_MESSAGE_NOTICE_KEY @"isAllMessageNoticeKey" //是否群组消息提醒
#define IS_DOWNLOAD_IN34GNET @"isDownloadIn34GNet" //34g网络是否下载文件
#define CHAT_BG_IMAGE_NAME @"chatBgImageName"   //聊天背景图片
#define WAITING_BG_IMAGE_NAME @"waitingBgImageName"   //聊天背景图片

#define MESSAGE_COUNT_CHAGE_NOTICE @"messageCountChangeNotice" //消息数量变更通知

/********************************************************************************/



/********************************最后一次定位的经纬度*************************/

#define LastUserLocationLongitude @"LastUserLocationLongitude"
#define LastUserLocationLatitude @"LastUserLocationLatitude"

/**************************************************************************/

/********************************CELL_ID*************************/

#define PROVINCE_CELL @"ProviceCell" //省市选择cell
#define CITY_CELL @"CityCell" //省市选择cell
#define COMMENT_CELL @"TLCommentCell" // 评论cell
#define COMMENT10000_CELL @"TLComment10000Cell" // 10000客服
#define TL_ORG_MSSAGE_CELL @"TLOrgMessageCell" // 评论cell

#define TL_USER_CELL @"TLUserCell" //用户列表cell
#define TL_CONTACT_CELL @"TLContactCell" //通讯录用户cell


/**************************************************************************/



/****固定值*****/
//1-攻略 2-路书 3-游记 4-召集活动 5-车讯 6-二手平台 7-应急救援 8-商家

//攻略适用于 lie渲染显示
#define MODULE_STRATEGY                  @"ModuleStrategy"
#define MODULE_STRATEGY_TYPE             @"1"
//路书
#define MODULE_WAYBOOK                  @"ModuleWayBook"
#define MODULE_WAYBOOK_TYPE             @"2"
//游记
#define MODULE_TRIPNOTE                 @"ModuleTripNote"
#define MODULE_TRIPNOTE_TYPE            @"3"
//召集活动
#define MODULE_GROUPACTIVITY            @"ModuleGroupActivity"
#define MODULE_GROUPACTIVITY_TYPE       @"4"
//车讯
#define MODULE_CARINFO                  @"ModuleCarInfo"
#define MODULE_CARINFO_TYPE             @"5"
//二手平台
#define MODULE_SECONDPATFORM            @"ModuleSecondPlayform"
#define MODULE_SECONDPATFORM_TYPE       @"6"
//应急救援
#define MODULE_EMERGENCY                @"ModuleEmergency"
#define MODULE_EMERGENCY_TYPE           @"7"
//商家
#define MODULE_STORE                    @"ModuleStore"
#define MODULE_STORE_TYPE               @"10"
/**
 *  新闻
 */
#define MODULE_NEWS                    @"ModuleNews"
#define MODULE_NEWS_TYPE               @"14"

//车讯-新车资讯
#define MODULE_CARINFO_INFO                 @"ModuleCarInfoInfo"
#define MODULE_CARINFO_INFO_TYPE             @"51"
//车讯-车评
#define MODULE_CARINFO_COMMENT                  @"ModuleCarInfoComment"
#define MODULE_CARINFO_COMMENT_TYPE             @"52"
//车讯-租赁
#define MODULE_CARINFO_HIRE                  @"ModuleCarInfoHire"
#define MODULE_CARINFO_HIRE_TYPE             @"53"
//车讯-服务
#define MODULE_CARINFO_SERVICE                  @"ModuleCarInfoService"
#define MODULE_CARINFO_SERVICE_TYPE             @"54"


/*********/


#endif
