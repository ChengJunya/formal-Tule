//
//  LoginSelectViewController.m
//  ECSDKDemo_OC
//
//  Created by lrn on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "LoginSelectViewController.h"
#import "CommonTools.h"
#import "SettingViewController.h"
#import "ApplyJoinGroupViewController.h"
#define BUTTON_SUNACCOUNT_BASE_TAG 100
@interface LoginSelectViewController ()

@end

@implementation LoginSelectViewController
{
    UIButton * _loginBtn;
    CGFloat  account_frame_begin_y;
    NSArray * _accountArr;
    UIScrollView * _btnScrollView;
    NSInteger _curIndex;
   
}
#pragma mark - prepareUI
-(void)prepareUI
{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.view = scrollView;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 568- 64);
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 32)];
    statusLabel.font = [UIFont boldSystemFontOfSize:14];
    statusLabel.text = @" 已成功登录，请选择一个子账户开始体验";
    statusLabel.textColor = [UIColor whiteColor];
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:statusLabel];
    self.navigationItem.leftBarButtonItem = titleItem;
    
    UIImage * image = [UIImage imageNamed:@"select_account_prompt"];
    UIImageView * bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, image.size.height)];
    bgImage.image =image;
    [self.view addSubview:bgImage];
    
    UIImage * prompt = [UIImage imageNamed:@"select_account_prompt_font"];
    UIImageView * promptImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 15, prompt.size.width, prompt.size.height)];
    promptImage.image = prompt;
    [bgImage addSubview:promptImage];
    UIImage * circle = [UIImage imageNamed:@"select_account_label"];
    
    for (int i =0; i<2; i++) {
        UIImageView * circleImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 42+25*i, circle.size.width, circle.size.height)];
        circleImage.image =circle;
        [bgImage addSubview:circleImage];
    }
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 35.0f, 266.0f, 34.0f)];
    infoLabel.font = [UIFont systemFontOfSize:14.0f];
    infoLabel.numberOfLines = 0;
    infoLabel.text = @"子账号类似手机号,用于区分用户或设备";
    infoLabel.textColor = [UIColor whiteColor];
    [bgImage addSubview:infoLabel];
    
    UILabel *infoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 60.0f, 266.0f, 34.0f)];
    infoLabel1.font = [UIFont systemFontOfSize:14.0f];
    infoLabel1.numberOfLines = 0;
    infoLabel1.text = @"部分功能需在2-3台设备登录不同子账号";
    infoLabel1.textColor = [UIColor whiteColor];
    [bgImage addSubview:infoLabel1];
    
    UILabel* accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(11.0f, bgImage.frame.origin.y+bgImage.frame.size.height+17.0f, 100.0f, 17.0f)];
    accountLabel.font = [UIFont systemFontOfSize:15.0f];
    accountLabel.text = @"子账户列表：";
    [self.view addSubview:accountLabel];
    
    account_frame_begin_y = accountLabel.frame.origin.y+accountLabel.frame.size.height+11.0f;
    
    UIView * selectView = [[UIView alloc]initWithFrame:CGRectMake(0, scrollView.contentSize.height-45, 320, 45)];
    selectView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"select_account_tab"]];
    [self.view addSubview:selectView];
    UILabel * selectlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200,45)];
    selectlabel.backgroundColor = [UIColor clearColor];
    selectlabel.text = @"  还未选择子帐号,请点选";
    selectlabel.font = [UIFont boldSystemFontOfSize:15];
    selectlabel.textColor = [UIColor whiteColor];
    [selectView addSubview:selectlabel];
    
    UIButton *logoButton = [[UIButton alloc] initWithFrame:CGRectMake(320-120, 8, 115, 30.0f)];
    _loginBtn = logoButton;
    [logoButton setBackgroundImage:[UIImage imageNamed:@"select_account_button"] forState:UIControlStateNormal];
    [logoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoButton setTitle:@"开始体验" forState:UIControlStateNormal];
    [logoButton addTarget:self action:@selector(logoBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:logoButton];
    
    [self createAccountList];
}

