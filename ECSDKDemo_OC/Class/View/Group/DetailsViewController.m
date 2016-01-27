//
//  DetailsViewController.m
//  ECSDKDemo_OC
//
//  Created by lrn on 14/12/12.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "DetailsViewController.h"
#import "InviteJoinViewController.h"
#import "DetailsListViewCell.h"
#import "CommonTools.h"

@interface DetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property(nonatomic,strong)NSMutableArray * tableViewArray;
@property(nonatomic,strong)ECGroup *group;
@end

@implementation DetailsViewController
{
    UILabel * tellLabel;
    UITableView * _tableView;
    UITextView * _groupTell;
    UIBarButtonItem * rightItem;
}

#pragma mark - prepareUI
-(void)prepareUI
{
    _isOwner =NO;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    [self.view addGestureRecognizer:tap];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishBtnClicked)];
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
     self.navigationItem.rightBarButtonItem =rightItem;
    
    
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

-(void)judgeSuccess
{
    if (self.group&&self.tableViewArray) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_tableView reloadData];
    }
}

//收起键盘
-(void)keyboardHide
{
    [self.view endEditing:YES];
}

#pragma mark - BtnClick

-(void)finishBtnClicked
{
    if (self.group.declared.length>0 && [_groupTell.text isEqualToString: self.group.declared]) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"内容未做修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    __weak __typeof(self)weakSelf = self;
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在保存修改";
    hud.removeFromSuperViewOnHide = YES;
    [self.view endEditing:YES];
    self.group.declared = _groupTell.text;
    NSLog(@"_groupTell.text%@",_groupTell.text);
    [[ECDevice sharedInstance].messageManager modifyGroup:self.group completion:^(ECError *error, ECGroup *group) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error.errorCode == ECErrorType_NoError) {
            NSLog(@"self.group.declared%@",self.group.declared);
            NSLog(@"self.name%@",self.group.name);
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [weakSelf showToast:[NSString stringWithFormat:@"errorCode:%d\rerrorDescription:%@",error.errorCode,error.errorDescription]];
        }
    }];
}

-(void)addBtnClicked
{
    InviteJoinViewController * ijvc = [[InviteJoinViewController alloc]init];
    ijvc.groupId =self.groupId;
    ijvc.showTableView = self.tableViewArray;
    [self.navigationController pushViewController:ijvc animated:YES];
}

-(void)returnClicked
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)removeBtnClicked:(UIButton *)sender
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在踢出";
    hud.removeFromSuperViewOnHide = YES;
    
    DetailsListViewCell * cell = (DetailsListViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:1]];
    NSLog(@"cell.memberId%@",cell.memberId);

    [[ECDevice sharedInstance].messageManager deleteGroupMembers:self.groupId members:[NSArray arrayWithObject:cell.memberId] completion:^(ECError *error, NSString *groupId, NSArray *members) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error.errorCode ==ECErrorType_NoError) {
            for (ECGroupMember * member in _tableViewArray) {
                if ([member.memberId isEqualToString:cell.memberId]) {
                    [_tableViewArray removeObject:member];
                    break;
                }
            }
            [_tableView reloadData];
            
        }
        else
        {
            [self showToast:[NSString stringWithFormat:@"errorCode:%d\rerrorDescription:%@",error.errorCode,error.errorDescription]];
        }
    }];
}

//清除聊天记录
-(void)clearTalkBtnClicked:(UIButton *)btn
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在清除聊天内容";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DeviceDBHelper sharedInstance] deleteAllMessageOfSession:self.groupId];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES afterDelay:1];
        });
    });
}

