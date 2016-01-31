//
//  TLHomeTabbarViewController.m
//  TL
//
//  Created by Rainbow on 2/6/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLHomeTabbarViewController.h"
#import "DUNavigationController.h"
#import "DUShareViewController.h"

#import "ECDeviceHeaders.h"
#import "LoginSelectViewController.h"

#import "CommonTools.h"
#import "GDataXMLParser.h"
#import "DemoGlobalClass.h"
#import "SessionViewController.h"
#import "AppVersionHelper.h"
#import "TLShareDTO.h"
#import "TLHelper.h"
#import "ECSession.h"
#import "RUtiles.h"
@interface TLHomeTabbarViewController ()
//@property (nonatomic,assign) BOOL isOpenMessage;
//@property (nonatomic,assign) BOOL isShowAbout;
@property (nonatomic,strong) DUShareViewController *share;

@property (nonatomic,strong) NSMutableDictionary *userDic;
@end

@implementation TLHomeTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.requestArray = [NSMutableArray array];

    self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"首页" image:[UIImage imageNamed:@"navigation_ bar1a"]  selectedImage:[[UIImage imageNamed:@"navigation_ bar1b"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] vcName:@"TLHomeViewController"],
                            [self viewControllerWithTabTitle:@"消息" image:[UIImage imageNamed:@"navigation_ bar2a"] selectedImage:[[UIImage imageNamed:@"navigation_ bar2b"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]vcName:@"SessionViewController"],
                            [self viewControllerWithTabTitle:@"通信录" image:[UIImage imageNamed:@"navigation_ bar3a"] selectedImage:[[UIImage imageNamed:@"navigation_ bar3b"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]vcName:@"TLContactListViewController"],
                            [self viewControllerWithTabTitle:@"个人中心" image:[UIImage imageNamed:@"navigation_ bar4a"] selectedImage:[[UIImage imageNamed:@"navigation_ bar4b"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]vcName:@"TLMineViewController"], nil];
    [self addNoticifacation];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHECK_VERSION object:@{@"isShowNotice":@"0"}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareDisplay) name:KNOTIFICATION_onMesssageChanged object:nil];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self changeTabMessageCount];
    

}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (self.selectedIndex==1) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",0];
    }

}

-(void)prepareDisplay{
    [self changeTabMessageCount];
}