-(void)logoBtnTouch:(id)sender
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (_curIndex >= BUTTON_SUNACCOUNT_BASE_TAG)
    {
        hud.labelText = @"正在登录";
        hud.removeFromSuperViewOnHide = YES;
        NSDictionary* accountInfo = @{@"image_key":@"select_account_photo_2",
                                      @"sub_account":@"8a48b5514b35422d014b454262270676",
                                      @"sub_token":@"d14cefa28cb9463dbc9cd88fc9111304",
                                      @"voip_account":@"84759900000002",
                                      @"voip_name":@"张三",
                                      @"voip_token":@"ddv1cx5i"};//[DemoGlobalClass sharedInstance].subAccontsArray[_curIndex-BUTTON_SUNACCOUNT_BASE_TAG];
        
        
        
        
        ECLoginInfo *loginInfo = [[ECLoginInfo alloc] initWithAccount:accountInfo[voipKey] Password:accountInfo[pwdKey]];
        
        loginInfo.subAccount = accountInfo[subAccountKey];
        loginInfo.subToken = accountInfo[subTokenKey];
        [[DeviceDBHelper sharedInstance] openDataBasePath:accountInfo[voipKey]];
        
        [[ECDevice sharedInstance] login:loginInfo completion:^(ECError *error) {
            if (error.errorCode == ECErrorType_NoError) {
                [DemoGlobalClass sharedInstance].loginInfoDic = accountInfo;
                [[DemoGlobalClass sharedInstance].subAccontsArray removeObjectAtIndex:_curIndex-BUTTON_SUNACCOUNT_BASE_TAG];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:[DemoGlobalClass sharedInstance].subAccontsArray] forKey:UserDefault_Connacts];
                [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:[DemoGlobalClass sharedInstance].loginInfoDic] forKey:UserDefault_LoginUser];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
            }
            else{
                ECNoTitleAlert(@"登录失败")
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
    else{
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请选择一个账号登录";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
}

- (void)createAccountList
{
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, account_frame_begin_y, 320.0f, 275 )];
    _btnScrollView = scrollview;
    scrollview.backgroundColor =[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    [self.view addSubview:scrollview];
    CGFloat btn_frame_y = 0.0f;
    _accountArr = [DemoGlobalClass sharedInstance].subAccontsArray;
    for (NSUInteger i=0; i<_accountArr.count; i++)
    {
        UIButton *accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        accountBtn.frame = CGRectMake(0.0f, btn_frame_y, 320.0f, 54.0f);
        accountBtn.backgroundColor = [UIColor whiteColor];
        [accountBtn addTarget:self action:@selector(accountBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        NSDictionary* accountInfo = [_accountArr objectAtIndex:i];
        
        UIImageView * headImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 6, 42, 42)];
        headImage.image = [UIImage imageNamed:accountInfo[imageKey]];
        [accountBtn addSubview:headImage];
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 6, 200, 25)];
        nameLabel.textColor = [UIColor colorWithRed:0.38f green:0.38f blue:0.38f alpha:1.00f];
        nameLabel.text = accountInfo[nameKey];
        [accountBtn addSubview:nameLabel];
        
        UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 26, 200, 25)];
        numberLabel.textColor =[UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
        numberLabel.text =accountInfo[voipKey];
        [accountBtn addSubview:numberLabel];
        
        accountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        UIEdgeInsets insets = accountBtn.contentEdgeInsets;
        insets.left += 6.0f;
        accountBtn.contentEdgeInsets = insets;
        accountBtn.tag = BUTTON_SUNACCOUNT_BASE_TAG+i;
        
        UIImageView *markImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_account_list_unchecked"]];
        markImg.tag = 50;
        markImg.center = CGPointMake(288.0f, 28.0f);
        [accountBtn addSubview:markImg];
        
        [scrollview addSubview:accountBtn];
        
        btn_frame_y += 55.0f;
    }
    scrollview.contentSize = CGSizeMake(0, 0);
}

- (void)accountBtnTouch:(id)sender
{
    for (UIView *view in _btnScrollView.subviews)
    {
        if (view.tag >= BUTTON_SUNACCOUNT_BASE_TAG)
        {
            UIImageView *markImg = (UIImageView *)[view viewWithTag:50];
            markImg.image = [UIImage imageNamed:@"select_account_list_unchecked"];
        }
    }
    
    UIButton *btn = (UIButton*)sender;
    UIImageView *markImg = (UIImageView *)[btn viewWithTag:50];
    markImg.image = [UIImage imageNamed:@"select_account_list_checked"];
    _curIndex = btn.tag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    
    //改变导航栏背景颜色
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    [self prepareUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
