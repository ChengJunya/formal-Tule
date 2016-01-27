//
//  ApplyJoinGroupViewController.m
//  ECSDKDemo_OC
//
//  Created by lrn on 14/12/10.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "ApplyJoinGroupViewController.h"
#import "GroupListViewController.h"
#import "ChatViewController.h"
#import "CommonTools.h"

@interface ApplyJoinGroupViewController ()
@property(nonatomic,strong)ECGroup *group;
@end

@implementation ApplyJoinGroupViewController
{
    UILabel * tellLabel;
    UILabel * groupLabel;
    UILabel * groupOwner;
    UILabel * groupName;
    UILabel * groupNum;
    
}

#pragma mark - prepareUI

-(void)prepareUI
{
    
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, 320, 50)];
    label1.backgroundColor =[UIColor colorWithRed:0.97f green:0.96f blue:0.97f alpha:1.00f];
    label1.text = @"  群简介";
    [self.view addSubview:label1];
    
    groupName = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+60, 320, 40)];
    groupName.font = [UIFont systemFontOfSize:18];
    groupName.textColor =[UIColor colorWithRed:0.39f green:0.39f blue:0.39f alpha:1.00f];
    [self.view addSubview:groupName];
    
    
    groupOwner = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+100, 320, 40)];
    groupOwner.font = [UIFont systemFontOfSize:18];
    groupOwner.textColor =[UIColor colorWithRed:0.39f green:0.39f blue:0.39f alpha:1.00f];
    [self.view addSubview:groupOwner];
    
    groupLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+140, 320, 40)];
    groupLabel.font = [UIFont systemFontOfSize:18];
    groupLabel.textColor =[UIColor colorWithRed:0.39f green:0.39f blue:0.39f alpha:1.00f];
    [self.view addSubview:groupLabel];

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+190, 320, 50)];
    label.backgroundColor =[UIColor colorWithRed:0.97f green:0.96f blue:0.97f alpha:1.00f];
    label.text = @"  群公告";
    [self.view addSubview:label];
    
    tellLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+210+50, 320, 80)];
    tellLabel.numberOfLines =2;
    tellLabel.font = [UIFont systemFontOfSize:18];
    tellLabel.textColor =[UIColor colorWithRed:0.39f green:0.39f blue:0.39f alpha:1.00f];
    [self.view addSubview:tellLabel];
    
    
    
    
    UIButton * joinBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 260+160, 300, 50)];
    [joinBtn setTitle:@"申请加入" forState:UIControlStateNormal];
    [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinBtn setBackgroundImage:[CommonTools createImageWithColor:[UIColor colorWithRed:0.02f green:0.83f blue:0.53f alpha:1.00f]] forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(joinBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:joinBtn];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    self.navigationItem.leftBarButtonItem =leftItem;
}

#pragma mark - BtnClick
-(void)joinBtnClicked
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在申请加入";
    hud.removeFromSuperViewOnHide = YES;
    __weak __typeof(self)weakSelf = self;
     [[ECDevice sharedInstance].messageManager joinGroup:self.group.groupId reason:@"" completion:^(ECError *error, NSString *groupId) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (error.errorCode == ECErrorType_NoError) {
             
             ChatViewController * chatView = [[ChatViewController alloc] initWithSessionId:self.group.groupId];
             [weakSelf.navigationController pushViewController:chatView animated:YES];
         }
         else
         {
             [weakSelf showToast:[NSString stringWithFormat:@"errorCode:%d\rerrorDescription:%@",error.errorCode,error.errorDescription]];
         }
        
     }];
    
}
//Toast错误信息
-(void)showToast:(NSString *)message
{
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareUI];
    __weak __typeof(self)weakSelf = self;
    [[ECDevice sharedInstance].messageManager getGroupDetail:self.ApplygroupId completion:^(ECError *error, ECGroup *group) {
        if (group.declared.length == 0||[group.declared isEqualToString:nil]) {
            tellLabel.text = @"  该群组无公告";
        }
        else
            
        {
            tellLabel.text = [NSString stringWithFormat:@"  %@",group.declared];
        }
            groupLabel.text =[NSString stringWithFormat:@"  群ID:%@",group.groupId]; ;
        
            groupOwner.text =[NSString stringWithFormat:@"  群主:%@",group.owner];
            
            groupName.text = [NSString stringWithFormat:@"  群名字:%@",group.name];
        
            weakSelf.title =group.name;
            weakSelf.group = group;
            weakSelf.group.owner =group.owner;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
