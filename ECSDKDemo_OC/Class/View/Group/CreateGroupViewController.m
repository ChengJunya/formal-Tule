//
//  CreateGroupViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/8.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "InviteJoinViewController.h"
#import "CommonTools.h"
#import "GroupListViewController.h"
@interface CreateGroupViewController ()

@end

@implementation CreateGroupViewController
{
    UITextField * _groupName;
    UITextField * _groupNotice;
}
#pragma mark - prepareUI
-(void)prepareUI
{
    CGFloat hight = [[UIScreen mainScreen] bounds].size.height;
    self.title =@"建立新群组";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    self.navigationItem.leftBarButtonItem =leftItem;
    
    _groupName = [[UITextField alloc] initWithFrame:CGRectMake(30, 80, 280, 45)];
    _groupName.placeholder =@"群组名称";
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, 300, 1)];
    label1.backgroundColor =[UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
    [self.view addSubview:label1];
    _groupNotice = [[UITextField alloc]initWithFrame:CGRectMake(30, 145, 280, 45)];
    _groupNotice.placeholder =@"群公告（选填）";
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 195, 300, 1)];
    label2.backgroundColor =[UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
    [self.view addSubview:label2];
    [self.view addSubview:_groupName];
    [self.view addSubview:_groupNotice];
    
    UIButton *createGroupBtn = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 210.0f, 300.0f, 44.0f)];
    [createGroupBtn setBackgroundImage:[CommonTools createImageWithColor:[UIColor colorWithRed:0.02f green:0.83f blue:0.53f alpha:1.00f]] forState:UIControlStateNormal];
    [createGroupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createGroupBtn setTitle:@"创建" forState:UIControlStateNormal];
    [createGroupBtn addTarget:self action:@selector(createGroupBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createGroupBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - BtnClick

-(void)returnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)createGroupBtn
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在创建群组";
    hud.removeFromSuperViewOnHide = YES;
    __weak __typeof(self)weakSelf = self;
    ECGroup * group = [[ECGroup alloc]initWithID:[_dict objectForKey:@"voip_account"]];
    group.name = _groupName.text;
    group.declared = _groupNotice.text;
    group.groupId = _groupId;
    
    [[ECDevice sharedInstance].messageManager createGroup:group completion:^(ECError *error, ECGroup *group) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error.errorCode == ECErrorType_NoError) {
            InviteJoinViewController * ijvc = [[InviteJoinViewController alloc]init];
            ijvc.groupId = group.groupId;
            [weakSelf.navigationController pushViewController:ijvc animated:YES];

        }
        else{
            ECNoTitleAlert(@"创建群失败");
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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

//收起键盘
-(void)keyboardHide
{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
