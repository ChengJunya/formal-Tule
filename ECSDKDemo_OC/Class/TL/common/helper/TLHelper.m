//
//  TLHelper.m
//  TL
//
//  Created by Rainbow on 2/4/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLHelper.h"
#import "UserGuideViewController.h"
#import "RNavViewController.h"
#import "DUNavigationController.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "TLHomeViewController.h"
#import "TLLeftViewController.h"
#import "BaseTabbarViewController.h"
#import "TLDrawerViewController.h"
#import "UserDataHelper.h"
#import "UserInfoDTO.h"
#import "ECLoginInfo.h"
#import "TLSysMessageListRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "RUtiles.h"
#import "TLGroupDataDTO.h"
@implementation TLHelper

ZX_IMPLEMENT_SINGLETON(TLHelper)


- (id)init
{
    if (self = [super init]) {
        self.hasNewMessage = NO;
        self.hasNewSystemMessage = NO;
        self.hasNewVersion = NO;
        self.systemMessageCount = @"0";
    }
    
    return self;
}

-(void)gotoHomeViewController{
    NSString *homeCls = @"TLHomeTabbarViewController";
    _rootViewController = [[NSClassFromString(homeCls) alloc] init];
    NSString *leftCls = @"TLLeftViewController";
    SuperViewController *leftViewController = [[NSClassFromString(leftCls) alloc] init];
   
    
    
    
    
     TLDrawerViewController *home = [[TLDrawerViewController alloc]
                                initWithCenterViewController:_rootViewController
                                leftDrawerViewController:leftViewController
                                rightDrawerViewController:nil];
    
    DUNavigationController *nav = [[DUNavigationController alloc] initWithRootViewController:home];
    
    [home setMaximumLeftDrawerWidth:__kScreenWidth - 130];
    [home setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [home setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        block(drawerController, drawerSide, percentVisible);
    }];
    
    TLAppDelegate.window.rootViewController = nav;
    [TLAppDelegate.window addSubview:nav.view];
    [TLAppDelegate.window makeKeyAndVisible];
    
    
}

-(void)autoLogin{
    [GUserDataHelper autoLogin:^(id obj, BOOL ret) {
        
        if (ret) {
            
        }
        else {
            //[RTLHelper gotoLoginViewController];
        }
    }];
}


-(void)gotoLoginViewController{
//    NSString *firstCls = @"TLLoginViewController";
//    SuperViewController *loginViewController = [[NSClassFromString(firstCls) alloc] init];
//    [self.rootViewController presentViewController:loginViewController animated:NO completion:nil];
//
    [GHUDAlertUtils hideAlert];
    NSString *firstCls = @"TLLoginViewController";
    SuperViewController *loginViewController = [[NSClassFromString(firstCls) alloc] init];
    DUNavigationController *nav = [[DUNavigationController alloc] initWithRootViewController:loginViewController];
    
    TLAppDelegate.window.rootViewController = nav;
    [TLAppDelegate.window addSubview:nav.view];
    //[TLAppDelegate.window makeKeyAndVisible];
    [TLAppDelegate.window makeKeyAndVisible];
}
-(void)gotoUserGuideController{

    NSString *firstCls = @"UserGuideViewController";
    SuperViewController *firstVC = [[NSClassFromString(firstCls) alloc] init];
    DUNavigationController *nav = [[DUNavigationController alloc] initWithRootViewController:firstVC];
    
    TLAppDelegate.window.rootViewController = nav;
    [TLAppDelegate.window addSubview:nav.view];
    //[TLAppDelegate.window makeKeyAndVisible];
    [TLAppDelegate.window makeKeyAndVisible];

     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}



-(void)gotoRootViewController{
    BOOL isHaveLuanched = [[GUserDefault objectForKey:K_IS_HAS_LAUNCH] boolValue];
    if (!isHaveLuanched) {
        [GUserDefault setObject:[NSNumber numberWithBool:YES] forKey:K_IS_HAS_LAUNCH];
        [GUserDefault synchronize];
    }
    
    if (!isHaveLuanched) {
        
        [self gotoUserGuideController];
    }else{
        //第一次加载不需要自动登录，后期才自动登录
        [GUserDefault setObject:[NSNumber numberWithBool:YES] forKey:IS_AUTO_LOGIN];
        [GUserDefault synchronize];
        [RTLHelper gotoWaitingViewController];
        
        //[self gotoHomeViewController];
    }
    
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_NAV_TEXT}];
    //    UIImage *navImg = [[UIImage imageNamed:@"title_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    //    [navBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
    
    
}

