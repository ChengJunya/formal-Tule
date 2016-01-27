//
//  GroupNoticeViewController.m
//  ECSDKDemo_OC
//
//  Created by lrn on 14/12/18.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "GroupNoticeViewController.h"
#import "ContactListViewCell.h"
#import "TLGroupJoinApplyRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "ECDevice.h"
#import "TLUserViewResultDTO.h"
@interface GroupNoticeViewController (){
    CGFloat yOffSet;
}
@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray* messageArray;
@end


@implementation GroupNoticeViewController

#pragma mark - prepareUI

-(void)prepareUI
{
    yOffSet = STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT;
    self.title = @"群通知";
    _messageArray = [[NSMutableArray alloc]init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, yOffSet,self.view.frame.size.width,self.view.frame.size.height-yOffSet) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    self.navigationItem.leftBarButtonItem =leftItem;
    [self refreshTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableView) name:KNOTIFICATION_onReceivedGroupNotice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:KNotice_GetGroupName object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    
    [[DeviceDBHelper sharedInstance].msgDBAccess markGroupMessagesAsRead];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[DeviceDBHelper sharedInstance].msgDBAccess markGroupMessagesAsRead];
}

-(void)refreshTableView{
    
        [self.messageArray removeAllObjects];
        [self.messageArray addObjectsFromArray:[[DeviceDBHelper sharedInstance] getLatestHundredGroupNotice]];
    [self.tableView reloadData];
    

}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0f;
}

#pragma mark - UITableViewDataSource

/**
 *  slsls
 *
 *  @param tableView slsl
 *  @param section   lslsl
 *
 *  @return lsls
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *contactlistcellid = @"GroupNoticeViewCellidentifier";
    ContactListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contactlistcellid];
    if (cell == nil) {
        cell = [[ContactListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactlistcellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ECGroupNoticeMessage * msg = [_messageArray objectAtIndex:indexPath.row];
    NSString * groupName = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:msg.groupId];
    NSString *viopId;
    
     NSString *iconUrlStr;
    
    if (msg.messageType == ECGroupMessageType_Dissmiss) {
       
        cell.portraitImg.image = [UIImage imageNamed:@"group_head"];
        cell.nameLabel.text = groupName;
        cell.numberLabel.text = @"群组已被解散";
        viopId = msg.groupId;
        iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
        [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"group_head"]];

    }
    else if (msg.messageType == ECGroupMessageType_Invite)
    {
        ECInviterMsg * message = (ECInviterMsg *)msg;
        
//        cell.portraitImg.image = [[DemoGlobalClass sharedInstance]getOtherImageWithVoip:message.admin];
        viopId = message.groupId;
        cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:message.admin];
        cell.numberLabel.text = [NSString stringWithFormat:@"你已经被邀请加入【%@】群",groupName];
        iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
        [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
    }
    else if (msg.messageType == ECGroupMessageType_Propose)
    {
        ECProposerMsg * message = (ECProposerMsg *)msg;
//        cell.portraitImg.image = [[DemoGlobalClass sharedInstance]getOtherImageWithVoip:message.proposer];
       
        
        
        
        
        /*
         1:组织里新发布的攻略
         2:组织里新发布的路书
         3:组织里新发布的游记
         4:组织里新发布的活动
         
         
         5:加好友申请
         6:加好友申请结果 //拒绝加好友
         7:加群申请
         8:加群申请结果
         9:组织加入成功推送
         
         */
        
        
        if (message.proposer.length>3&&[@"TL_" isEqualToString:[message.proposer substringToIndex:3]]) {
            //自己添加的推送消息
            NSString *dataType = [message.proposer substringFromIndex:3];
            switch (dataType.integerValue) {
                case 5:{//加好友申请  **申请加好友
                    NSString *applyId = message.groupId;
                     NSArray *values = [message.declared componentsSeparatedByString:@"|"];
                    NSString *userName = values[1];
                    NSString *userId = values[0];
                    
                    cell.numberLabel.text = [NSString stringWithFormat:@"%@ 申请加好友",userName];
                    cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:userName];
                    viopId = userId;
                    
                    
                    [self getUserInfo:userId image:cell.portraitImg];
                    
//                    iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
//                    [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
                    break;
                }
                case 6:{//加好友申请结果  1-成功加 ** 为好友  ，0-**决绝加好友
                    

                    NSArray *values = [message.declared componentsSeparatedByString:@"|"];
                    NSString *userName = values[1];
                    NSString *userId = values[0];
                    NSString *succes = values[2];
                    viopId = userId;
                    if (succes.integerValue==1) {
                        cell.numberLabel.text = [NSString stringWithFormat:@"成功加 %@ 为好友",userName];
                        cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:userName];
                    }else{
                        cell.numberLabel.text = [NSString stringWithFormat:@"%@ 决绝加好友",userName];
                        cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:userName];
                    }
                    
                     [self getUserInfo:userId image:cell.portraitImg];
