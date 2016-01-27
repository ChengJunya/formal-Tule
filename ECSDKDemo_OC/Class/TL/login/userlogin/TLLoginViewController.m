//
//  LoginViewController.m
//  MST
//
//  Created by Rainbow on 14/7/29.
//  Copyright (c) 2014年 MST. All rights reserved.
//

#import "TLLoginViewController.h"
#import "FogotPwdStepAController.h"
#import "ZXTextField.h"
#import "ZXUIHelper.h"
#import "ZXColorButton.h"
#import "UserDataHelper.h"
#import "LoginRequestDTO.h"
#import "TLHelper.h"
#import "UserInfoDTO.h"
#import "TLModuleDataHelper.h"

#import "TLMyFriendListRequestDTO.h"
#import "TLSimpleUserDTO.h"


@interface TLLoginViewController ()
{
    ZXTextField *_loginNameField;
    ZXTextField *_loginPwdField;
    UILabel *_loginNameShowInfo;
    UILabel *_loginPwdShowInfo;
    UIScrollView *_scrollView;
    
    NSArray *friends;
}

@property(nonatomic, retain) UIWebView *webview;
@property(nonatomic, retain) UIView *taobaoLogin;
@property(nonatomic, retain) UIButton *backBtn;

@end


@implementation TLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    friends = [NSArray array];
    self.title = MultiLanguage(logvcLogin);
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = [UIImage imageNamed:@"tl_login_bg.jpg"];
    [self.view addSubview:backgroundImageView];
    
    [self addAllUIResources];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = COLOR_DEF_BG;


    self.navBackItemHidden = YES;
    self.navMsgIconHidden = YES;
    self.navBarHidden = YES;

    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark - ui