-(void)changeTabMessageCount{
    __block int totalCount = 0;
    NSArray *sessionArray = [[DeviceDBHelper sharedInstance] getMyCustomSession];
    [sessionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ECSession* session = obj;
        totalCount = totalCount + session.unreadCount;
    }];
    
    if (totalCount==0) {
        
        [[[[self tabBar] items] objectAtIndex:1] setBadgeValue:nil];
        return;
    }
    
    [[[[self tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d",totalCount]];
    
}


-(void)addNoticifacation{
    
    //分享
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showShareView:) name:NOTIFICATION_SHARE object:nil];
    
    //检查更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkToUpdate:) name:NOTIFICATION_CHECK_VERSION object:nil];
    
    

}



-(void)checkToUpdate:(NSNotification *)notification
{
    id noteObj = [notification object];
    NSUInteger isShowNotice = [[noteObj valueForKey:@"isShowNotice"] integerValue];
    [GAppversionHelper checkVersionUpdate:self.requestArray block:^(int updateFlag, NSString *latestVersion,UpdateInfoResponseDTO *versionData) {
        if (1 == updateFlag) {
            
            NSString *versionMessage = versionData.result.updateNote;
            versionMessage = [versionMessage stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
            
            
            RTLHelper.hasNewVersion = YES;
            
            [GHUDAlertUtils showZXColorAlert:@"有新版本需要升级" subTitle:versionMessage cancleButton:MultiLanguage(comCancel) sureButtonTitle:MultiLanguage(setvcAlertBtnSure) COLORButtonType:0 buttonHeight:40 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
                                if (index == 1) {
                                    [GAppversionHelper openAppStoreURL];
                                    RTLHelper.hasNewVersion = NO;
                                }
                            }];
            
        }else{
            if (isShowNotice==1) {
                    [GHUDAlertUtils toggleMessage:@"当前是最新版本！"];
            }
            
        }
    }];
}






- (void)showShareView:(NSNotification *)notification {
    
    TLShareDTO *shareDto = notification.object;
    
    
    
    self.share = [[DUShareViewController alloc] init];
//    _share.shareUrl = @"http://www.baidu.com";//obj.shareUrl;
//    _share.shareDesc = @"途乐，乐在途中！";//obj.shareDesc;
//    _share.shareTitle = @"途乐";//obj.title;
//    _share.shareImageUrl = @"http://file01.16sucai.com/d/file/2013/0720/20130720022635795.jpg";//obj.imageUrl;
//    _share.patAwardId = @"wxf51c8154f251195f";//obj.patAwardId;
    
    
    _share.shareUrl = shareDto.shareUrl;
    _share.shareDesc = shareDto.shareDesc;
    _share.shareTitle = shareDto.shareTitle;
    _share.shareImageUrl = shareDto.shareImageUrl;
    _share.patAwardId = shareDto.patAwardId;
    
    [GApplication.keyWindow addSubview:_share.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willAppearIn:(UINavigationController *)navigationController
{
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tab_center.png"] highlightImage:[UIImage imageNamed:@"tab_center.png"]];
}





/**
 *@brief 解析获取到的账号信息内容
 *@return 解析成功返回nil，失败返回错误信息
 */
//- (NSString*)parseAccontsResponseString:(NSData*)responseData{
//    
//    
//    [[DemoGlobalClass sharedInstance].mainAccontDictionary removeAllObjects];
//    
//    [[DemoGlobalClass sharedInstance].appInfoDictionary  removeAllObjects];
//    
//    [[DemoGlobalClass sharedInstance].subAccontsArray removeAllObjects];
//    
//    NSArray *nameArr = [NSArray arrayWithObjects:@"张三",@"李四",@"王五",@"赵六",@"钱七", nil];
//    
//    GDataXMLDocument *xmldoc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:nil];
//    if (!xmldoc)
//    {
//        return @"XML数据加载失败!";
//    }
//    
//    GDataXMLElement *rootElement = [xmldoc rootElement];
//    
//    NSArray *statuscodeArray = [rootElement elementsForName:@"statusCode"];
//    
//    if (statuscodeArray.count > 0)
//    {
//        GDataXMLElement *element = (GDataXMLElement *)[statuscodeArray objectAtIndex:0];
//        NSString* strStatusCode = element.stringValue;
//        
//        NSString* strMsg = nil;
//        NSArray *statusmsgArray = [rootElement elementsForName:@"statusMsg"];
//        if (statusmsgArray.count > 0)
//        {
//            GDataXMLElement *msgelement = (GDataXMLElement *)[statusmsgArray objectAtIndex:0];
//            strMsg = msgelement.stringValue;
//        }
//        
//        if (strStatusCode.integerValue != 0) {
//            return [NSString stringWithFormat:@"错误码:%@\r错误详情:%@",strStatusCode, strMsg];
//        }
//    }
//    else
//    {
//        return @"状态码没有解析到!";
//    }
//    
//    
//    //保存主账号信息
//    NSMutableDictionary* AccountInfo = [DemoGlobalClass sharedInstance].mainAccontDictionary;
//    [AccountInfo setObject: @"8a48b5514a61a814014a8083efe412c2" forKey:@"main_account"];
//    [AccountInfo setObject: @"7960c6f0ceb24fc1a805087550e6a8ba" forKey:@"main_token"];
//    [AccountInfo setObject: @"途乐" forKey:@"nick_name"];
//    [AccountInfo setObject: @"18612701019" forKey:@"mobile"];
//    [AccountInfo setObject: @"" forKey:@"test_number"];
//    
//    
//    //保存应用信息
//    NSMutableDictionary* ApplicationDict = [DemoGlobalClass sharedInstance].appInfoDictionary;
//    [ApplicationDict setObject: @"8a48b5514ac24e1b014ac3ddaf3d0178" forKey:@"appId"];
//    [ApplicationDict setObject: @"途乐APP" forKey:@"appName"];
//
//    
//    //保存子账号信息
//    NSMutableArray* subAccountArray = [DemoGlobalClass sharedInstance].subAccontsArray;
//    NSArray *friends = [self.userDic valueForKey:@"FRIENDS"];
//    [friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [subAccountArray addObject:obj];
//    }];
//    
//    
//    //appid 应用id aaf98f894b353559014b454784330751
//    NSArray *main_accountArray = [rootElement elementsForName:@"main_account"];
//    if (main_accountArray.count > 0)
//    {
//        GDataXMLElement *valueElement = (GDataXMLElement *)[main_accountArray objectAtIndex:0];
//        [AccountInfo setObject:valueElement.stringValue forKey:@"main_account"];
//    }
//    
//    NSArray *main_tokenArray = [rootElement elementsForName:@"main_token"];
//    if (main_tokenArray.count > 0)
//    {
//        GDataXMLElement *valueElement = (GDataXMLElement *)[main_tokenArray objectAtIndex:0];
//        [AccountInfo setObject: valueElement.stringValue forKey:@"main_token"];
//    }
//    
//    NSArray *nickArray = [rootElement elementsForName:@"nickname"];
//    if (nickArray.count > 0)
//    {
//        GDataXMLElement *valueElement = (GDataXMLElement *)[nickArray objectAtIndex:0];
//        [AccountInfo setObject: valueElement.stringValue forKey:@"nick_name"];
//    }
//    
//    NSArray *mobileArray = [rootElement elementsForName:@"mobile"];
//    if (mobileArray.count > 0)
//    {
//        GDataXMLElement *valueElement = (GDataXMLElement *)[mobileArray objectAtIndex:0];
//        [AccountInfo setObject: valueElement.stringValue forKey:@"mobile"];
//    }
//    
//    NSArray *testnumberArray = [rootElement elementsForName:@"test_number"];
//    if (testnumberArray.count > 0)
//    {
//        GDataXMLElement *valueElement = (GDataXMLElement *)[testnumberArray objectAtIndex:0];
//        [AccountInfo setObject: valueElement.stringValue forKey:@"test_number"];
//    }
//    
//    NSArray *ApplicationsArray = [rootElement elementsForName:@"Application"];
//    if (ApplicationsArray.count > 0)
//    {
//        for (GDataXMLElement *applicationElement in ApplicationsArray)
//        {
//            NSArray *appIdArray = [applicationElement elementsForName:@"appId"];
//            if (appIdArray.count > 0)
//            {
//                GDataXMLElement *valueElement = (GDataXMLElement *)[appIdArray objectAtIndex:0];
//                [ApplicationDict setObject: valueElement.stringValue forKey:@"appId"];
//            }
//            NSArray *appNameArray = [applicationElement elementsForName:@"friendlyName"];
//            if (appNameArray.count > 0)
//            {
//                GDataXMLElement *valueElement = (GDataXMLElement *)[appNameArray objectAtIndex:0];
//                [ApplicationDict setObject: valueElement.stringValue forKey:@"appName"];
//            }
//            
//            NSArray *SubAccountArray = [applicationElement elementsForName:@"SubAccount"];
//            if (SubAccountArray.count > 0)
//            {
//                NSInteger i = 0;
//                for (GDataXMLElement *sub_accountInfoElement in SubAccountArray)
//                {
//                    if (i >= 5) {
//                        break;
//                    }
//                    NSMutableDictionary* sub_accountDict = [[NSMutableDictionary alloc] init];
//                    NSArray *sub_accountArray = [sub_accountInfoElement elementsForName:@"sub_account"];
//                    if (sub_accountArray.count > 0)
//                    {
//                        GDataXMLElement *valueElement = (GDataXMLElement *)[sub_accountArray objectAtIndex:0];
//                        [sub_accountDict setObject: valueElement.stringValue forKey:subAccountKey];
//                    }
//                    
//                    NSArray *sub_tokenArray = [sub_accountInfoElement elementsForName:@"sub_token"];
//                    if (sub_tokenArray.count > 0)
//                    {
//                        GDataXMLElement *valueElement = (GDataXMLElement *)[sub_tokenArray objectAtIndex:0];
//                        [sub_accountDict setObject: valueElement.stringValue forKey:subTokenKey];
//                    }
//                    
//                    NSArray *voipAccountArray = [sub_accountInfoElement elementsForName:@"voip_account"];
//                    if (voipAccountArray.count > 0)
//                    {
//                        GDataXMLElement *valueElement = (GDataXMLElement *)[voipAccountArray objectAtIndex:0];
//                        [sub_accountDict setObject: valueElement.stringValue forKey:voipKey];
//                        [sub_accountDict setObject:nameArr[i++] forKey:nameKey];
//                        [sub_accountDict setObject:[NSString stringWithFormat:@"select_account_photo_%d",i] forKey:imageKey];
//                    }
//                    
//                    NSArray *voip_tokenArray = [sub_accountInfoElement elementsForName:@"voip_token"];
//                    if (voip_tokenArray.count > 0)
//                    {
//                        GDataXMLElement *valueElement = (GDataXMLElement *)[voip_tokenArray objectAtIndex:0];
//                        [sub_accountDict setObject: valueElement.stringValue forKey:pwdKey];
//                    }
//                    
//                    [subAccountArray addObject:sub_accountDict];
//                }
//            }
//        }
//    }
//    return nil;
//}

@end
