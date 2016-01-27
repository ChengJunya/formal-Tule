//
//  MainViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "MainViewController.h"
#import "SUNSlideSwitchView.h"
#import "SessionViewController.h"
#import "ContactListViewController.h"
#import "GroupListViewController.h"
#import "SettingViewController.h"
#import "CreateGroupViewController.h"
#import "AppDelegate.h"
#import "SelectViewController.h"
#import "CommonTools.h"

NSString *const Notification_ChangeMainDisplay = @"Notification_ChangeMainDisplay";

#warning 使用 SUNSlideSwitchView 需要tableview高度减少；如果不使用，设置未0.0f即可
const CGFloat NavAndBarHeight = 64.0f;

@interface MainViewController()<SUNSlideSwitchViewDelegate, SlideSwitchSubviewDelegate>

//显示的内容view
@property (nonatomic, strong) SessionViewController *sessionView;
@property (nonatomic, strong) ContactListViewController *contactView;
@property (nonatomic, strong) GroupListViewController *groupListView;

@property (nonatomic, strong) UIView *menuView;



@end

@implementation MainViewController
{
    SUNSlideSwitchView *_slideSwitchView;
    BOOL notFirst;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLoginClient) name:KNOTIFICATION_onNetworkChanged object:nil];
    
    self.title = @"云通讯IM";
    
     UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClicked)];
    self.navigationItem.rightBarButtonItem =rightBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMainDisplaySubview:) name:Notification_ChangeMainDisplay object:nil];

    //滑动效果的添加
    _slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_slideSwitchView];
    _slideSwitchView.slideSwitchViewDelegate = self;
    
    _slideSwitchView.tabItemNormalColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1];
    _slideSwitchView.tabItemSelectedColor = [UIColor colorWithRed:0 green:0.75 blue:0.44 alpha:1];
    _slideSwitchView.shadowImage = [[UIImage imageNamed:@"navigation_bar_on"]
                                        stretchableImageWithLeftCapWidth:50.f topCapHeight:5.0f];
    
    self.sessionView = [[SessionViewController alloc] init];
    self.sessionView.title = @"沟通";
    self.sessionView.mainView = self;
    
    self.contactView = [[ContactListViewController alloc] init];
    self.contactView.title = @"联系人";
    self.contactView.mainView = self;
    
    self.groupListView = [[GroupListViewController alloc] init];
    self.groupListView.title = @"群组";
    self.groupListView.mainView = self;
    
    [_slideSwitchView buildUI];
    
}

-(void)rightBtnClicked
{
    if (self.menuView == nil) {
        
        self.menuView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.menuView action:@selector(removeFromSuperview)];
        [self.menuView addGestureRecognizer:tap];

        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(160, 64.0f, 150, 120)];
        view.tag =50;
        view.backgroundColor = [UIColor blackColor];
        [self.menuView addSubview:view];
        UIButton * converseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        converseBtn.frame =CGRectMake(0, 0, 150, 40);
        [converseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [converseBtn setTitle:@"发起会话/群聊" forState:UIControlStateNormal];
        [converseBtn addTarget:self action:@selector(converseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:converseBtn];
        UIButton * createmoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        createmoreBtn.frame =CGRectMake(0, 40, 150, 40);
        [createmoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [createmoreBtn setTitle:@"创建群组" forState:UIControlStateNormal];
        [createmoreBtn addTarget:self action:@selector(createmoreBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:createmoreBtn];
        UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setBtn.frame =CGRectMake(0, 80, 150, 40);
        [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [setBtn setTitle:@"设置" forState:UIControlStateNormal];
        [setBtn addTarget:self action:@selector(setBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:setBtn];
    }
    
    if (self.menuView.superview == nil) {
        [self.view.window addSubview:self.menuView];
    }
}

-(void)ClearView
{
    [self.menuView removeFromSuperview];
}

-(void)converseBtnClicked
{
    NSLog(@"发起会话");
    SelectViewController * svc = [[SelectViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
    svc.dict = [DemoGlobalClass sharedInstance].loginInfoDic;
    [self ClearView];
}

-(void)createmoreBtnClicked
{
    NSLog(@"创建群组");
    CreateGroupViewController * cgvc = [[CreateGroupViewController alloc]init];
    [self.navigationController pushViewController:cgvc animated:YES];
    cgvc.dict = [DemoGlobalClass sharedInstance].loginInfoDic;
    [self ClearView];
}

-(void)setBtnClicked
{
    SettingViewController * svc = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
    svc.dict = [DemoGlobalClass sharedInstance].loginInfoDic;
    NSLog(@"svc.dict%@",svc.dict);
    [self ClearView];
}

-(void)changeMainDisplaySubview:(NSNotification*)notification{
    NSInteger selectIndex = [notification.object integerValue];
    [_slideSwitchView setSelectedViewIndex:selectIndex andAnimation:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainviewdidappear" object:nil];
    
    if (notFirst)
    {
        if ( ECNetworkType_NONE != [DemoGlobalClass sharedInstance].netType) {
            [self autoLoginClient];
        }
    }
    else
    {
        [self autoLoginClient];
    }
    notFirst = YES;
}

-(void)autoLoginClient{
    
    NSDictionary *loginInfoDic = [DemoGlobalClass sharedInstance].loginInfoDic;

    if (loginInfoDic && [DemoGlobalClass sharedInstance].isLogin == NO) {
        
        [self.sessionView updateLoginStates:linking];
        ECLoginInfo *loginInfo = [[ECLoginInfo alloc] initWithAccount:loginInfoDic[voipKey] Password:loginInfoDic[pwdKey]];
        
        loginInfo.subAccount = loginInfoDic[subAccountKey];
        loginInfo.subToken = loginInfoDic[subTokenKey];
        
        [[ECDevice sharedInstance] login:loginInfo completion:^(ECError *error) {
            
            if (error.errorCode==ECErrorType_NoError) {
                [self.sessionView updateLoginStates:success];
                
             }
            else
            {
                [self.sessionView updateLoginStates:failed];
            }
            
        }];
    }
}

/*
 * 返回tab个数
 */
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view{
    return 3;
}

/*
 * 每个tab所属的viewController
 */
- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    if (number == 0) {
        return self.sessionView;
    } else if (number == 1) {
        return self.contactView;
    } else if (number == 2) {
        return self.groupListView;
    } else {
        return nil;
    }
}

/*
 * 点击tab
 */
- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number{
    if (number == 0) {
         [self.sessionView prepareDisplay];
    } else if (number == 1) {
        [self.contactView prepareDisplay];
    } else if (number == 2) {
        [self.groupListView prepareGroupDisplay];
    } else {
        
    }
}

#pragma mark - SlideSwitchSubviewDelegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [viewController.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:viewController animated:animated];
}
@end