- (void)addAllUIResources
{
    
   
    CGFloat offsetY = 80.f;

    WEAK_SELF(self);
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    UIButton *goBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-90.f, 20.f, 90.f, 30.f)];
    [goBtn setTitle:@"前往主页>>" forState:UIControlStateNormal];
    [goBtn setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
    [_scrollView addSubview:goBtn];
    goBtn.titleLabel.font = FONT_16B;
    [goBtn addTarget:self action:@selector(closeVc) forControlEvents:UIControlEventTouchUpInside];
    

    
    // input textfield
    CGSize inputFieldSize = CGSizeMake(UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    CGRect inputFileRect = (CGRect){.origin = CGPointZero, .size = inputFieldSize};
    ZXTextField *loginNameField = [[ZXTextField alloc] initWithFrame:inputFileRect];
    loginNameField.center = CGPointMake(SCREEN_WIDTH/2.f, 80.f+offsetY);
    loginNameField.placeholder = MultiLanguage(logvcUserName);
    loginNameField.largeTextLength = 11;
    loginNameField.text = @"";
    loginNameField.font = FONT_16;
    loginNameField.keyboardType = UIKeyboardTypeNumberPad;
    loginNameField.autoHideKeyboard = YES;
    loginNameField.leftIconName = @"tl_login_user";
    loginNameField.underLineIconName = @"log_accounts_line.png";
    [scrollView addSubview:loginNameField];
    _loginNameField = loginNameField;
    
    
    //UserDefault_LastUserLoginId
    NSString *loginId = [GUserDefault valueForKey:UserDefault_LastUserLoginId];
    if (loginId.length>0) {
        _loginNameField.text = loginId;
    }
    
    ZXTextField *loginPwdField = [[ZXTextField alloc] initWithFrame:inputFileRect];
    loginPwdField.center = CGPointMake(SCREEN_WIDTH/2.f, 140.f+offsetY);
    loginPwdField.placeholder = MultiLanguage(logvcPassword);
    loginPwdField.largeTextLength = 20;
    loginPwdField.text = @"";
    loginPwdField.font = FONT_16;
    loginPwdField.zxBorderWidth = 0.f;
    loginPwdField.secureTextEntry = YES;
    loginPwdField.autoHideKeyboard = YES;
    loginPwdField.leftIconName = @"tl_password";
    loginPwdField.underLineIconName = @"log_accounts_line.png";
    [scrollView addSubview:loginPwdField];
    _loginPwdField = loginPwdField;
    
    // login button
    CGRect loginBtnFrame = CGRectMake(UI_LAYOUT_MARGIN, 180.f+offsetY, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    UIButton *loginBtn = [ZXColorButton buttonWithType:EZXBT_SOLID_GREEN frame:loginBtnFrame title:MultiLanguage(logvcLogin) font:FONT_18 block:^{
        [weakSelf clickLoginButton];

    }];
    [scrollView addSubview:loginBtn];
    
    CGRect fogotPwdBtnFrame = CGRectMake(2.f, 238.f+offsetY, 90.f, 28.f);
    CGRect newUserBtnFrame = CGRectMake(SCREEN_WIDTH-UI_LAYOUT_MARGIN-90.f, 235.f+offsetY, 90.f, 28.f);

    
    // fogot password
    UIButton *fogotPwdBtn = [ZXUIHelper addUIButtonWithNormalImage:nil hilightImage:nil frame:fogotPwdBtnFrame title:MultiLanguage(logvcFogotPwd) font:FONT_14 toTarget:scrollView];
    [fogotPwdBtn setTitleColor:COLOR_BTN_BOX_GRAY_TEXT forState:UIControlStateNormal];
    fogotPwdBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [fogotPwdBtn addTarget:self action:@selector(clickFogotPwdButton) forControlEvents:UIControlEventTouchUpInside];
    
    // new user
    UIButton *newUserBtn = [ZXColorButton buttonWithType:EZXBT_BOX_GREEN frame:newUserBtnFrame title:MultiLanguage(logvcNewUser) font:FONT_14 block:^{
        [weakSelf clickNewUserButton];
    }];
  
    [scrollView addSubview:newUserBtn];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


#pragma mark -
#pragma mark - net request

- (void)sendLoginRequest
{
    NSString *username = [_loginNameField.text copy];
    NSString *password = [_loginPwdField.text copy];
    
    
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GUserDataHelper loginWithUsername:username password:password type:1 block:^(ResponseDTO *obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            
        }
        else {
            [GHUDAlertUtils toggleMessage:obj.resultDesc];
            [GHUDAlertUtils hideLoadingInView:self.view];
        }
    }];
    
    
    
    
}




#pragma mark -
#pragma mark - action

- (BOOL)canBecomeFirstResponder
{
    return YES;
}


-(void)closeVc{
    [RTLHelper gotoRootViewController];
}


- (void)clickLoginButton
{
    // 隐藏键盘
    [self becomeFirstResponder];
    
    // 检测数据并发送请求
    if ([_loginNameField.text isEqualToString:@""] || [_loginPwdField.text isEqualToString:@""]) {
        [GHUDAlertUtils toggleMessage:@"用户名或密码不能为空"];
    }
    else{
        [self sendLoginRequest];
    }
}

- (void)clickFogotPwdButton
{
    [self pushViewControllerWithName:@"FogotPwdStepAController" block:^(FogotPwdStepAController *obj) {
        obj.forPurpose = PhoneVerify4ForgetPwd;
    }];
}

- (void)clickNewUserButton
{
    [self pushViewControllerWithName:@"RegisterStepAViewController" block:nil];
}

-(void)getFriends{
    
}


-(void)initUserData{
//    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"userinfo.json"]];
//    NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//    NSDictionary *userInfoData = [jsonParser objectWithString:jsonStr];
//    self.userDic = [NSMutableDictionary dictionaryWithDictionary:userInfoData];
    
//    TLMyFriendListRequestDTO *request = [[TLMyFriendListRequestDTO alloc] init];
//   
//    
//    [GHUDAlertUtils toggleLoadingInView:self.view];
//    [GTLModuleDataHelper myFriendList:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
//        
//        //buyInfo endDate
//        [GHUDAlertUtils hideLoadingInView:self.view];
//        if (ret) {
//            friends = obj;
//            
//        }else{
//            ResponseDTO *response = obj;
//            [GHUDAlertUtils toggleMessage:response.resultDesc];
//        }
//    }];
    
    
    [[DemoGlobalClass sharedInstance].mainAccontDictionary removeAllObjects];
    
    [[DemoGlobalClass sharedInstance].appInfoDictionary  removeAllObjects];
    
    //[[DemoGlobalClass sharedInstance].subAccontsArray removeAllObjects];
    
    //保存主账号信息
    NSMutableDictionary* AccountInfo = [DemoGlobalClass sharedInstance].mainAccontDictionary;
    [AccountInfo setObject: @"8a48b5514a61a814014a8083efe412c2" forKey:@"main_account"];
    [AccountInfo setObject: @"d95363490dae11e5ac73ac853d9f54f2" forKey:@"main_token"];
    [AccountInfo setObject: @"途乐" forKey:@"nick_name"];
    [AccountInfo setObject: @"18612701019" forKey:@"mobile"];
    [AccountInfo setObject: @"" forKey:@"test_number"];
    
    
    //保存应用信息
    NSMutableDictionary* ApplicationDict = [DemoGlobalClass sharedInstance].appInfoDictionary;
    [ApplicationDict setObject: @"8a48b5514d07eb90014d1deda6d90b90" forKey:@"appId"];
    [ApplicationDict setObject: @"tule" forKey:@"appName"];

    
    
//    //保存子账号信息
//    NSMutableArray* subAccountArray = [DemoGlobalClass sharedInstance].subAccontsArray;
//    
//    [friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [subAccountArray addObject:obj];
//    }];
    
    
}
//
//-(void)testLogin{
//    [[NSUserDefaults standardUserDefaults]setObject:@"yf.it@163.com" forKey:@"userName"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    [self getDemoAccoutsWithUserName:@"yf.it@163.com" andUserPwd:@"peter2004"];
//}
//
///**
// *@brief 获取主账号下的测试子账号
// */
//-(void)getDemoAccoutsWithUserName:(NSString*)userName andUserPwd:(NSString*)userPwd
//{
//    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"正在获取账号信息";
//    hud.removeFromSuperViewOnHide = YES;
//    
//    NSString *requestUrl = @"https://sandboxapp.cloopen.com:8883/2013-12-26/General/GetDemoAccounts";
//    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
//    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
//    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
//    
//    [manager setResponseSerializer:[AFXMLParserResponseSerializer new]];
//    
//    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
//        NSString * xmlBody = [NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF8'?><Request><user_name>%@</user_name><user_pwd>%@</user_pwd></Request>",userName,userPwd];
//        return __BASE64(xmlBody);
//    }];
//    
//    [manager POST:requestUrl parameters:@"" success:^(AFHTTPRequestOperation * operation,id responseObject){
//        
//        id responseData = operation.responseData;
//        
//        NSString * errorString = [self parseAccontsResponseString:operation.responseData];
//        if (errorString) {
//            ECNoTitleAlert(errorString)
//        }
//        else{
//            //[self LoginSuccess];
//        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        
//        [self logoBtnTouch:nil];
//        
//    } failure:^(AFHTTPRequestOperation * operation,NSError * error)
//     {
//         ECNoTitleAlert(@"请求发生错误")
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//     }];
//}






@end