//                    iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
//                    [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
                    break;
                }
                case 7:{//加群申请  ** 申请加入 ** 群
                    

                    NSArray *values = [message.declared componentsSeparatedByString:@"|"];
                    NSString *userName = values[1];
                    NSString *userId = values[0];
                    NSString *groupId = values[2];
                    NSString *groupName = values[3];
                    viopId = groupId;
                    cell.numberLabel.text = [NSString stringWithFormat:@"%@ 申请加入 【%@】 群",userName,groupName];
                    cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:userName];
                    
                    
                    iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
                    [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
                    break;
                }
                case 8:{ //加群申请结果  1-成功加入 ** 群 0-**群拒绝加入
                    
                    NSArray *values = [message.declared componentsSeparatedByString:@"|"];
                    NSString *groupName = values[1];
                    NSString *groupId = values[0];
                    NSString *succes = values[2];
                    viopId = groupId;
                    if (succes.integerValue==1) {
                        cell.numberLabel.text = [NSString stringWithFormat:@"成功加入 %@ 群",groupName];
                        cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:groupName];
                    }else{
                        cell.numberLabel.text = [NSString stringWithFormat:@"%@ 群拒绝加入",groupName];
                        cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:groupName];
                    }
                    
                    iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
                    [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
                    
                    break;
                }
                case 9:{//组织加入成功推送  成功加入 ** 组织
                    
                    NSArray *values = [message.declared componentsSeparatedByString:@"|"];
                    NSString *orgName = values[1];
                    NSString *orgId = values[0];
                    NSString *succes = values[2];
                    viopId = orgId;
                    cell.numberLabel.text = [NSString stringWithFormat:@"成功加入 %@ 组织",orgName];
                    cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:orgName];
                    cell.portraitImg.image = [UIImage imageNamed:@"group_head"];