-(void)loginIM
{
    
    
    UserInfoDTO *userInfo = [GUserDataHelper tlUserInfo];
    ECLoginInfo *loginInfo = [[ECLoginInfo alloc] initWithAccount:userInfo.voipAccount Password:userInfo.voipToken];
    loginInfo.serviceUrl = @"https://app.cloopen.com:8883";
    loginInfo.subAccount = userInfo.subAccount;
    loginInfo.subToken = userInfo.subToken;
    [[DeviceDBHelper sharedInstance] openDataBasePath:userInfo.voipAccount];
    [[ECDevice sharedInstance] login:loginInfo completion:^(ECError *error) {
        if (error.errorCode == ECErrorType_NoError) {
            [DemoGlobalClass sharedInstance].loginInfoDic = userInfo.toDictionary;
            //[[DemoGlobalClass sharedInstance].subAccontsArray removeObjectAtIndex:_curIndex-BUTTON_SUNACCOUNT_BASE_TAG];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:[DemoGlobalClass sharedInstance].subAccontsArray] forKey:UserDefault_Connacts];
            //[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:[DemoGlobalClass sharedInstance].loginInfoDic] forKey:UserDefault_LoginUser];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
           
            
        }
        else{
            [self gotoLoginViewController];
        }
        
    }];
    
}

-(BOOL)getLoginInfo{
    NSDictionary *loginInfo = [GUserDefault objectForKey:UserDefault_LoginUser];
    if (loginInfo != nil) {
        //缓存登陆账号
        NSDictionary *userInfo = [GUserDefault objectForKey:UserDefault_UserInfo];
        [DemoGlobalClass sharedInstance].loginInfoDic = userInfo;
        //删除所有的子帐号
        [[DemoGlobalClass sharedInstance].subAccontsArray removeAllObjects];
        NSArray *array = [GUserDefault objectForKey:UserDefault_Connacts];
        if (array) {
            //缓存子帐号
            [[DemoGlobalClass sharedInstance].subAccontsArray addObjectsFromArray:array];
        }
        return YES;
    }
    return NO;
}

-(void)pushViewControllerWithName:(NSString *)vcname block:(Id_Block)block{
    SuperViewController *pushVC = [[NSClassFromString(vcname) alloc] init];
    if (block) {
        block(pushVC);
    }
    
    BOOL isAnimated = YES;
    [self.rootViewController.navigationController pushViewController:pushVC animated:isAnimated];

}

-(void)pushViewControllerWithName:(NSString*)vcname  itemData:(id)itemData block:(Id_Block)block{
    SuperViewController *pushVC = [[NSClassFromString(vcname) alloc] init];
    pushVC.itemData = itemData;
    if (block) {
        block(pushVC);
    }
    
    BOOL isAnimated = YES;
    [self.rootViewController.navigationController pushViewController:pushVC animated:isAnimated];
}

-(void)poptoViewControllerWithName:(NSString*)vcname  itemData:(id)itemData block:(Id_Block)block{
    SuperViewController *pushVC = [[NSClassFromString(vcname) alloc] init];
    pushVC.itemData = itemData;
    if (block) {
        block(pushVC);
    }
    [self.rootViewController.navigationController popToRootViewControllerAnimated:NO];
    BOOL isAnimated = NO;
    [self.rootViewController.navigationController pushViewController:pushVC animated:isAnimated];
}

-(void)presentViewControllerWithName:(NSString*)vcname  itemData:(id)itemData block:(Id_Block)block{
    SuperViewController *pushVC = [[NSClassFromString(vcname) alloc] init];
    pushVC.itemData = itemData;
    if (block) {
        block(pushVC);
    }
    
    BOOL isAnimated = YES;
    [self.rootViewController presentViewController:pushVC animated:isAnimated completion:^{
        
    }];
}


