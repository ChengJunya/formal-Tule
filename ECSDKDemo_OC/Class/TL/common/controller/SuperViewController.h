//
//  RootViewController.h
//  alijk
//
//  Created by easy on 14/7/29.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNavigationView.h"
@interface SuperViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *requestArray; //保存网络请求的ID
@property (nonatomic, assign) BOOL navBackItemHidden; // 隐藏或显示back按钮
@property (nonatomic, assign) BOOL navBarHidden; // 隐藏或显示navbar
@property (nonatomic, assign) BOOL navMsgIconHidden; // 隐藏或显示msg icon
@property (nonatomic, assign) BOOL navMsgIconEnable; // msg icon可点击状态
@property (nonatomic, assign) BOOL listBtnHidden; // 隐藏或显示功能列表按钮
@property (nonatomic, assign) BOOL searchBtnHidden; // 隐藏或显示搜索按钮
@property (nonatomic, strong) id itemData;

@property (nonatomic, strong) CNavigationView *navView;

- (void)addAllUIResources;
- (void)removeAllUIResources;
- (void)cancelAllNetRequest;

/*
 * 通知消息到达后，相关页面需要刷新，根据msgType进行判断
 * 1:询价响应; 3:药店备货; 4:药店送货; 5:待评价; 6处方打回,当前范围无药店,咨询无响应)
 */
- (void)refreshUIWhenMsgArrive:(NSString*)msgType;

/* pushViewController
 * vcname：下一个VC的名称
 * block：执行push操作前需要执行的操作
 */
- (void)pushViewControllerWithName:(NSString*)vcname block:(Id_Block)block;
- (void)pushViewControllerWithName:(NSString*)vcname itemData:(id)itemData block:(Id_Block)block;

/*
 * 登录成功后进入相应页面
 * 1.自动登录，注册新用户登录，找回密码登录，没有登录的情况：进入首页
 * 2.没有登录的情况下，进入首页后点击需要用户信息的页面；退出已经登录的账户，然后再次登录
 */
- (void)gotoNextVCWhenLoginSucceed:(BOOL)isFromLoginNav;

/* 当有新消息到达后会调用的方法
 */
- (void)notifyToUpdateUIWhenNewsArriver:(NSNotification*)notify;

/*
 * 检测是否能进入消息页面或者活动页面
 */
- (void)checkToGotoAutoPushVC;

/*
 * 直接跳转到homeViewController
 */
- (void)directPopToHomeVC;

/*
 * 分享
 */
- (void)navExpandMenuShareAction;

/*
 * 返回按钮事件，可进行重载
 */
- (void)navBackAction;

/*
 * 返回按钮事件，可进行重载
 */
- (void)searchAction;

/*
 * 返回按钮事件，可进行重载
 */
- (void)listAction;

@end
