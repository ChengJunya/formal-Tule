//
//  InviteJoinViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/8.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "InviteJoinViewController.h"
#import "InviteJoinListViewCell.h"
#import "ChatViewController.h"
#import "CommonTools.h"

@interface InviteJoinViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong) NSDictionary *contact;

@end

@implementation InviteJoinViewController
{
    UITableView * _inviteTableView;
    NSMutableArray * _selectedArray;
    UILabel * countLabel;
    NSMutableArray * allArray;
    UIButton * inviteBtn;
}

#pragma mark - prepareUI
-(void)prepareUI
{
    CGFloat hight = [[UIScreen mainScreen] bounds].size.height;
    NSLog(@"%f",hight);
    [self judgeArrayCount];
    NSLog(@"allArray%d",allArray.count);
    _selectedArray = [NSMutableArray new];
    self.title = @"邀请加入群";
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    label.text = @"  请勾选要邀请加入群组的联系人";
    label.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    [self.view addSubview:label];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, 320, 568-184) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, hight-60-64, 160, 60)];
    countLabel.text = @"一共勾选了0个人";
    countLabel.textColor = [UIColor whiteColor];
    countLabel.backgroundColor =[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    [self.view addSubview:countLabel];
    
    inviteBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, hight-60-64, 160, 60)];
    [inviteBtn setBackgroundImage:[CommonTools createImageWithColor:[UIColor colorWithRed:0.02f green:0.83f blue:0.53f alpha:1.00f]] forState:UIControlStateNormal];
    [inviteBtn addTarget:self action:@selector(inviteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [inviteBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:inviteBtn];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    self.navigationItem.leftBarButtonItem =leftItem;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *contactlistcellid = @"InviteJoinListViewCellidentifier";
    InviteJoinListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contactlistcellid];
    if (cell == nil) {
        cell = [[InviteJoinListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactlistcellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectBtnClicked:)];
        cell.contentView.userInteractionEnabled = YES;
        [cell.contentView addGestureRecognizer:tap];
        
    }
    self.contact = allArray[indexPath.row];
    cell.portraitImg.image = [UIImage imageNamed:_contact[imageKey]];
    cell.nameLabel.text = _contact[nameKey];
    cell.numberLabel.text = _contact[voipKey];
    cell.selecImage.tag =indexPath.row+100;
    
    //判断selectedArray里面有没有当前这个数据
    if ([_selectedArray containsObject:allArray[indexPath.row]]) {
        cell.selecImage.image = [UIImage imageNamed:@"select_account_list_checked"];
    }
    else{
        cell.selecImage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
    }
    return cell;
    
}

#pragma mark - BtnClick

-(void)returnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)cellSelectBtnClicked:(UITapGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:self.tableView];
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    UIImageView * selectimage = nil;
    for (UIView * view in tap.view.subviews) {
        if (view.tag >=indexPath.row+100) {
            selectimage = (UIImageView *)view;
            break;
        }
    }
    
    if ([_selectedArray containsObject:allArray[indexPath.row]]) {
        selectimage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
        [_selectedArray removeObject:allArray[indexPath.row]];
    }
    else{
        selectimage.image = [UIImage imageNamed:@"select_account_list_checked"];
        [_selectedArray addObject:allArray[indexPath.row]];
    }
    countLabel.text = [NSString stringWithFormat:@"一共勾选了%d个人",_selectedArray.count];
    if (_selectedArray.count == 0) {
        [inviteBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    else
    {
        [inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
    }
}

-(void)inviteBtnClicked
{
    if (_selectedArray.count == 0) {
        ChatViewController * cvc = [[ChatViewController alloc]initWithSessionId:self.groupId];
        [self.navigationController setViewControllers:[NSArray arrayWithObjects:[self.navigationController.viewControllers objectAtIndex:0],cvc, nil] animated:YES];
        return;
    }
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在邀请好友";
    hud.removeFromSuperViewOnHide = YES;
    
    NSMutableArray * inviteArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dict in _selectedArray) {
        [inviteArray addObject:[dict objectForKey:voipKey]];
    }
    __weak __typeof(self)weakSelf = self;
    [[ECDevice sharedInstance].messageManager inviteJoinGroup:self.groupId reason:@"" members:inviteArray confirm:1 completion:^(ECError *error, NSString *groupId, NSArray *members) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(error.errorCode ==ECErrorType_NoError)
        {
            ChatViewController * cvc = [[ChatViewController alloc]initWithSessionId:self.groupId];
            [weakSelf.navigationController setViewControllers:[NSArray arrayWithObjects:[self.navigationController.viewControllers objectAtIndex:0],cvc, nil] animated:YES];
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

//判断可选联系人个数
-(void)judgeArrayCount
{
    allArray =[[ NSMutableArray alloc]initWithArray:[DemoGlobalClass sharedInstance].subAccontsArray];
    NSMutableArray * same = [NSMutableArray new];
    for (NSDictionary * meber in allArray) {
        for (ECGroupMember * meb in _showTableView) {
            if ([[meber objectForKey:voipKey]isEqualToString:meb.memberId]) {
                [same addObject:meber];
            }
        }
    }
    [allArray removeObjectsInArray:same];
    if (allArray.count == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"所有联系人已经在聊天列表中" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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