-(void)handleNotice:(NSDictionary*)userInfo{
    //KNOTIFICATION_onMesssageChanged
    //添加到group数据
    //通知
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval tmp =[date timeIntervalSince1970]*1000;
    
    
    
    
    /**
     aps =     {
     alert = "\U60a8\U52a0\U5165\U7684\U7ec4\U7ec7\U3010\U4e0a\U6d77-\U5949\U8d24\U533a\U3011\U6709\U65b0\U6d88\U606f\Uff01";
     };
     dataType = 1;
     objId = 121;
     
     orgId
     orgName
     注：当dataType为1,2,3,4时才会有值

     
     
     
     */


    NSString *alertInfo = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    

    NSString *dataType = [userInfo valueForKey:@"dataType"];
    

    
    switch (dataType.integerValue) {
        case 1:
        case 2:
        case 3:
        case 4:{
            NSString *organizationId = [userInfo valueForKey:@"orgId"];
            NSString *organizationName = [userInfo valueForKey:@"orgName"];
            NSString *context = [NSString stringWithFormat:@"%@|%@",alertInfo,organizationName];
            ECTextMessageBody *messageBody = [[ECTextMessageBody alloc] initWithText:context];
            ECMessage *message = [[ECMessage alloc] initWithReceiver:organizationName body:messageBody];
            message.sessionId =  [NSString stringWithFormat:@"TLORG%@", organizationId];//TLORG + orgId
            message.from = organizationName;
            message.to = organizationName;
            message.userData = [NSString stringWithFormat:@"{\"loginId\":\"%@\",\"name\":\"%@\",\"head\":\"%@\"}",GUserDataHelper.tlUserInfo.loginId ,GUserDataHelper.tlUserInfo.userName,GUserDataHelper.tlUserInfo.userIcon]; //loginId#name#头像地址
            message.isRead = NO;
            
            message.timestamp = [NSString stringWithFormat:@"%lld", (long long)tmp];
            
            [[DeviceDBHelper sharedInstance].msgDBAccess addMessage:message];
            
            break;
        }
        case 5:{//加好友申请  **申请加好友
            NSString *objId = [userInfo valueForKey:@"objId"];//applyId
            NSString *userName = [userInfo valueForKey:@"userName"];
            NSString *userId = [userInfo valueForKey:@"voipAccount"];
            
            ECProposerMsg * msg = [[ECProposerMsg alloc] init];
            
            msg.groupId = objId;//applyId
            msg.dateCreated =  [NSString  stringWithFormat:@"%f",tmp];
            msg.isRead = NO;
            msg.proposer = [NSString stringWithFormat:@"TL_%@", dataType];
            msg.declared = [NSString  stringWithFormat:@"%@|%@",userId,userName];// organizationName;//申请人名称
            [[DeviceDBHelper sharedInstance].msgDBAccess addGroupMessage:msg];
            
            
            break;
        }
        case 6:{//加好友申请结果  1-成功加 ** 为好友  ，0-**决绝加好友
            NSString *success = [userInfo valueForKey:@"success"];//6 8 9
            NSString *userName = [userInfo valueForKey:@"userName"];
            NSString *userId = [userInfo valueForKey:@"voipAccount"];
            ECProposerMsg * msg = [[ECProposerMsg alloc] init];
            
            msg.groupId = userId;//applyId groupid
            msg.dateCreated =  [NSString  stringWithFormat:@"%f",tmp];
            msg.isRead = NO;
            msg.proposer = [NSString stringWithFormat:@"TL_%@",dataType];//
            msg.declared = [NSString  stringWithFormat:@"%@|%@|%@",userId,userName,success];// organizationName;//申请人名称
            [[DeviceDBHelper sharedInstance].msgDBAccess addGroupMessage:msg];
            break;
        }
        case 71:{//加群申请  ** 申请加入 ** 群
            NSString *objId = [userInfo valueForKey:@"objId"];//groupid
            NSString *userName = [userInfo valueForKey:@"userName"];
            NSString *userId = [userInfo valueForKey:@"voipAccount"];
            NSString *groupId = [userInfo valueForKey:@"rlGroupId"];
            NSString *groupName = [userInfo valueForKey:@"groupName"];
            
            ECProposerMsg * msg = [[ECProposerMsg alloc] init];
            
            msg.groupId = objId;// groupid
            msg.dateCreated =  [NSString  stringWithFormat:@"%f",tmp];
            msg.isRead = NO;
            msg.proposer = [NSString stringWithFormat:@"TL_%@",dataType];//
            msg.declared = [NSString  stringWithFormat:@"%@|%@|%@|%@",userId,userName,groupId,groupName];// organizationName;//申请人名称
            [[DeviceDBHelper sharedInstance].msgDBAccess addGroupMessage:msg];

            
            break;
        }
        case 81:{ //加群申请结果  1-成功加入 ** 群 0-**群拒绝加入
            NSString *success = [userInfo valueForKey:@"success"];//6 8 9
            NSString *groupId = [userInfo valueForKey:@"rlGroupId"];
            NSString *groupName = [userInfo valueForKey:@"groupName"];
            ECProposerMsg * msg = [[ECProposerMsg alloc] init];
            
            msg.groupId = groupId;//applyId groupid
            msg.dateCreated =  [NSString  stringWithFormat:@"%f",tmp];
            msg.isRead = NO;
            msg.proposer = [NSString stringWithFormat:@"TL_%@",dataType];//
            msg.declared = [NSString  stringWithFormat:@"%@|%@|%@",groupId,groupName,success];// organizationName;//申请人名称
            [[DeviceDBHelper sharedInstance].msgDBAccess addGroupMessage:msg];

            break;
        }
        case 9:{//组织加入成功推送  成功加入 ** 组织
            NSString *organizationId = [userInfo valueForKey:@"orgId"];
            NSString *organizationName = [userInfo valueForKey:@"orgName"];
            NSString *success = [userInfo valueForKey:@"success"];//6 8 9
            ECProposerMsg * msg = [[ECProposerMsg alloc] init];
            
            msg.groupId = organizationId;//applyId groupid
            msg.dateCreated =  [NSString  stringWithFormat:@"%f",tmp];
            msg.isRead = NO;
            msg.proposer = [NSString stringWithFormat:@"TL_%@",dataType];//
            msg.declared = [NSString  stringWithFormat:@"%@|%@|%@",organizationId,organizationName,success];// organizationName;//申请人名称

            [[DeviceDBHelper sharedInstance].msgDBAccess addGroupMessage:msg];
            break;
        }
        
        default:
            break;
    }
    
    self.hasNewMessage = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onMesssageChanged object:nil];
    
