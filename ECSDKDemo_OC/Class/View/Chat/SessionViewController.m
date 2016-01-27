//
//  SessionViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "SessionViewController.h"
#import "SessionViewCell.h"
#import "ChatViewController.h"
#import "ECSession.h"
#import "GroupNoticeViewController.h"
#import "TLHelper.h"
#import "TLOrgInfoViewController.h"
#import "TLOrgDataDTO.h"
#import "TLMyFriendListRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "TLSimpleUserDTO.h"
#import "TLUserViewResultDTO.h"
extern CGFloat NavAndBarHeight;
@interface SessionViewController()

@property (nonatomic, strong) NSMutableArray *sessionArray;
@property (nonatomic, strong) ECGroupNoticeMessage *message;
@property (nonatomic, strong) UIView * linkview;

@end

@implementation SessionViewController
{
    UITableViewCell * _memoryCell;
    LinkJudge linkjudge;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"消息";
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        self.edgesForExtendedLayout =  UIRectEdgeNone;
//    }
    [self getFriedsData];
    
}

#pragma mark-
#pragma mark-获取好友信息
-(void)getFriedsData{
    WEAK_SELF(self);
    TLMyFriendListRequestDTO *request = [[TLMyFriendListRequestDTO alloc] init];
    request.type = @"1";
    request.phoneArray = @"";
    request.searchText = @"";
    [GTLModuleDataHelper myFriendList:request requestArr:[NSMutableArray array] block:^(id obj, BOOL ret) {
        
        if (ret) {
            //保存子账号信息
            NSMutableArray* subAccountArray = [DemoGlobalClass sharedInstance].subAccontsArray;
            NSArray *friends = obj;
            [friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                TLSimpleUserDTO *dto = obj;
                NSDictionary *friend = [dto toDictionary];
                [subAccountArray addObject:friend];
            }];

            [weakSelf initViews];
            
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
            [weakSelf initViews];
        }
    }];

}

-(void)initViews{
    self.view.backgroundColor = COLOR_DEF_BG;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT,self.view.frame.size.width,self.view.frame.size.height-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT-TABBAR_HEIGHT) style:UITableViewStylePlain];
    //self.tableView.tableFooterView = [[UIView alloc] init];
    //self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.sessionArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareDisplay) name:KNOTIFICATION_onMesssageChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareDisplay) name:KNOTIFICATION_onReceivedGroupNotice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareDisplay) name:@"mainviewdidappear" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkSuccess:) name:KNOTIFICATION_onConnected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:KNotice_GetGroupName object:nil];
    
    [self prepareDisplay];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = YES;
    self.listBtnHidden = NO;
    
    [self prepareDisplay];

    
}


-(void)updateLoginStates:(LinkJudge)link
{
    if (link == success) {
        _tableView.tableHeaderView = nil;
        [_linkview removeFromSuperview];
    }
    else
    {
        [_linkview removeFromSuperview];
        _linkview = nil;
        
        _linkview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
        _linkview.backgroundColor = [UIColor colorWithRed:1.00f green:0.87f blue:0.87f alpha:1.00f];
       if (link==failed) {
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 30, 30)];
            image.image = [UIImage imageNamed:@"messageSendFailed"];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 320-50 , 45)];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor =[UIColor colorWithRed:0.46f green:0.40f blue:0.40f alpha:1.00f];
            label.text = @"无法连接到服务器";
            [_linkview addSubview:image];
            [_linkview addSubview:label];
        }
        if(link == linking)
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 310 , 45)];
            label.font = [UIFont systemFontOfSize:14];
            label.text = @"连接中...";
            label.textColor =[UIColor colorWithRed:0.46f green:0.40f blue:0.40f alpha:1.00f];
            [_linkview addSubview:label];
        }
        _tableView.tableHeaderView = _linkview;
    }
}

-(void)linkSuccess:(NSNotification *)link
{
    ECError* error = link.object;
    if (error.errorCode == ECErrorType_NoError) {
        [self updateLoginStates:success];
    }
    else
    {
        [self updateLoginStates:failed];
    }
}