//                    iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
//                    [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
                    break;
                }
                default:
                    break;
            }
        }else{//YF-OK
            viopId = message.groupId;

            cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:groupName];
            cell.numberLabel.text = [NSString stringWithFormat:@"%@ 申请加入 【%@】 群",@"有人",groupName];
            iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
            [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
            
            //[self getUserInfo:message.proposer cell:cell label:cell.numberLabel type:1 other:groupName];
           
        }
        
    

        
        
        
    }
    else if (msg.messageType == ECGroupMessageType_Join)
    {
        ECJoinGroupMsg *message = (ECJoinGroupMsg *)msg;
//        cell.portraitImg.image = [[DemoGlobalClass sharedInstance]getOtherImageWithVoip:message.member];
        viopId = message.member;
        cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:message.member];
        cell.numberLabel.text = [NSString stringWithFormat:@"已加入群%@",groupName];
        iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
        [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
    }
    else if (msg.messageType == ECGroupMessageType_Quit)//YF-OK
    {
        ECQuitGroupMsg *message = (ECQuitGroupMsg *)msg;
        cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:groupName];
        viopId = message.groupId;
        
        
        //[self getUserInfo:message.member image:cell.portraitImg];
        iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
        [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
        
        TLUserViewRequestDTO *userViewRequest = [[TLUserViewRequestDTO alloc] init];
        userViewRequest.loginId = message.member;
        
        [GTLModuleDataHelper getUserView:userViewRequest requestArray:[NSMutableArray array] block:^(id obj, BOOL ret) {
            
            if (ret) {
                TLUserViewResultDTO *userInfo  = obj;

                cell.numberLabel.text = [NSString stringWithFormat:@"%@已退出群【%@】",userInfo.userName,groupName];
                
                
                
            }else{
                ResponseDTO *resDTO = obj;
                [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
            }
        }];
        
    }
    else if (msg.messageType == ECGroupMessageType_RemoveMember)
    {
        ECRemoveMemberMsg *message = (ECRemoveMemberMsg *)msg;
        cell.portraitImg.image = [[DemoGlobalClass sharedInstance]getOtherImageWithVoip:message.member];
        viopId = message.member;
        cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:message.member];
        cell.numberLabel.text = [NSString stringWithFormat:@"已被移除【%@】群",groupName];
        iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
        [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
    }else if(msg.messageType == ECGroupMessageType_ReplyJoin) {//YF-OK
        ECReplyJoinGroupMsg *message = (ECReplyJoinGroupMsg *)msg;
//        cell.portraitImg.image = [[DemoGlobalClass sharedInstance]getOtherImageWithVoip:message.member];
        viopId = message.groupId;
        cell.nameLabel.text = [[DemoGlobalClass sharedInstance] getOtherNameWithVoip:groupName];
        cell.numberLabel.text = [NSString stringWithFormat:@"您已被加入【%@】群",groupName];
        iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
        [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
        
    }else if(msg.messageType == ECGroupMessageType_ReplyInvite) {//YF-OK
        ECReplyInviteGroupMsg *message = (ECReplyInviteGroupMsg *)msg;
        cell.portraitImg.image = [[DemoGlobalClass sharedInstance]getOtherImageWithVoip:message.member];
        viopId = message.groupId;
        cell.nameLabel.text = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:message.member];
        cell.numberLabel.text = [NSString stringWithFormat:@"您已被决绝加入【%@】群",groupName];
        iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,viopId];
        [cell.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
        
    } else if(msg.messageType == ECGroupMessageType_ProposeFriend) {
        
    }
    

    

    

    
    
    

    

    
   
    return cell;
}




-(void)getUserInfo:(NSString*)sessionId image:(UIImageView*)iamgeView{
    
    WEAK_SELF(self);
    TLUserViewRequestDTO *userViewRequest = [[TLUserViewRequestDTO alloc] init];
    userViewRequest.loginId = sessionId;
    
    [GTLModuleDataHelper getUserView:userViewRequest requestArray:[NSMutableArray array] block:^(id obj, BOOL ret) {
        
        if (ret) {
            TLUserViewResultDTO *userInfo  = obj;
            
            NSString *iconUrlStr = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,userInfo.userIcon];
            if (iamgeView!=nil) {
                 [iamgeView  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
            }
            
            
            
        }else{
            ResponseDTO *resDTO = obj;
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }
    }];
    
    
   
    
}