//    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}


-(void)gotoUserInfoView:(NSString *)loginId{
    
    if (loginId.length==0) {
        return;
    }
    
    if ([GUserDataHelper isLoginUser:loginId]) {

        [self gotoRootViewController];
        [self.rootViewController setSelectedIndex:3];//进入个人中心
        
    }else{
        [self pushViewControllerWithName:@"TLContactDetailViewController" itemData:@{@"loginId":loginId} block:^(id obj) {
            
        }];
    }
}

-(void)gotoGroupInfoView:(NSString *)groupId{
    TLGroupDataDTO *dto = [[TLGroupDataDTO alloc] init];
    dto.groupId = groupId;
    [RTLHelper pushViewControllerWithName:@"TLGroupDetailViewController" itemData:dto block:^(id obj) {
        
    }];
}




//TLWaitingViewController
-(void)gotoWaitingViewController{
    NSString *firstCls = @"TLWaitingViewController";
    SuperViewController *waitingViewController = [[NSClassFromString(firstCls) alloc] init];
    DUNavigationController *nav = [[DUNavigationController alloc] initWithRootViewController:waitingViewController];
    
    TLAppDelegate.window.rootViewController = nav;
    [TLAppDelegate.window addSubview:nav.view];
    //[TLAppDelegate.window makeKeyAndVisible];
    [TLAppDelegate.window makeKeyAndVisible];
}

-(void)checkHasNewMessage{
    TLSysMessageListRequestDTO *request = [[TLSysMessageListRequestDTO alloc] init];
    
    request.currentPage = @"1";
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.currentTime = [RUtiles stringFromDateWithFormat:[NSDate new] format:@"yyyyMMddHHmmss"];
    request.type = @"1";//all
    [GTLModuleDataHelper sysMessageList:request requestArr:[NSMutableArray array] block:^(id obj, BOOL ret) {
        
        
        
        
        
        if (ret) {
            NSArray *array  = obj;
            if (array.count>0) {
                self.hasNewMessage = YES;
                self.systemMessageCount =[NSString stringWithFormat:@"%lu", (unsigned long)array.count];
            }else{
                self.hasNewMessage = NO;
            }

        }else{
        }
        
    }];
}



-(void)saveAndShowImage:(UIImage*)image imageName:(NSString*)imageName{
    
    
    
    NSString *fileName = [NSString stringWithFormat:@"%@.JPEG",imageName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //并给文件起个文件名
    NSString *imageDir = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"MST"] stringByAppendingPathComponent:@"images"];
    NSLog(@"imagedir:%@",imageDir);
    
    NSString *imagePath =[imageDir stringByAppendingPathComponent:fileName];
    NSLog(@"imagePath:%@",imagePath);
    
    
    //创建文件夹路径
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    //创建图片
    //[UIImagePNGRepresentation([UIImage imageWithData:data]) writeToFile:imagePath atomically:YES];
    [UIImageJPEGRepresentation(image,1) writeToFile:imagePath atomically:YES];
    
    [GUserDefault setValue:fileName forKey:imageName];
    NSLog(@"聊天背景图片名称:%@",[GUserDefault valueForKey:imageName]);
    

}

@end