-(void)prepareDisplay
{
    [self.sessionArray removeAllObjects];
    [self.sessionArray addObjectsFromArray:[[DeviceDBHelper sharedInstance] getMyCustomSession]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sessionArray.count == 0) {
        return 170.0f;
    }
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.sessionArray.count == 0) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ECSession* session = [self.sessionArray objectAtIndex:indexPath.row];
    [[DeviceDBHelper sharedInstance].msgDBAccess markMessagesAsReadOfSession:session.sessionId];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_COUNT_CHAGE_NOTICE object:nil];

    
    if (session.sessionId.length>5 && [[session.sessionId substringToIndex:5] isEqualToString:@"TLORG"]) {
        

        NSArray *spliteArray = [session.text componentsSeparatedByString:@"|"];
        TLOrgDataDTO *orgDto = [[TLOrgDataDTO alloc] init];
        orgDto.organizationId = [session.sessionId substringFromIndex:5];
        orgDto.organizationName = spliteArray.count>1?spliteArray[1]:spliteArray[0];
        [RTLHelper pushViewControllerWithName:@"TLOrgInfoViewController" itemData:orgDto block:^(TLOrgInfoViewController* obj) {
            
            
            
        }];
    }else if (session.type == 100) {
        
        //GroupNoticeViewController * gnvc = [[GroupNoticeViewController alloc]init];
        //[self.mainView pushViewController:gnvc animated:YES];
        
        [RTLHelper pushViewControllerWithName:@"GroupNoticeViewController" block:^(id obj) {
            
        }];
        
        
    }else{
        
        //ChatViewController *cvc = [[ChatViewController alloc] initWithSessionId:session.sessionId];
        //[self.mainView pushViewController:cvc animated:YES];
        WEAK_SELF(self);
        [RTLHelper pushViewControllerWithName:@"ChatViewController" itemData:@{@"SESSION_ID":session.sessionId} block:^(ChatViewController* obj) {
            __weak ChatViewController *weakVc = obj;
            if(![session.sessionId hasPrefix:@"g"]){
                [weakSelf getUserInfo:session vc:weakVc];
            }else{
                obj.title = [[DemoGlobalClass sharedInstance] getOtherNameWithVoip:session.sessionId];
            }
            
           
            
        }];
        
//        ChatViewController * cvc = [[ChatViewController alloc]initWithSessionId:session.sessionId];
//        [self.navigationController setViewControllers:[NSArray arrayWithObjects:[self.navigationController.viewControllers objectAtIndex:0],cvc, nil] animated:YES];
    }
}

-(void)getUserInfo:(ECSession*)session vc:(UIViewController*)vc{
    

    TLUserViewRequestDTO *userViewRequest = [[TLUserViewRequestDTO alloc] init];
    userViewRequest.loginId = session.sessionId;
    
    [GTLModuleDataHelper getUserView:userViewRequest requestArray:[NSMutableArray array] block:^(id obj, BOOL ret) {
        
        if (ret) {
            TLUserViewResultDTO *userInfo  = obj;
            vc.title = userInfo.userName;
        }else{
            ResponseDTO *resDTO = obj;
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }
    }];
    
    
    
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.sessionArray.count == 0) {
        return 1;
    }
    return _sessionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sessionArray.count == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *noMessageCellid = @"sessionnomessageCellidentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noMessageCellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noMessageCellid];
            UILabel *noMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 100.0f, cell.frame.size.width, 50.0f)];
            noMsgLabel.text = @"暂无聊天消息";
            noMsgLabel.textColor = [UIColor darkGrayColor];
            noMsgLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:noMsgLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    static NSString *sessioncellid = @"sessionCellidentifier";
    SessionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sessioncellid];
    
    if (cell == nil) {
        cell = [[SessionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sessioncellid];
        UILongPressGestureRecognizer  * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
        cell.nameLabel.tag =100;
        [cell.contentView addGestureRecognizer:longPress];
        cell.contentView.userInteractionEnabled = YES;
    }
    
    ECSession* session = [self.sessionArray objectAtIndex:indexPath.row];
    [cell setSessionData:session];
    return cell;
}

//时间显示内容
-(NSString *)getDateDisplayString:(long long) miliSeconds{
    
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[ NSDateFormatter alloc ] init ];
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    else
    {
        if (nowCmps.day==myCmps.day) {
            dateFmt.dateFormat = @"今天 HH:mm:ss";
        }
        else if((nowCmps.day-myCmps.day)==1)
        {
            dateFmt.dateFormat = @"昨天 HH:mm:ss";
        }
        else{
            dateFmt.dateFormat = @"MM-dd HH:mm:ss";
        }
    }
    return [dateFmt stringFromDate:myDate];
}


-(void)cellLongPress:(UILongPressGestureRecognizer * )longPress{
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [longPress locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        SessionViewCell  * cell = (SessionViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:cell.nameLabel.text delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
        [sheet showInView:cell];
        _memoryCell = cell;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;{
    
    if (buttonIndex == 0)
    {
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"删除该会话";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        NSIndexPath * path = [_tableView indexPathForCell:_memoryCell];
        ECSession* session = [self.sessionArray objectAtIndex:path.row];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if (session.type == 100)
            {
                [[DeviceDBHelper sharedInstance].msgDBAccess clearGroupMessageTable];
            }
            else
            {
                [[DeviceDBHelper sharedInstance] deleteAllMessageOfSession:session.sessionId];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.sessionArray removeObjectAtIndex:path.row];
                _memoryCell = nil;
                [_tableView reloadData];
            });
        });
        
    }
}

@end
