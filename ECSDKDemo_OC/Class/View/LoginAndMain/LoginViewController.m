//
//  LoginViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/4.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "LoginViewController.h"
#import "ECDeviceHeaders.h"
#import "LoginSelectViewController.h"
#import "CommonTools.h"
#import "GDataXMLParser.h"
#import "DemoGlobalClass.h"
#import "SessionViewController.h"

@interface LoginViewController()<ECDeviceDelegate>

@end

@implementation LoginViewController
{
    UITextField * _userName;
    UITextField * _password;
    UIButton * _loginBtn;
    UIButton * _registerBtn;
    UIView * _registerView;
    UIView * _loginView;
}

//界面布局
-(void)prepareUI
{
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.enabled = NO;
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"log_registration_notselected"] forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"log_loginselect"] forState:UIControlStateDisabled];
    [_loginBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    _loginBtn.frame = CGRectMake(0, 64, 160, 61.5);
    [_loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setTitle:@"注 册" forState:UIControlStateNormal];
    [_registerBtn setBackgroundImage:[UIImage imageNamed:@"log_registration_notselected"] forState:UIControlStateNormal];
     [_registerBtn setBackgroundImage:[UIImage imageNamed:@"log_loginselect"] forState:UIControlStateDisabled];
    _registerBtn.frame = CGRectMake(160, 64, 160, 50);
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _registerBtn.frame.origin.y+_registerBtn.frame.size.height, 320.0f, [UIScreen mainScreen].applicationFrame.size.height-44.0f)];
    rightView.backgroundColor = [UIColor whiteColor];
    _registerView = rightView;
    [self.view addSubview:_registerView];

    NSArray *textArr = [[NSArray alloc] initWithObjects:@"登录yuntongxun.com并注册", @"填写注册基本信息", @"注册成功,获得8元测试体验费", nil];
    for(int i = 0 ;i<3 ;i++)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 46+90*i, 200, 30)];
        label.textColor =[UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.00f];
        label.text = [textArr objectAtIndex:i];
        if (i==0) {
            NSMutableAttributedString *str = [label.attributedText mutableCopy];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.7 blue:0.46 alpha:1] range:NSMakeRange(2,14)];
            label.attributedText = str;
        }
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentRight;
        [_registerView addSubview:label];
    }
    
    UIImageView * registerImage = [[UIImageView alloc]initWithFrame:CGRectMake(230, 11, 23, 241)];
    registerImage.image = [UIImage imageNamed:@"registration_number"];
    [_registerView addSubview:registerImage];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _loginBtn.frame.origin.y+_loginBtn.frame.size.height, 320.0f, [UIScreen mainScreen].applicationFrame.size.height-44.0f)];
    _loginView = leftView;
    leftView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftView];

    self.title =@"途乐-乐在途中";
    
    UIImageView * headImageview = [[UIImageView alloc]initWithFrame:CGRectMake(20, 45, 24, 24)];
    headImageview.image = [UIImage imageNamed:@"log_accounts_icon"];
    [_loginView addSubview:headImageview];
    
    UIImageView * passImageview = [[UIImageView alloc]initWithFrame:CGRectMake(20, 115, 24, 24)];
    passImageview.image = [UIImage imageNamed:@"log_password_icon"];
    [_loginView addSubview:passImageview];
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(55, 35, 265, 45)];
    _userName.placeholder =@"请输入云通讯注册邮箱";
    //YF_TEST
    _userName.text = @"yf.it@163.com";
    
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 280, 1)];
    label1.backgroundColor =[UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    [_loginView addSubview:label1];
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 280, 1)];
    label2.backgroundColor =[UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    [_loginView addSubview:label2];
    
    _password = [[UITextField alloc]initWithFrame:CGRectMake(55, 105, 265, 45)];
    _password.placeholder =@"请输入密码";
    _password.text = @"peter2004";
   
   
    _password.secureTextEntry =YES;
    [_loginView addSubview:_userName];
    [_loginView addSubview:_password];
    
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame =CGRectMake(10, 210, 300, 45);
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"select_account_button"] forState:UIControlStateNormal];
    [nextBtn setTitle:@"登录" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:nextBtn];
    [self.view addSubview:_loginBtn];
    [self.view addSubview:_registerBtn];
   
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    _userName.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
     _userName.text = @"yf.it@163.com";
    
    
}

#pragma mark - BtnClick

-(void)registBtnClicked
{
    _loginBtn.frame = CGRectMake(0, 64, 160, 50);
    _registerBtn.frame = CGRectMake(160, 64, 160, 61.5);
    _registerBtn.enabled = NO;
    _loginBtn.enabled = YES;
    [self.view bringSubviewToFront:_registerView];
    [self.view bringSubviewToFront:_registerBtn];
    
}