-(void)exitBtnClicked
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    
    __weak typeof(self) weakSelf = self;
    if (_isOwner) {
        hud.labelText = @"正在解散群";
        [[ECDevice sharedInstance].messageManager deleteGroup:self.groupId completion:^(ECError *error, NSString *groupId) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error.errorCode == ECErrorType_NoError) {
                [[DeviceDBHelper sharedInstance] deleteAllMessageOfSession:weakSelf.groupId];
                [[DeviceDBHelper sharedInstance] deleteAllMessageOfSession:self.groupId];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                [self showToast:[NSString stringWithFormat:@"errorCode:%d\rerrorDescription:%@",error.errorCode,error.errorDescription]];
            }
        }];
    }
    else
    {
        hud.labelText = @"正在退出群聊";
        [[ECDevice sharedInstance].messageManager quitGroup:self.groupId completion:^(ECError *error, NSString *groupId) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error.errorCode == ECErrorType_NoError) {
                [[DeviceDBHelper sharedInstance] deleteAllMessageOfSession:weakSelf.groupId];
                [[DeviceDBHelper sharedInstance] deleteAllMessageOfSession:self.groupId];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                [self showToast:[NSString stringWithFormat:@"errorCode:%d\rerrorDescription:%@",error.errorCode,error.errorDescription]];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = self.groupId;
    
    [self prepareUI];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在获取群组详情";
    hud.removeFromSuperViewOnHide = YES;
    __weak __typeof(self) weakSelf = self;
    [[ECDevice sharedInstance].messageManager getGroupDetail:self.groupId completion:^(ECError *error, ECGroup *group) {
        
        if (error.errorCode == ECErrorType_NoError) {
            NSLog(@"group.declared%@",group.declared);
            weakSelf.group = group;
            weakSelf.title = group.name;
            
            if ([group.owner isEqualToString:[DemoGlobalClass sharedInstance].loginInfoDic[voipKey]]) {
                _isOwner =YES;
            }
            [self judgeSuccess];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showToast:[NSString stringWithFormat:@"errorCode:%d\rerrorDescription:%@",error.errorCode,error.errorDescription]];
        }
    }];

    [[ECDevice sharedInstance].messageManager queryGroupMembers:self.groupId completion:^(ECError *error, NSArray *members) {
        if (error.errorCode == ECErrorType_NoError) {
            self.tableViewArray = [[NSMutableArray alloc]initWithArray:members];
            NSLog(@"_tableViewArray%@",_tableViewArray);
            [self judgeSuccess];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showToast:[NSString stringWithFormat:@"errorCode:%d\rerrorDescription:%@",error.errorCode,error.errorDescription]];
        }
        
    }];
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    if (section==0) {
       
        view.frame = CGRectMake(0, 64, 320, 130);
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        label.backgroundColor =[UIColor colorWithRed:0.97f green:0.96f blue:0.97f alpha:1.00f];
        label.text = @"群公告";
        [view addSubview:label];
        _groupTell = [[UITextView alloc]initWithFrame:CGRectMake(0, 50, 320, 100)];
        _groupTell.delegate =self;
        _groupTell.backgroundColor = [UIColor whiteColor];
        _groupTell.font = [UIFont systemFontOfSize:14];
        [view addSubview:_groupTell];

        tellLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 200, 30)];
        tellLabel.text =@"该群组无公告";
        tellLabel.hidden = YES;
        tellLabel.font = [UIFont systemFontOfSize:14];
        tellLabel.textColor =[UIColor colorWithRed:0.39f green:0.39f blue:0.39f alpha:1.00f];
        [_groupTell addSubview:tellLabel];
        _groupTell.editable = _isOwner;
        self.navigationItem.rightBarButtonItem = _isOwner?rightItem:nil;
        if (_group.declared.length == 0 && self.group) {
            tellLabel.hidden = NO;
        }
        else
        {
            _groupTell.text = _group.declared;
        }
    }
    
    if (section ==1) {
        view.frame = CGRectMake(0, 64, 320, 50);
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        label1.backgroundColor =[UIColor colorWithRed:0.97f green:0.96f blue:0.97f alpha:1.00f];
        label1.text = @"群成员";
        [view addSubview:label1];
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 130;
    }
    if (section == 1) {
        return 50;
    }
    else
        return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==2) {
        return 50;
    }
    return 65.0f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else if (section ==1) {
        
        NSInteger count = _tableViewArray.count+(_isOwner?1:0);
        return count;
    }
    else {
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return nil;
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row<_tableViewArray.count)
        {
            static NSString *detailistcellid = @"DetailsViewController";
            DetailsListViewCell *cell =[tableView dequeueReusableCellWithIdentifier:detailistcellid];
            if (cell == nil) {
                cell = [[DetailsListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailistcellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.removeBtn addTarget:self action:@selector(removeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            cell.removeBtn.hidden =!_isOwner;
            ECGroupMember * member = (ECGroupMember *)[_tableViewArray objectAtIndex:indexPath.row];;
            cell.memberId =member.memberId;
            cell.removeBtn.tag = indexPath.row;
            
            if ([[DemoGlobalClass sharedInstance].loginInfoDic[voipKey] isEqualToString:cell.memberId]) {
                
                cell.removeBtn.hidden =YES;
                cell.headImage.image = [UIImage imageNamed:[DemoGlobalClass sharedInstance].loginInfoDic[imageKey]];
                cell.nameLabel.text = [DemoGlobalClass sharedInstance].loginInfoDic[nameKey];
            }
            else{
                
                cell.nameLabel.text = [[DemoGlobalClass sharedInstance] getOtherNameWithVoip:member.memberId];
                cell.headImage.image = [[DemoGlobalClass sharedInstance] getOtherImageWithVoip:member.memberId];
            }
            return cell;
        }
        else
        {
            static NSString *detailistcellid = @"DetailsViewControllerinvite";
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:detailistcellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailistcellid];
                
                UIButton* addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0, cell.frame.size.width, 65.0f)];
                [addBtn setBackgroundImage:[CommonTools createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                [cell.contentView addSubview:addBtn];
                [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                UILabel* addlabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 17.5, 230, 30)];
                addlabel.text =@"邀请成员加入";
                [addBtn addSubview:addlabel];
                UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, 10.0f, 45.0f, 45.0f)];
                imageview.image = [UIImage imageNamed:@"add_contact"];
                [addBtn addSubview:imageview];
            }
            return cell;
        }
    }
    else
    {
        static NSString *detailistcellid = @"clearCell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:detailistcellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailistcellid];
            
            UIButton * clearTalkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [clearTalkBtn setBackgroundImage:[CommonTools createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            clearTalkBtn.tag = 1000;
            clearTalkBtn.frame =CGRectMake(0, 0, 320, 50);
            [clearTalkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:clearTalkBtn];
        }
        
        UIButton * button = (UIButton*)[cell.contentView viewWithTag:1000];
        if (indexPath.row == 0) {
            [button addTarget:self action:@selector(clearTalkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"清空聊天记录" forState:UIControlStateNormal];
        }
        else{
            [button addTarget:self action:@selector(exitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:(_isOwner?@"解散该群组":@"退出群聊") forState:UIControlStateNormal];
        }
        
        return cell;
    }
    return nil;

}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        
        tellLabel.hidden = NO;
    }
    else
        tellLabel.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
