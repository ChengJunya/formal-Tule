//
//  RootViewController.m
//  alijk
//
//  Created by easy on 14/7/29.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "SuperViewController.h"
#import "UIBarButtonItem+Badge.h"

#import "TLHelper.h"
#import "MBProgressHUD.h"

#import "KxMenu.h"

#import "ZXCheckUtils.h"
#import "ZXUIHelper.h"
#import "CNavigationView.h"



/* 注意：根据目前的示意图，消息icon在所有页面都会显示，
 * 因此将msgIcon的控制和notification都放在此处
 */

@interface SuperViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UIButton *navBackButton;
@property (nonatomic, strong) UIButton *navinfoButton;

@property (nonatomic, strong) UIButton *listButton;
@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, assign) NSInteger navMsgCount;



@end


@implementation SuperViewController
@synthesize navView=_navView;


- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.backgroundColor = COLOR_DEF_BG;
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    self.requestArray = [NSMutableArray array];

    //[self addLongNotification];
    //[GHUDAlertUtils dismissAllHUDWhenEnterVC];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [self createNavBar];
    //[self addCommNotification];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    // cancel all net request
    [self cancelAllNetRequest];

}

#pragma mark -
#pragma mark - tools

- (void)listAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TL_DRAWER_OPEN_LEFT object:nil];
}

- (void)searchAction
{
    //
}

- (void)cancelAllNetRequest
{
//    for (NSNumber *req in self.requestArray) {
////        [GDataManager cancelAsyncRequestByTag:req];
//    }
//    [self.requestArray removeAllObjects];
}

- (void)updateUnreadMsgCount
{
    // 如果还未登录成功，直接返回
//    if (!GUserDataHelper.isLoginSucceed) {
//        [self setNavRedStoreVisible];
//        self.navinfoButton.badgeValue = @"0";
//        return;
//    }
    
//    __weak SuperViewController *weakSelf = self;
//    [GNewsDataHelper getUnreadMsgCount:nil block:^(NSInteger value) {
//        weakSelf.navMsgCount = value;
//        if (value >= 0) {
//            NSString *unreadMsg = [NSString stringWithFormat:@"%ld", (long)value];
//            if (value > 99) {
//                unreadMsg = @"99+";
//            }
//            weakSelf.navinfoButton.badgeValue = unreadMsg;
//        }
//        else {
//            [weakSelf setNavRedStoreVisible];;
//        }
//    }];
}

-(void)removeAllUIResources{
    
}


-(void)addAllUIResources{
    
}

#pragma mark -
#pragma mark - notification

- (void)addCommNotification
{
    [GNotifyCenter addObserver:self selector:@selector(notifyToUpdateUIWhenNewsArriver:) name:NOTIFICATION_UPDATE_UNREADMSGCOUNT object:nil];
    [GNotifyCenter addObserver:self selector:@selector(notifyToBeKickoff:) name:NOTIFICATION_BEKICKOFF object:nil];
    [GNotifyCenter addObserver:self selector:@selector(notifyToTallAction:) name:NOTIFICATION_TALL_ACTION object:nil];
    [GNotifyCenter addObserver:self selector:@selector(checkToGotoAutoPushVC) name:NOTIFICATION_GOTO_NEXTVC_MSG_ARRIVE object:nil];
}

- (void)removeCommNotification
{
    [GNotifyCenter removeObserver:self name:NOTIFICATION_UPDATE_UNREADMSGCOUNT object:nil];
    [GNotifyCenter removeObserver:self name:NOTIFICATION_BEKICKOFF object:nil];
    [GNotifyCenter removeObserver:self name:NOTIFICATION_TALL_ACTION object:nil];
    [GNotifyCenter removeObserver:self name:NOTIFICATION_GOTO_NEXTVC_MSG_ARRIVE object:nil];
}

- (void)addLongNotification
{
    [GNotifyCenter addObserver:self selector:@selector(notifyToRefeshUIWhenMsgArrive:) name:NOTIFICATIONREFRESH_UI_MSG_ARRIVE object:nil];
}

- (void)removeLongNotification
{
    [GNotifyCenter removeObserver:self name:NOTIFICATIONREFRESH_UI_MSG_ARRIVE object:nil];
}

- (void)notifyToUpdateUIWhenNewsArriver:(NSNotification*)notify
{
    // 如果还未登录成功，直接返回
//    if (!GUserDataHelper.isLoginSucceed) {
//        return;
//    }
    
    if (!self.navMsgIconHidden) {
        [self updateUnreadMsgCount];
    }
}