//设置label
-(void)getUserInfo:(NSString*)sessionId cell:(UITableViewCell *)cell label:(UILabel*)label type:(int)type other:(NSString*)other{
    

    TLUserViewRequestDTO *userViewRequest = [[TLUserViewRequestDTO alloc] init];
    userViewRequest.loginId = sessionId;
    
    [GTLModuleDataHelper getUserView:userViewRequest requestArray:[NSMutableArray array] block:^(id obj, BOOL ret) {
        
        if (ret) {
            TLUserViewResultDTO *userInfo  = obj;
            
            
            if (type==1) {
                label.text = [NSString stringWithFormat:@"%@ 申请加入 【%@】 群",userInfo.userName,other];
            }
            [cell layoutSubviews];
            
            
        }else{
//            ResponseDTO *resDTO = obj;
//            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }
    }];
    
    
    
    
}



/**
 *  确认好友申请
 *
 *  @param tableView
 *  @param indexPath
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ECGroupNoticeMessage * msg = [_messageArray objectAtIndex:indexPath.row];
    //NSString * groupName = [[DemoGlobalClass sharedInstance]getOtherNameWithVoip:msg.groupId];
    
    
    
    if (msg.messageType == ECGroupMessageType_Propose){
        ECProposerMsg * message = (ECProposerMsg *)msg;
       
        
        if (message.proposer.length>3&&[@"TL_" isEqualToString:[message.proposer substringToIndex:3]]) {
            //自己添加的推送消息
            NSString *dataType = [message.proposer substringFromIndex:3];
            switch (dataType.integerValue) {
                case 5:{//加好友申请  **申请加好友
                    NSString *applyId = message.groupId;
                    NSArray *values = [message.declared componentsSeparatedByString:@"|"];
                    NSString *userName = values[1];
                    NSString *userId = values[0];
                    
                   
                    
                    [self operateUserApplay:userId applyId:applyId];
                    
                    break;
                }
                case 6:{//加好友申请结果  1-成功加 ** 为好友  ，0-**决绝加好友
                    
                    
                                       break;
                }
                case 7:{//加群申请  ** 申请加入 ** 群
                    
                    
                    NSArray *values = [message.declared componentsSeparatedByString:@"|"];
                    NSString *userName = values[1];
                    NSString *userId = values[0];
                    NSString *groupId = values[2];
                    NSString *groupName = values[3];
                    
                    
                    [self operateGroupPorpose:groupId proposer:userId];
                    
                    break;
                }
                case 8:{ //加群申请结果  1-成功加入 ** 群 0-**群拒绝加入
                    
                    
                    
                    break;
                }
                case 9:{//组织加入成功推送  成功加入 ** 组织
                    
                  
                    break;
                }
                default:
                    break;
            }
        }else{
            [self operateGroupPorpose:message.groupId proposer:message.proposer];
        }
        

        
        
        
        

    }else if(msg.messageType==ECGroupMessageType_Invite){
        //被邀请加入一个群组
        
    }
}


-(void)operateGroupPorpose:(NSString*)groupId proposer:(NSString *)proposer{
    [GHUDAlertUtils showZXColorAlert:@"是否允许加入此用户到群组里？" subTitle:@"" cancleButton:@"拒绝" sureButtonTitle:@"允许" COLORButtonType:0 buttonHeight:40 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
        
        TLGroupJoinApplyRequestDTO *request = [[TLGroupJoinApplyRequestDTO alloc] init];
        request.rlGroupId = groupId;
        request.voipAccount = proposer;
        request.type = @"1";
        if (index == 1) {
            request.confirm = @"0";
            
        }else{
            request.confirm = @"1";
            
        }
        
        [GHUDAlertUtils toggleLoadingInView:self.view];
        [GTLModuleDataHelper  operateGroup:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
            
            [GHUDAlertUtils hideLoadingInView:self.view];
            
            ResponseDTO *resDTO = obj;
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }];
        
    }];
    

}


-(void)operateUserApplay:(NSString*)userId applyId:(NSString *)applyId{
    [GHUDAlertUtils showZXColorAlert:@"是否允许加入此用户到群组里？" subTitle:@"" cancleButton:@"拒绝" sureButtonTitle:@"允许" COLORButtonType:0 buttonHeight:40 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
        
        TLComfirmAddFrinedRequestDTO *request = [[TLComfirmAddFrinedRequestDTO alloc] init];
        request.applyId = applyId;

        if (index == 1) {
            request.decision = @"1";
            
        }else{
            request.decision = @"2";
            
        }
        
        [GHUDAlertUtils toggleLoadingInView:self.view];
        [GTLModuleDataHelper  confirmAddFriend:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
            
            [GHUDAlertUtils hideLoadingInView:self.view];
            
            ResponseDTO *resDTO = obj;
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }];
        
    }];
    
    
}
@end
