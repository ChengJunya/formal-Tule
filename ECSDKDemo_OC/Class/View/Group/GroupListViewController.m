//
//  GroupListViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "GroupListViewController.h"
#import "GroupListViewCell.h"
#import "ApplyJoinGroupViewController.h"
#import "DetailsViewController.h"
#import "ChatViewController.h" 
#import "CreateGroupViewController.h"

extern CGFloat NavAndBarHeight;

@interface GroupListViewController(){
    CGFloat yOffSet;
}
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray * groupArray;
@property(nonatomic, strong)NSArray * joinArray;
@property(nonatomic, strong)NSMutableArray * showcellArray;

@property (nonatomic, strong) UIView *menuView;


@end

@implementation GroupListViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"群";
    yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, yOffSet,self.view.frame.size.width,self.view.frame.size.height-yOffSet) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    self.navView.actionBtns = @[[self addPublishActionBtn]];
    [self prepareGroupDisplay];
}

- (UIButton*)addPublishActionBtn
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setTitleColor:COLOR_NAV_TEXT forState:UIControlStateNormal];
    [actionBtn setTitleColor:COLOR_BTN_BOX_GRAY_TEXT forState:UIControlStateHighlighted];
    [actionBtn setTitle:@"+创建" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = FONT_14B;
    //[actionBtn setImage:[UIImage imageNamed:@"more_xiaoxi"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(publishBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

-(void)publishBtnHandler{
    
    
    NSLog(@"创建群组");
    CreateGroupViewController * cgvc = [[CreateGroupViewController alloc]init];
    [self.navigationController pushViewController:cgvc animated:YES];
    cgvc.dict = [DemoGlobalClass sharedInstance].loginInfoDic;
    
    
//    if (self.menuView == nil) {
//        
//        self.menuView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.menuView action:@selector(removeFromSuperview)];
//        [self.menuView addGestureRecognizer:tap];
//        
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(160, 64.0f, 150, 120)];
//        view.tag =50;
//        view.backgroundColor = [UIColor blackColor];
//        [self.menuView addSubview:view];
//        UIButton * converseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        converseBtn.frame =CGRectMake(0, 0, 150, 40);
//        [converseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [converseBtn setTitle:@"发起会话/群聊" forState:UIControlStateNormal];
//        [converseBtn addTarget:self action:@selector(converseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:converseBtn];
//        UIButton * createmoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        createmoreBtn.frame =CGRectMake(0, 40, 150, 40);
//        [createmoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [createmoreBtn setTitle:@"创建群组" forState:UIControlStateNormal];
//        [createmoreBtn addTarget:self action:@selector(createmoreBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:createmoreBtn];
//        UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        setBtn.frame =CGRectMake(0, 80, 150, 40);
//        [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [setBtn setTitle:@"设置" forState:UIControlStateNormal];
//        [setBtn addTarget:self action:@selector(setBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:setBtn];
//    }
//    
//    if (self.menuView.superview == nil) {
//        [self.view.window addSubview:self.menuView];
//    }
    
}
-(void)converseBtnClicked{
    
}
-(void)createmoreBtnClicked{
    NSLog(@"创建群组");
    CreateGroupViewController * cgvc = [[CreateGroupViewController alloc]init];
    [self.navigationController pushViewController:cgvc animated:YES];
    cgvc.dict = [DemoGlobalClass sharedInstance].loginInfoDic;


}
-(void)setBtnClicked{
    
}

#pragma mark - prepareGroupDisplay
-(void)prepareGroupDisplay
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval tmp =[date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%lld", (long long)tmp];
    __weak __typeof(self)weakSelf = self;
    [[ECDevice sharedInstance].messageManager getAllPublicGroups:timeString completion:^(ECError *error, NSString *updateTime, NSArray *groups) {
        if (error.errorCode == ECErrorType_NoError) {
            weakSelf.groupArray = [NSArray arrayWithArray:groups];
            [weakSelf judgeSuccess];
            [weakSelf.tableView reloadData];
            [[DeviceDBHelper sharedInstance].msgDBAccess addGroupIDs:groups];
        }
        else
        {
            [weakSelf showToast:[NSString stringWithFormat:@"errorCode:%d\rerrorDescription:%@",error.errorCode,error.errorDescription]];
        }
        
    }];
    
    [[ECDevice sharedInstance].messageManager queryOwnGroups:^(ECError *error, NSArray *groups) {
        if (error.errorCode == ECErrorType_NoError) {
            NSLog(@"groups%@",groups);
            weakSelf.joinArray = [NSArray arrayWithArray:groups];
            [weakSelf judgeSuccess];
            [weakSelf.tableView reloadData];
            [[DeviceDBHelper sharedInstance].msgDBAccess addGroupIDs:groups];
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
    hud.detailsLabelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
    
}
-(void)judgeSuccess
{
    //从总的群列表中删除自己已加入的数组，得到tableview显示顺序
    if (self.groupArray&&self.joinArray) {
        NSMutableArray * _deleteArray = [NSMutableArray arrayWithArray:self.groupArray];
        NSMutableArray * sameArray = [[NSMutableArray alloc]init];
        for (ECGroup * big in _deleteArray) {
            for (ECGroup * small in self.joinArray) {
                if ([big.groupId isEqualToString:small.groupId]) {
                    [sameArray addObject:big];
                }
            }
        }
        [_deleteArray removeObjectsInArray:sameArray];
        self.showcellArray = [NSMutableArray arrayWithArray:_joinArray];
        [_showcellArray addObjectsFromArray:_deleteArray];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ECGroup* group = [_showcellArray objectAtIndex:indexPath.row];
    if(indexPath.row >= _joinArray.count)
    {
        //ApplyJoinGroupViewController * ajgvc = [[ApplyJoinGroupViewController alloc]init];
        [self pushViewControllerWithName:@"ApplyJoinGroupViewController" block:^(id obj) {
            ApplyJoinGroupViewController * ajgvc = obj;
            ajgvc.ApplygroupId =group.groupId;
            
        }];
//        [self pushViewController:ajgvc animated:YES];
//        ajgvc.ApplygroupId =group.groupId;
    }
    else
    {
        //ChatViewController * chatView = [[ChatViewController alloc] initWithSessionId:group.groupId];
        
//        NSLog(@"group%@",group.name);
//        [self.mainView pushViewController:chatView animated:YES];
//        chatView.title =group.name;
        
        [self pushViewControllerWithName:@"TLGroupDetailViewController"  block:^(id obj) {
            
        }];

        
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _showcellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupListViewCellid = @"GroupListViewCellidentifier";
    GroupListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupListViewCellid];
    if (cell == nil) {
        cell = [[GroupListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupListViewCellid];
    }

    ECGroup *group = [_showcellArray objectAtIndex:indexPath.row];    
    [cell setTableViewCellNameLabel:group.name andNumberLabel:group.groupId andIsJoin:indexPath.row < _joinArray.count];
    
    return cell;
}

@end
