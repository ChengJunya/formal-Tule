//
//  SelectViewController.m
//  ECSDKDemo_OC
//
//  Created by lrn on 14/12/15.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "SelectViewController.h"
#import "SelectListViewCell.h"
#import "ChatViewController.h"
#import "CommonTools.h"
@interface SelectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong) NSDictionary *contact;
@end

@implementation SelectViewController
{
    UITableView * _inviteTableView;
    NSMutableArray * _selectedArray;
    UILabel * countLabel;
}
#pragma mark - prepareUI
-(void)prepareUI
{
    
    CGFloat hight = [[UIScreen mainScreen] bounds].size.height;
    
    _selectedArray = [NSMutableArray new];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    self.navigationItem.leftBarButtonItem =leftItem;
    
    self.title = @"选择联系人";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-184) style:UITableViewStylePlain];
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
    
    UIButton * inviteBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, hight-60-64, 160, 60)];
    [inviteBtn setBackgroundImage:[CommonTools createImageWithColor:[UIColor colorWithRed:0.02f green:0.83f blue:0.53f alpha:1.00f]] forState:UIControlStateNormal];
    [inviteBtn addTarget:self action:@selector(inviteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [inviteBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:inviteBtn];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

#pragma mark - UITableViewDateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [DemoGlobalClass sharedInstance].subAccontsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *contactlistcellid = @"InviteJoinListViewCellidentifier";
    SelectListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contactlistcellid];
    if (cell == nil) {
        cell = [[SelectListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactlistcellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectBtnClicked:)];
        [cell.contentView addGestureRecognizer:tap];
        cell.contentView.userInteractionEnabled = YES;
    }
    self.contact = [DemoGlobalClass sharedInstance].subAccontsArray[indexPath.row];
    cell.portraitImg.image = [[DemoGlobalClass sharedInstance] getOtherImageWithVoip:_contact[voipKey]];
    cell.nameLabel.text = _contact[nameKey];
    cell.numberLabel.text = _contact[voipKey];
    cell.selecImage.tag =indexPath.row+100;
    //判断selectedArray里面有没有当前这个数据
    if ([_selectedArray containsObject:[DemoGlobalClass sharedInstance].subAccontsArray[indexPath.row]]) {
         cell.selecImage.image = [UIImage imageNamed:@"select_account_list_checked"];
    }
    else{
        cell.selecImage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
    }
    return cell;
    
}

#pragma mark - BtnClick
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
    
    
    if ([_selectedArray containsObject:[DemoGlobalClass sharedInstance].subAccontsArray[indexPath.row]]) {
        selectimage.image = [UIImage imageNamed:@"select_account_list_unchecked"];

        
        [_selectedArray removeObject:[DemoGlobalClass sharedInstance].subAccontsArray[indexPath.row]];
    }
    else{
        selectimage.image = [UIImage imageNamed:@"select_account_list_checked"];

        [_selectedArray addObject:[DemoGlobalClass sharedInstance].subAccontsArray[indexPath.row]];
    }
    countLabel.text = [NSString stringWithFormat:@"一共勾选了%d个人",_selectedArray.count];
}
-(void)inviteBtnClicked
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在邀请好友";
    hud.removeFromSuperViewOnHide = YES;
    __weak __typeof(self)weakSelf = self;
    if (_selectedArray.count ==1) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary * dict = [_selectedArray objectAtIndex:0];
        ChatViewController * cvc = [[ChatViewController alloc]initWithSessionId:dict[voipKey]];
        [self.navigationController setViewControllers:[NSArray arrayWithObjects:[self.navigationController.viewControllers objectAtIndex:0],cvc, nil] animated:YES];
        
    }
    else
    {
        ECGroup * group = [[ECGroup alloc]initWithID:_dict[voipKey]];
        group.groupId = _groupId;
        group.mode =ECGroupPermMode_PrivateGroup;
        group.name =[NSString stringWithFormat:@"%@发起的群聊",[_dict objectForKey:nameKey]];
        [[ECDevice sharedInstance].messageManager createGroup:group completion:^(ECError *error, ECGroup *group) {
            
            if (error.errorCode == ECErrorType_NoError) {
                NSMutableArray * inviteArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in _selectedArray) {
                    [inviteArray addObject:[dict objectForKey:voipKey]];
                }
                [[ECDevice sharedInstance].messageManager inviteJoinGroup:group.groupId reason:@"" members:inviteArray confirm:1 completion:^(ECError *error, NSString *groupId, NSArray *members) {
                    
                    ChatViewController * cvc = [[ChatViewController alloc]initWithSessionId:group.groupId];
                    [weakSelf.navigationController setViewControllers:[NSArray arrayWithObjects:[self.navigationController.viewControllers objectAtIndex:0],cvc, nil] animated:YES];
                }];
            }
            else{
                ECNoTitleAlert(@"创建群失败");
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        
    }
}

-(void)returnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