-(void)loginBtnClicked
{
    _loginBtn.frame = CGRectMake(0, 64, 160, 61.5);
    _registerBtn.frame = CGRectMake(160, 64, 160, 50);
    _loginBtn.enabled = NO;
    _registerBtn.enabled = YES;
    [self.view bringSubviewToFront:_loginView];
    [self.view bringSubviewToFront:_loginBtn];
    
}

-(void)nextBtnClicked
{
    if (![_userName.text isEqualToString:nil]) {
        if (![_password.text isEqualToString:nil]) {
            NSLog(@"BTN Clicked");
            [self getDemoAccoutsWithUserName:_userName.text andUserPwd:_password.text];
            [[NSUserDefaults standardUserDefaults]setObject:_userName.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
}

//登录成功，页面跳转
-(void)LoginSuccess
{
    LoginSelectViewController * lsvc = [[LoginSelectViewController alloc]init];
    [self.navigationController pushViewController:lsvc animated:YES];
}

//收起键盘
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareUI];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

/**
 *@brief 获取主账号下的测试子账号
 */
-(void)getDemoAccoutsWithUserName:(NSString*)userName andUserPwd:(NSString*)userPwd
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在获取账号信息";
    hud.removeFromSuperViewOnHide = YES;
    
    NSString *requestUrl = @"https://app.cloopen.com:8883/2013-12-26/General/GetDemoAccounts";
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    [manager setResponseSerializer:[AFXMLParserResponseSerializer new]];
    
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        NSString * xmlBody = [NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF8'?><Request><user_name>%@</user_name><user_pwd>%@</user_pwd></Request>",userName,userPwd];
        return __BASE64(xmlBody);
    }];
    
    [manager POST:requestUrl parameters:@"" success:^(AFHTTPRequestOperation * operation,id responseObject){
        
       NSString * errorString = [self parseAccontsResponseString:operation.responseData];
        if (errorString) {
            ECNoTitleAlert(errorString)
        }
        else{
            [self LoginSuccess];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation * operation,NSError * error)
    {
        ECNoTitleAlert(@"请求发生错误")
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/**
 *@brief 解析获取到的账号信息内容
 *@return 解析成功返回nil，失败返回错误信息
 */
- (NSString*)parseAccontsResponseString:(NSData*)responseData{
    
    
    [[DemoGlobalClass sharedInstance].mainAccontDictionary removeAllObjects];
    
    [[DemoGlobalClass sharedInstance].appInfoDictionary  removeAllObjects];
    
    [[DemoGlobalClass sharedInstance].subAccontsArray removeAllObjects];
    
    NSArray *nameArr = [NSArray arrayWithObjects:@"张三",@"李四",@"王五",@"赵六",@"钱七", nil];
    
    GDataXMLDocument *xmldoc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:nil];
    if (!xmldoc)
    {
        return @"XML数据加载失败!";
    }
    
    GDataXMLElement *rootElement = [xmldoc rootElement];
    
    NSArray *statuscodeArray = [rootElement elementsForName:@"statusCode"];
    
    if (statuscodeArray.count > 0)
    {
        GDataXMLElement *element = (GDataXMLElement *)[statuscodeArray objectAtIndex:0];
        NSString* strStatusCode = element.stringValue;
        
        NSString* strMsg = nil;
        NSArray *statusmsgArray = [rootElement elementsForName:@"statusMsg"];
        if (statusmsgArray.count > 0)
        {
            GDataXMLElement *msgelement = (GDataXMLElement *)[statusmsgArray objectAtIndex:0];
            strMsg = msgelement.stringValue;
        }
        
        if (strStatusCode.integerValue != 0) {
            return [NSString stringWithFormat:@"错误码:%@\r错误详情:%@",strStatusCode, strMsg];
        }
    }
    else
    {
        return @"状态码没有解析到!";
    }
    
    
    //保存主账号信息
    NSMutableDictionary* AccountInfo = [DemoGlobalClass sharedInstance].mainAccontDictionary;

    
    
    //保存应用信息
    NSMutableDictionary* ApplicationDict = [DemoGlobalClass sharedInstance].appInfoDictionary;

    
    //保存子账号信息
    NSMutableArray* subAccountArray = [DemoGlobalClass sharedInstance].subAccontsArray;
    
    
    
    
    NSArray *main_accountArray = [rootElement elementsForName:@"main_account"];
    if (main_accountArray.count > 0)
    {
        GDataXMLElement *valueElement = (GDataXMLElement *)[main_accountArray objectAtIndex:0];
        [AccountInfo setObject:valueElement.stringValue forKey:@"main_account"];
    }
    
    NSArray *main_tokenArray = [rootElement elementsForName:@"main_token"];
    if (main_tokenArray.count > 0)
    {
        GDataXMLElement *valueElement = (GDataXMLElement *)[main_tokenArray objectAtIndex:0];
        [AccountInfo setObject: valueElement.stringValue forKey:@"main_token"];
    }
    
    NSArray *nickArray = [rootElement elementsForName:@"nickname"];
    if (nickArray.count > 0)
    {
        GDataXMLElement *valueElement = (GDataXMLElement *)[nickArray objectAtIndex:0];
        [AccountInfo setObject: valueElement.stringValue forKey:@"nick_name"];
    }
    
    NSArray *mobileArray = [rootElement elementsForName:@"mobile"];
    if (mobileArray.count > 0)
    {
        GDataXMLElement *valueElement = (GDataXMLElement *)[mobileArray objectAtIndex:0];
        [AccountInfo setObject: valueElement.stringValue forKey:@"mobile"];
    }
    
    NSArray *testnumberArray = [rootElement elementsForName:@"test_number"];
    if (testnumberArray.count > 0)
    {
        GDataXMLElement *valueElement = (GDataXMLElement *)[testnumberArray objectAtIndex:0];
        [AccountInfo setObject: valueElement.stringValue forKey:@"test_number"];
    }
    
    NSArray *ApplicationsArray = [rootElement elementsForName:@"Application"];
    if (ApplicationsArray.count > 0)
    {
        for (GDataXMLElement *applicationElement in ApplicationsArray)
        {
            NSArray *appIdArray = [applicationElement elementsForName:@"appId"];
            if (appIdArray.count > 0)
            {
                GDataXMLElement *valueElement = (GDataXMLElement *)[appIdArray objectAtIndex:0];
                [ApplicationDict setObject: valueElement.stringValue forKey:@"appId"];
            }
            NSArray *appNameArray = [applicationElement elementsForName:@"friendlyName"];
            if (appNameArray.count > 0)
            {
                GDataXMLElement *valueElement = (GDataXMLElement *)[appNameArray objectAtIndex:0];
                [ApplicationDict setObject: valueElement.stringValue forKey:@"appName"];
            }
            
            NSArray *SubAccountArray = [applicationElement elementsForName:@"SubAccount"];
            if (SubAccountArray.count > 0)
            {
                NSInteger i = 0;
                for (GDataXMLElement *sub_accountInfoElement in SubAccountArray)
                {
                    if (i >= 5) {
                        break;
                    }
                    NSMutableDictionary* sub_accountDict = [[NSMutableDictionary alloc] init];
                    NSArray *sub_accountArray = [sub_accountInfoElement elementsForName:@"sub_account"];
                    if (sub_accountArray.count > 0)
                    {
                        GDataXMLElement *valueElement = (GDataXMLElement *)[sub_accountArray objectAtIndex:0];
                        [sub_accountDict setObject: valueElement.stringValue forKey:subAccountKey];
                    }
                    
                    NSArray *sub_tokenArray = [sub_accountInfoElement elementsForName:@"sub_token"];
                    if (sub_tokenArray.count > 0)
                    {
                        GDataXMLElement *valueElement = (GDataXMLElement *)[sub_tokenArray objectAtIndex:0];
                        [sub_accountDict setObject: valueElement.stringValue forKey:subTokenKey];
                    }
                    
                    NSArray *voipAccountArray = [sub_accountInfoElement elementsForName:@"voip_account"];
                    if (voipAccountArray.count > 0)
                    {
                        GDataXMLElement *valueElement = (GDataXMLElement *)[voipAccountArray objectAtIndex:0];
                        [sub_accountDict setObject: valueElement.stringValue forKey:voipKey];
                        [sub_accountDict setObject:nameArr[i++] forKey:nameKey];
                        [sub_accountDict setObject:[NSString stringWithFormat:@"select_account_photo_%d",i] forKey:imageKey];
                    }
                    
                    NSArray *voip_tokenArray = [sub_accountInfoElement elementsForName:@"voip_token"];
                    if (voip_tokenArray.count > 0)
                    {
                        GDataXMLElement *valueElement = (GDataXMLElement *)[voip_tokenArray objectAtIndex:0];
                        [sub_accountDict setObject: valueElement.stringValue forKey:pwdKey];
                    }
                    
                    [subAccountArray addObject:sub_accountDict];
                }
            }
        }
    }
    return nil;
}
@end
