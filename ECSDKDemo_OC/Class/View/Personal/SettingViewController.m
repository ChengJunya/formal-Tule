//
//  SettingViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "SettingViewController.h"
#import "DemoGlobalClass.h"
#import "CommonTools.h"

@interface SettingViewController()<UIAlertViewDelegate>

@end

@implementation SettingViewController
#pragma mark - prepareUI
-(void)prepareUI
{
    UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 120)];
    bgImageView.image = [UIImage imageNamed:@"personal_center_bg"];
    [self.view addSubview:bgImageView];
    
    UIImageView * headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 70, 70)];
    [headImageView setImage: [UIImage imageNamed:[DemoGlobalClass sharedInstance].loginInfoDic[imageKey]]];
    [bgImageView addSubview:headImageView];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 35, 150, 30)];
    nameLabel.text = [_dict objectForKey:nameKey];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:20];
    [bgImageView addSubview:nameLabel];
    
    UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 55, 150, 30)];
    numLabel.text = [_dict objectForKey:voipKey];
    numLabel.textColor = [UIColor whiteColor];
    [bgImageView addSubview:numLabel];
    
    for (int  i =0; i<2; i++) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 52*i+184, 320, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 40)];
        label.tag = i+1;
        label.textColor = [UIColor blackColor];
        [view addSubview:label];
        
        UISwitch * switchs = [[UISwitch alloc]initWithFrame:CGRectMake(250, 10, 50, 40)];
        switchs.tag =i+5;
        
        NSNumber * number = nil;
        if (switchs.tag == 5) {
            number = [[NSUserDefaults standardUserDefaults] objectForKey:@"message_sound"];
        }else{
            number = [[NSUserDefaults standardUserDefaults] objectForKey:@"message_shake"];
        }
        
        [switchs setOn:number==nil?YES:number.boolValue];
        [switchs addTarget:self action:@selector(switchsChanged:) forControlEvents:UIControlEventValueChanged];
        [view addSubview:switchs];
    }
    
    UILabel * label1 = (UILabel *)[self.view viewWithTag:1];
    label1.text =@"新消息声音";
    UILabel * label2 = (UILabel *)[self.view viewWithTag:2];
    label2.text =@"新消息震动";
    
    UIButton * excOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [excOrderBtn setBackgroundImage:[CommonTools createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    excOrderBtn.frame =CGRectMake(0, 320, 320, 50);
    [excOrderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [excOrderBtn setTitle:@"退出客户端" forState:UIControlStateNormal];
    [excOrderBtn addTarget:self action:@selector(excOrderBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:excOrderBtn];
    
    UIButton * excNowNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    excNowNumBtn.frame =CGRectMake(0, 372, 320, 50);
    [excNowNumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [excNowNumBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [excNowNumBtn setBackgroundImage:[CommonTools createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [excNowNumBtn addTarget:self action:@selector(excNowNumBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:excNowNumBtn];

    self.title =@"设置";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    self.navigationItem.leftBarButtonItem =leftItem;
}
#pragma mark - BtnClick

-(void)returnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)switchsChanged:(UISwitch *)switches
{
    if (switches.tag == 5)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(switches.isOn) forKey:@"message_sound"];
    }
    else if (switches.tag == 6)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(switches.isOn) forKey:@"message_shake"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//退出客户端
-(void)excOrderBtnClicked
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出" message:@"确认要退出客户端吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}
//退出当前账号
-(void)excNowNumBtnClicked
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注销" message:@"确认要退出当前账号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 101;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == 100) {
            exit(0);
        }else if (alertView.tag == 101){
            MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hub.removeFromSuperViewOnHide = YES;
            hub.labelText = @"正在注销...";
            [[ECDevice sharedInstance] logout:^(ECError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:UserDefault_Connacts];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:UserDefault_LoginUser];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:[ECError errorWithCode:ECErrorType_KickedOff]];
            }];
        }
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.99f alpha:1.00f];
    [self prepareUI];
    
}

@end