- (void)notifyToBeKickoff:(NSNotification*)notify
{
    // 如果还未登录成功，直接返回
//    if (!GUserDataHelper.isLoginSucceed) {
//        return;
//    }
    if ([self isKindOfClass:NSClassFromString(@"LoginViewController")]) {
        return;
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [GUserDataHelper exitLogin:NO];
//        ResponseDTO *jsonModel = notify.object;
//        [GHUDAlertUtils toggleMessage:jsonModel.retMessage];
//    });
}

- (void)notifyToTallAction:(NSNotification*)notify
{

}

- (void)notifyToRefeshUIWhenMsgArrive:(NSNotification*)notify
{
    // 获取通知消息类型
    NSDictionary *dict = notify.object;
    NSString *msgType = [dict objectForKey:@"msgType"];
    
    // 通知消息到达后，相关页面需要刷新，根据msgType进行判断
    [self refreshUIWhenMsgArrive:msgType];
}

/*
 * 通知消息到达后，相关页面需要刷新，根据msgType进行判断
 * 1:询价响应; 3:药店备货; 4:药店送货; 5:待评价; 6处方打回,当前范围无药店,咨询无响应)
 */
- (void)refreshUIWhenMsgArrive:(NSString*)msgType {
    // 需要根据通知更新页面的子类实现该方法
}

#pragma mark -
#pragma mark - navigation bar

- (void)setNavBackItemHidden:(BOOL)navBackItemHidden
{
    _navBackItemHidden = navBackItemHidden;
    if (navBackItemHidden) {
        self.navView.backBtn = nil;
    }
    else {
        if (!self.navBackButton) {
            self.navBackButton = [self createNavBackButton];
        }
        self.navView.backBtn = self.navBackButton;
    }
}

-(void)setListBtnHidden:(BOOL)listBtnHidden{
    _listBtnHidden = listBtnHidden;
    if (_listBtnHidden) {
        self.navView.backBtn = nil;
    }
    else {
        if (!self.listButton) {
            self.listButton = [self createListButton];
        }
        self.navView.backBtn = self.listButton;
    }
}

-(void)setSearchBtnHidden:(BOOL)searchBtnHidden{
    _searchBtnHidden = searchBtnHidden;
    if (_searchBtnHidden) {
        self.navView.actionBtns = @[];
    }
    else {
        if (!self.searchButton) {
            self.searchButton = [self createSearchButton];
        }
        self.navView.actionBtns = @[self.searchButton];
    }
}

- (void)setNavBarHidden:(BOOL)navBarHidden
{
    _navBarHidden = navBarHidden;
    
    if (_navBarHidden) {
        if (self.navView) {
            [self.navView removeFromSuperview];
        }
    }else{
        if (!self.navView) {
            [self createNavBar];
        }
        [self.view addSubview:self.navView];
    }
    
    
    //self.navigationController.navigationBarHidden = navBarHidden;
    
}

- (void)setNavMsgIconHidden:(BOOL)navMsgIconHidden
{
    _navMsgIconHidden = navMsgIconHidden;
    if (navMsgIconHidden) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
        if(!self.navView) {
            self.navView = [[CNavigationView alloc] initWithFrameAndProperties:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT) title:self.title font:FONT_18 color:COLOR_NAV_TEXT imageName:nil backBtn:nil actionBtns:nil bgColor:COLOR_NAV_BAR isShowStatusBar:YES viewController:self];
            
            
            [self.view addSubview:self.navView];
        }
        
        //self.navigationItem.rightBarButtonItem = self.navinfoButton;
        [self updateUnreadMsgCount];
    }
    

    
    

}

- (void)setNavMsgIconEnable:(BOOL)navMsgIconEnable
{
    // !!!重要：如果前一个页面是消息页面，本页面的消息图标不能点击
    /*
     NSArray *viewControllers = [self.navigationController viewControllers];
     if ([viewControllers count] > 1) {
     SuperViewController *lastVC = viewControllers[viewControllers.count - 2];
     if ([lastVC isKindOfClass:NSClassFromString(@"MyMessageViewController")]) {
     navMsgIconEnable = NO;
     }
     }
     */
    _navMsgIconEnable = navMsgIconEnable;
    self.navinfoButton.enabled = navMsgIconEnable;
}

