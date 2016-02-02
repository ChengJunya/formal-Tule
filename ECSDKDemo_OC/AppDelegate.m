//
//  AppDelegate.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/4.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "AppDelegate.h"
#import "ECDeviceHeaders.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "DemoGlobalClass.h"
#import "UserGuideViewController.h"
#import "TLHelper.h"
#import "IQKeyboardManager.h"

#import "UMSocialSnsService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "UserDataHelper.h"

#import "CoreData+MagicalRecord.h"
#import "BPush.h"
#import "ECGroupNoticeMessage.h"
#import "DeviceDBHelper.h"
#import "UserInfoDTO.h"
#import "TLOrgMessageDTO.h"

#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "TLModuleDataHelper.h"

#import "MobClick.h"
#import <Bugtags/Bugtags.h>
@interface AppDelegate ()<BPushDelegate>
@property (nonatomic, strong) LoginViewController *loginView;
@property (nonatomic, strong) MainViewController *mainView;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"MyDatabase.sqlite"];
    
    /**
     *  微信分享注册
     */
    [UMSocialData setAppKey:UMESSAGE_APPKEY];
    [UMSocialWechatHandler setWXAppId:UMSOCIAL_WXAPP_ID appSecret:UMSOCIAL_WXAPP_SECRET url:UMSOCIAL_WXAPP_URL];
    
    

    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
//    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //[UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    //qq
    [UMSocialQQHandler setQQWithAppId:@"1104623559" appKey:@"2n4AUk74JKqwYfL0" url:UMSOCIAL_WXAPP_URL];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatTimeline]];
    /**
     设置基本窗口颜色大小
     */
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    /**
     *  闪退异常处理
     */
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    
    /**
     *  键盘操作注册
     */
    [[IQKeyboardManager sharedManager] setEnable:YES];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectStateChanged:) name:KNOTIFICATION_onConnected object:nil];
    //初始化运通讯，并设置代理
    [ECDevice sharedInstance].delegate = [DeviceDelegateHelper sharedInstance];
    

    [RTLHelper gotoRootViewController];
    
    /**
     *  百度推送
     */
    
    
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
#warning 上线 AppStore 时需要修改 pushMode
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:BPUSH_APIKEY pushMode:BPushModeProduction isDebug:YES];
    

    
    // 设置 BPush 的回调
    [BPush setDelegate:self];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    
    // bugTags
    [Bugtags startWithAppKey:@"2e38bdab09f73c655c6936764f3a6f42" invocationEvent:BTGInvocationEventBubble];
    return YES;

    //友盟统计
    [MobClick startWithAppkey:@"56b01969e0f55af4ec00113b" reportPolicy:BATCH   channelId:nil];

    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // 打印到日志 textView 中
    completionHandler(UIBackgroundFetchResultNewData);
    [RTLHelper handleNotice:userInfo];
    NSLog(@"%@",userInfo);
   
    
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
//    [RTLHelper handleNotice:userInfo];
    NSLog(@"%@",userInfo);
}

#pragma mark Push Delegate
- (void)onMethod:(NSString*)method response:(NSDictionary*)data
{
    NSLog(@"%@",[NSString stringWithFormat:@"Method: %@\n%@",method,data]);
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    if (GUserDataHelper.isLoginSucceed) {
        NSLog(@"login success");
         [RTLHelper checkHasNewMessage];
    }else{
        NSLog(@"not login");
//        BOOL isAutoLogin = [[GUserDefault objectForKey:IS_AUTO_LOGIN] boolValue];
//        if (isAutoLogin) {
//            [self login];
//        }
        
        
        //如果发现未登录 就自动登录，如果自动登录没有账号密码 就进入手动登录页面
    }
    
    
    //上传聊天记录 判断时间 超过一天 则备份  3600*24
    
    
    NSString *lastupdateTime = [GUserDefault objectForKey:LAST_UPLOAD_TIME];
    if (lastupdateTime.length==0) {
        [GTLModuleDataHelper uploadUserChatInfo];
        [GUserDefault setObject:[NSString stringWithFormat:@"%f", [[NSDate new] timeIntervalSinceReferenceDate]]  forKey:LAST_UPLOAD_TIME];
    }else{
        double last = [lastupdateTime doubleValue];
        double now = [[NSDate new] timeIntervalSinceReferenceDate];
        
        if (now-last>3600*24) {
            [GTLModuleDataHelper uploadUserChatInfo];
        }
    }
    //获取系统新消息
//    GTLModuleDataHelper 
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
    [MagicalRecord cleanUp];

}


//登录页面和主页面的切换
-(void)connectStateChanged:(NSNotification *)notification{
    ECError* error = notification.object;
    UINavigationController * rootView = (UINavigationController*)self.window.rootViewController;
    if (error && error.errorCode == ECErrorType_NoError) {
        if (_mainView == nil) {
            self.mainView = [[MainViewController alloc] init];
            rootView = [[UINavigationController alloc] initWithRootViewController:_mainView];
        }
        else{
            rootView = self.mainView.navigationController;
        }
        self.loginView = nil;
    }
    else if(error && error.errorCode == ECErrorType_KickedOff){
        if (_loginView == nil) {
            self.loginView = [[LoginViewController alloc] init];
            rootView = [[UINavigationController alloc] initWithRootViewController:_loginView];
        }
        else{
            rootView = self.loginView.navigationController;
        }
        self.mainView = nil;
    }
    
    [rootView.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
    self.window.rootViewController = rootView;
}


-(void)login{
   
    
    
    
    [GUserDataHelper autoLogin:^(id obj, BOOL ret) {
        
        if (ret) {
           
        }
        else {
            //[RTLHelper gotoLoginViewController];
        }
    }];

}


void UncaughtExceptionHandler(NSException *exception) {
    // NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSLog(@"%@",name);
    NSLog(@"%@",reason);
    NSLog(@"YF, CRASH: %@", exception);
    NSLog(@"YF, Stack Trace: %@", [exception callStackSymbols]);
    //    NSString *urlStr = [NSString stringWithFormat:@"mailto://yongfu@bonc.com.cn?subject=Bug报告&body=感谢您对我们工作的支持，我们会尽快处理问题，祝工作顺利!<br><br><br>"
    //                        "错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
    //                        name,reason,[arr componentsJoinedByString:@"<br>"]];
    //    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //    [[UIApplication sharedApplication] openURL:url];
    
    //或者直接用代码，输入这个崩溃信息，以便在console中进一步分析错误原因
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//
//    return UIStatusBarStyleLightContent;
//
//}

@end