- (UIButton*)createNavBackButton
{
    
//    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [backButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(navBackAction) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

- (UIButton*)createListButton
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [backButton setImage:[UIImage imageNamed:@"tl_more"] forState:UIControlStateNormal];
//    [backButton setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(listAction) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

- (UIButton*)createSearchButton
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [backButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    //[backButton setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

- (UIBarButtonItem*)createNavInfoButton:(NSString*)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    infoBtn.frame = CGRectMake(0.f, 0.f, 23.f, 23.f);
    [infoBtn addTarget:self action:@selector(navMessageAction:) forControlEvents:UIControlEventTouchDown];
    [infoBtn setBackgroundImage:image forState:UIControlStateNormal];
    [infoBtn setBackgroundImage:image forState:UIControlStateDisabled];
    
    UIBarButtonItem *navinfoButton = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    navinfoButton.badgeOriginY = -6;
    navinfoButton.badgeMinSize = 5;
    navinfoButton.shouldHideBadgeAtZero = YES;
    
    return navinfoButton;
}

- (void)setNavRedStoreVisible
{
    
}

-(void)createNavBar{
    self.navView = [[CNavigationView alloc] initWithFrameAndProperties:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT) title:self.title font:FONT_18B color:COLOR_NAV_TEXT imageName:nil backBtn:nil actionBtns:nil bgColor:COLOR_NAV_BAR isShowStatusBar:YES viewController:self];
}


#pragma mark -
#pragma mark - action

- (void)navBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)navMessageAction:(id)sender
{
    [self showExpandMenu:sender];
}

- (void)navExpandMenuMsgAction
{
    [self pushViewControllerWithName:@"MessageTypeViewController" block:nil];
    
}

- (void)navExpandMenuHomeAction
{
    [self.navigationController setToolbarHidden:YES animated:NO];
    [self directPopToHomeVC];
}

- (void)navExpandMenuShareAction
{
    
}

- (void)showExpandMenu:(UIButton*)sender
{
   
}

#pragma mark -
#pragma mark - pushViewController

/* pushViewController
 * vcname：下一个VC的名称
 * block：执行push操作前需要执行的操作
 */
- (void)pushViewControllerWithName:(NSString*)vcname block:(Id_Block)block
{
    SuperViewController *pushVC = [[NSClassFromString(vcname) alloc] init];
    if (block) {
        block(pushVC);
    }
    
    BOOL isAnimated = YES;
    [self.navigationController pushViewController:pushVC animated:isAnimated];
}



- (void)pushViewControllerWithName:(NSString*)vcname itemData:(id)itemData block:(Id_Block)block{
    SuperViewController *pushVC = [[NSClassFromString(vcname) alloc] init];
    if (block) {
        block(pushVC);
    }
    pushVC.itemData = itemData;
    BOOL isAnimated = YES;
    [self.navigationController pushViewController:pushVC animated:isAnimated];
}


/*
 * 检测是否能能直接进入下一个页面，如果不行的话，需要先登录
 */
- (BOOL)checkToGotoNextVC:(NSString*)vcname
{
    
    
    return NO;
}

/*
 * 弹出提示框，要求登录
 */
- (void)showAlertToLogin
{

}


- (void)gotoNextVCWhenLoginSucceed:(BOOL)isFromLoginNav
{
#if DELAY_LOGIN_ONE_NAV
    [self gotoNextVCWhenLoginSucceed_Impl];
#else
    if (isFromLoginNav) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [self gotoNextVCWhenLoginSucceed_Impl];
        }];
    }
    else {
        [self gotoNextVCWhenLoginSucceed_Impl];
    }
#endif
}

/*
 * 登录成功后进入相应页面
 * 1.自动登录，注册新用户登录，找回密码登录，没有登录的情况：进入首页
 * 2.没有登录的情况下，进入首页后点击需要用户信息的页面；退出已经登录的账户，然后再次登录
 */
- (void)gotoNextVCWhenLoginSucceed_Impl
{
    
}

/*
 * 检测是否能进入消息页面或者活动页面
 * 考虑的情况：
 *（1）程序没有启动过或睡眠的时间很长，点击系统通知后重新启动程序，待程序进入HomeVC后再跳转到相应页面
 *（2）程序进入后台，点击系统通知后，会进入程序之前显示的页面，再直接跳转到相应页面
 *（3）程序运行时，状态栏弹出消息通知，点击通知后进入相应页面
 */
- (void)checkToGotoAutoPushVC
{
    
}

- (BOOL)isHomeViewController
{
    if ([NSStringFromClass([self class]) isEqualToString:@"HomeViewController"]) {
        return YES;
    }
    return NO;
}

/*
 * 直接跳转到homeViewController
 */
- (void)directPopToHomeVC
{
    for(UIViewController* vc in self.navigationController.viewControllers) {
        if ([NSStringFromClass([vc class]) isEqualToString:@"HomeViewController"]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}



@end
