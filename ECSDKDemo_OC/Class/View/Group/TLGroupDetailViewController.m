//
//  TLGroupDetailViewController.m
//  TL
//
//  Created by Rainbow on 3/4/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLGroupDetailViewController.h"


#import "ImagePlayerView.h"
#import "UIImageView+WebCache.h"
#import "RImageList.h"
#import "RUILabel.h"
#import "TLUserListView.h"
#import "TLMineListItem.h"
#import "TLHelper.h"
#import "TLUpdateFormItem.h"
#import "TLFormItem.h"
#import "TLUserPublishCountItem.h"
#import "ChatViewController.h"
#import "TLModuleDataHelper.h"
#import "TLGroupDataDTO.h"
#import "TLViewOrgResultDTO.h"
#import "TLViewGroupResultDTO.h"
#import "KxMenu.h"
#import "UserDataHelper.h"
#import "UserInfoDTO.h"
#import "TLContactListViewController.h"
#import "TLContactListSelectViewController.h"

#define ImagePlayerView_Height 260.f
@interface TLGroupDetailViewController (){
    CGFloat yOffSet;
    NSString *groupOperType;
}
@property (nonatomic,strong) ImagePlayerView *imagePlayerView;
@property (nonatomic,strong) NSArray *imageURLs;
@property (nonatomic,strong) NSMutableDictionary *userInfoDic;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) TLViewGroupResultDTO *groupDetail;


@end

@implementation TLGroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群资料";
    
    

}

#pragma mark -
#pragma mark - 获取数据
-(void)getDetaiData{
    WEAK_SELF(self);
    TLGroupDataDTO *orgDto = self.itemData;
    TLViewGroupRequestDTO *request = [[TLViewGroupRequestDTO alloc] init];
    
    request.groupId = orgDto.groupId;
    
    
    [GTLModuleDataHelper viewGroup:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        if (ret) {
            self.groupDetail = obj;
            [weakSelf setupViews];
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;

    [self createActionButtons];
    [self getDetaiData];
}


- (void)createActionButtons{
        NSArray *actionButtons = @[[self createMenuButton]];
        self.navView.actionBtns = actionButtons;
}



- (UIButton*)createMenuButton
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setImage:[UIImage imageNamed:@"tl_right_more"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(showExpandMenu:) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

-(void)navMessageAction:(id)sender
{
    [self showExpandMenu:sender];
}

- (void)showExpandMenu:(UIButton*)sender
{
    
    KxMenuItem *item3 = [KxMenuItem menuItem:@"申请加入"
                                       image:nil
                                      extNum:0
                                      target:self
                                      action:@selector(addGroupButtonHandler)];
    
    
    
    NSString *deleteBtnTitle = @"";
    if([self.groupDetail.createUser.loginId isEqualToString:GUserDataHelper.tlUserInfo.loginId]){
        deleteBtnTitle = @"删除群组";
        groupOperType = @"4";
    }else{
        deleteBtnTitle = @"退出群组";
        groupOperType = @"2";
    }
    
    NSArray *menuItems;
    KxMenuItem *item1 = [KxMenuItem menuItem:deleteBtnTitle
                                       image:nil
                                      extNum:0
                                      target:self
                                      action:@selector(navExpandMenuDeleteAction)];
    item1.foreColor = COLOR_MAIN_TEXT;
    KxMenuItem *item2 = [KxMenuItem menuItem:@"邀请好友"
                                       image:nil
                                      extNum:0
                                      target:self
                                      action:@selector(navExpandMenuInvideAction)];
    
    item2.foreColor = COLOR_MAIN_TEXT;
    item3.foreColor = COLOR_MAIN_TEXT;
    
    if (self.groupDetail.join.integerValue!=1) {
        menuItems = @[item3];
    }else{
       menuItems = @[item1,item2];
    }
    
    KxMenuItem *first = menuItems[0];
    first.alignment = NSTextAlignmentLeft;
    
    CGRect rect = sender.frame;
    rect.size = CGSizeMake(40.f, 40.f);
    [KxMenu setTintColor:[UIColor whiteColor]];
    
    [KxMenu showMenuInView:self.view
                  fromRect:rect
                 menuItems:menuItems];
    
}

-(void)addGroupButtonHandler{
    
    
    
    
//    [[ECDevice sharedInstance].messageManager queryGroupMembers:self.groupDetail.groupId completion:^(ECError *error, NSArray *members) {
//        [members enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSLog(@"%@",obj);
//        }];
//    }];
//    
//    
//    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"正在申请加入";
//    hud.removeFromSuperViewOnHide = YES;
//    
//    [[ECDevice sharedInstance].messageManager joinGroup:self.groupDetail.groupId reason:@"我想加入" completion:^(ECError *error, NSString *groupId) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (error.errorCode == ECErrorType_NoError) {
//            
//            
//        }
//        else
//        {
//            
//        }
//        
//    }];
    
    
    
    TLGroupJoinApplyRequestDTO *request = [[TLGroupJoinApplyRequestDTO alloc] init];
    request.rlGroupId = self.groupDetail.rlGroupId; 
    request.type = @"0";
    request.voipAccount = GUserDataHelper.tlUserInfo.voipAccount;
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper operateGroup:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"发送成功"];
        }else{
            ResponseDTO *resDTO = obj;
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }
    }];
}


- (void)navExpandMenuInvideAction{
    [RTLHelper pushViewControllerWithName:@"TLContactListSelectViewController" itemData:self.groupDetail block:^(TLContactListSelectViewController* obj) {

    }];
}

- (void)navExpandMenuDeleteAction
{
    
    if (self.groupDetail.join.integerValue!=1) {
        
        return;
    }
    
    WEAK_SELF(self);
    TLGroupJoinApplyRequestDTO *request = [[TLGroupJoinApplyRequestDTO alloc] init];
    request.type = groupOperType;
    request.rlGroupId = self.groupDetail.rlGroupId;
    [GTLModuleDataHelper operateGroup:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"操作成功"];
            [weakSelf goback];
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];


}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - ui

- (void)setupViews
{
    if (self.contentScrollView!=nil) {
        [self.contentScrollView removeFromSuperview];
    }
    yOffSet = 0.f;
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT-TABBAR_HEIGHT)];
    [self.view addSubview:self.contentScrollView];

    
    
    //images
    //[self addImages];
    //info
    [self addInfo];
    
    //addcountsof publish
    //[self addCountOfPublish];
    //visitors
    [self addVisitors];
    
    //store
    //[self addStore];
    //download collection
    //[self addDownloadCollections];
    
    
    //mypublish
    //[self addMyPublish];
    
    //appeal
    //[self addAppeal];
    
    
    //addUserInfo 群描述
    [self addInterestAndSign];
    
    [self addAccountInfo];
    
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentScrollView.frame), yOffSet);
    
    [self addSendMessageBtn];
    
}

-(void)addImages{
    
    NSArray *userImages = [self.userInfoDic valueForKey:@"USER_IMAGES"];
    RImageList *imageList = [[RImageList alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 80.0f) itemData:@{@"IMAGE_LIST":userImages} isShowImageName:NO];
    [self.contentScrollView addSubview:imageList];
    
    yOffSet = yOffSet + CGRectGetHeight(imageList.frame);
    
}

-(void)addInfo{
    
    
    //CGFloat updateBtnHeight = 20.f;
    CGFloat userIconWidth = 80.f;
    CGFloat vGap = 5.f;
    CGFloat hGap = 10.f;
    
    //CGFloat textMaxWidth = CGRectGetWidth(self.contentScrollView.frame)-hGap*3-userIconWidth;
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.contentScrollView.frame), userIconWidth+vGap*2)];
    [self.contentScrollView addSubview:infoView];
    infoView.backgroundColor = UIColorFromRGBA(0xffffff, 0.5);
    
    CGFloat infoYOffSet = 0.f;
    
    //username
    NSString *userName = self.groupDetail.groupName;
    RUILabel *userNameLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:userName font:FONT_16B color:COLOR_MAIN_TEXT];
    userNameLabel.frame = CGRectMake(hGap,infoYOffSet + vGap, CGRectGetWidth(userNameLabel.frame), CGRectGetHeight(userNameLabel.frame));
    [infoView addSubview:userNameLabel];
    
    
//    UIImageView *vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLabel.frame)+hGap*2, infoYOffSet + vGap+(CGRectGetHeight(userNameLabel.frame)-14)/2, 60.f, 14)];
//    NSString *vipImageStr =[NSString stringWithFormat:@"tl_mine_viplv%@",[self.userInfoDic valueForKey:@"VIP_LEVEL"]];
//    vipImageView.image = [UIImage imageNamed:vipImageStr];
//    [infoView addSubview:vipImageView];
//    
    
    
    infoYOffSet = infoYOffSet + CGRectGetHeight(userNameLabel.frame)+vGap;
    //location
    NSString *location = self.groupDetail.cityName;
    RUILabel *locationLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:location font:FONT_14 color:COLOR_MAIN_TEXT];
    locationLabel.frame = CGRectMake(hGap,infoYOffSet + vGap, CGRectGetWidth(locationLabel.frame), CGRectGetHeight(locationLabel.frame));
    [infoView addSubview:locationLabel];
    
    infoYOffSet = infoYOffSet + CGRectGetHeight(locationLabel.frame)+vGap;
//    //age
//    //gender
//    NSString *age = [NSString stringWithFormat:@"%@",[self.userInfoDic valueForKey:@"TL_ACCOUNT"]];
//    RUILabel *ageLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:age font:FONT_14 color:COLOR_MAIN_TEXT];
//    ageLabel.frame = CGRectMake(hGap,infoYOffSet + vGap,CGRectGetWidth(ageLabel.frame), CGRectGetHeight(ageLabel.frame));
//    [infoView addSubview:ageLabel];
    
//    UIImageView *genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ageLabel.frame)+hGap, infoYOffSet + vGap, CGRectGetHeight(ageLabel.frame), CGRectGetHeight(ageLabel.frame))];
//    NSString *genderImageStr = [[self.userInfoDic valueForKey:@"GENDER"] integerValue]==1?@"tl_mine_personal_male":@"tl_mine_personal_female";
//    genderImageView.image = [UIImage imageNamed:genderImageStr];
//    [infoView addSubview:genderImageView];
    
    //profession
    
    NSString *profession = self.groupDetail.groupId;
    RUILabel *professionLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:profession font:FONT_14 color:COLOR_MAIN_TEXT];
    professionLabel.frame = CGRectMake(hGap,infoYOffSet + vGap, CGRectGetWidth(professionLabel.frame), CGRectGetHeight(professionLabel.frame));
    [infoView addSubview:professionLabel];
    infoYOffSet = infoYOffSet + CGRectGetHeight(professionLabel.frame)+vGap;
    
    //sign
    //    NSString *signature = [NSString stringWithFormat:@"个人签名：%@",[self.userInfoDic valueForKey:@"SIGNATURE"]];
    //    RUILabel *signatureLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:signature font:FONT_14 color:COLOR_MAIN_TEXT];
    //    signatureLabel.frame = CGRectMake(hGap,infoYOffSet + vGap, MIN(textMaxWidth, CGRectGetWidth(signatureLabel.frame)), CGRectGetHeight(signatureLabel.frame)*2);
    //    signatureLabel.numberOfLines = 2;
    //    [infoView addSubview:signatureLabel];
    //    infoYOffSet = infoYOffSet + CGRectGetHeight(signatureLabel.frame)+vGap;
    
    //userIcon
    NSString *groupIcon = self.groupDetail.groupIcon;
    NSString *userIconUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,groupIcon];
    if (userIconUrl) {
        
        UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(infoView.frame)-hGap-userIconWidth,vGap, userIconWidth, userIconWidth)];
        userImageView.layer.borderWidth = 0.5f;
        userImageView.layer.borderColor = [UIColor grayColor].CGColor;
        userImageView.layer.cornerRadius = userIconWidth/2;
        [infoView addSubview:userImageView];
        userImageView.layer.masksToBounds = YES;
        
        [userImageView sd_setImageWithURL:[NSURL URLWithString:userIconUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
        
        
    }
    //updatebtn
    //    CGFloat btnWidth = 60.f;
    //    UIButton *updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(infoView.frame)-hGap-(userIconWidth-btnWidth)/2-btnWidth, vGap*2+userIconWidth, btnWidth, updateBtnHeight)];
    //    [updateBtn setBackgroundColor:COLOR_ORANGE_TEXT];
    //    [updateBtn setTitle:@"修改资料" forState:UIControlStateNormal];
    //    [updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [updateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //    updateBtn.titleLabel.font = FONT_14;
    //    [updateBtn addTarget:self action:@selector(updateInfoHandler:) forControlEvents:UIControlEventTouchUpInside];
    //    [infoView addSubview:updateBtn];
    
    yOffSet = yOffSet + CGRectGetHeight(infoView.frame);
    
}
-(void)updateInfoHandler:(id)btn{
    [RTLHelper pushViewControllerWithName:@"TLMineInfoViewController" itemData:self.userInfoDic block:^(id obj) {
        
    }];
    
}
-(void)addVisitors{
    
    CGFloat hGap = 10.f;
    CGFloat vGap = 10.f;
    CGFloat userIconListHeight = 60.f;
    //username
    NSString *label = @"群成员：";
    RUILabel *labelLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:label font:FONT_14 color:COLOR_MAIN_TEXT];
    labelLabel.frame = CGRectMake(hGap,yOffSet + vGap, CGRectGetWidth(labelLabel.frame), CGRectGetHeight(labelLabel.frame));
    [self.contentScrollView addSubview:labelLabel];
    
    yOffSet = yOffSet + CGRectGetHeight(labelLabel.frame)+vGap;
    
    
    NSArray *userImages = self.groupDetail.groupUser;
    TLUserListView *imageList = [[TLUserListView alloc] initWithFrame:CGRectMake(0.f, yOffSet+vGap, CGRectGetWidth(self.view.frame), userIconListHeight) itemData:userImages isShowImageName:NO];
    [self.contentScrollView addSubview:imageList];
    
    yOffSet = yOffSet + CGRectGetHeight(imageList.frame)+vGap;
    
    
}
//-(void)addStore{
//    
//    NSDictionary *itemData = @{@"NAME":@"途乐商店",@"IMAGE":@"tl_mine_tule_store"};
//    TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.contentScrollView.frame), 50.f) itemData:itemData];
//    [self.contentScrollView addSubview:storeItem];
//    [storeItem addTarget:self action:@selector(memberStoreHandler:) forControlEvents:UIControlEventTouchUpInside];
//    yOffSet = yOffSet + CGRectGetHeight(storeItem.frame);
//}

-(void)memberStoreHandler:(id)btn{
    [RTLHelper pushViewControllerWithName:@"TLMemberStoreViewController" itemData:self.userInfoDic block:^(id obj) {
        
    }];
    
}

//-(void)addDownloadCollections{
//    CGFloat vGap = 3.f;
//    NSDictionary *itemData1 = @{@"NAME":@"我的下载",@"IMAGE":@"tl_mine_my_download"};
//    TLMineListItem *storeItem1 = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet+vGap, CGRectGetWidth(self.contentScrollView.frame)/2, 50.f) itemData:itemData1 isShowAction:NO];
//    storeItem1.layer.borderColor = UIColorFromRGBA(0xcccccc, 0.5).CGColor;
//    storeItem1.layer.borderWidth = 0.5f;
//    [self.contentScrollView addSubview:storeItem1];
//    
//    NSDictionary *itemData2 = @{@"NAME":@"我的收藏",@"IMAGE":@"tl_mine_my_collect"};
//    TLMineListItem *storeItem2 = [[TLMineListItem alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentScrollView.frame)/2, yOffSet+vGap, CGRectGetWidth(self.contentScrollView.frame)/2, 50.f) itemData:itemData2 isShowAction:NO];
//    storeItem2.layer.borderColor = UIColorFromRGBA(0xcccccc, 0.5).CGColor;
//    storeItem2.layer.borderWidth = 0.5f;
//    [self.contentScrollView addSubview:storeItem2];
//    
//    
//    
//    yOffSet = yOffSet + CGRectGetHeight(storeItem1.frame)+vGap*2;
//}

//-(void)addMyPublish{
//    CGFloat hGap = 3.f;
//    CGFloat vGap = 3.f;
//    NSString *label = @"我的发布：";
//    RUILabel *labelLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:label font:FONT_14 color:COLOR_MAIN_TEXT];
//    labelLabel.frame = CGRectMake(hGap,yOffSet + vGap, CGRectGetWidth(labelLabel.frame), CGRectGetHeight(labelLabel.frame));
//    [self.contentScrollView addSubview:labelLabel];
//    
//    yOffSet = yOffSet + CGRectGetHeight(labelLabel.frame)+vGap*2;
//    
//    
//    NSArray *itemsData = @[@{@"ID":@"1",@"NAME":@"攻略",@"IMG":@"menu1_homepage",@"VCNAME":@"TLStrategyListViewController",@"TYPE":@"1"},
//                           @{@"ID":@"2",@"NAME":@"路书",@"IMG":@"menu2_homepage",@"VCNAME":@"TLWayBookListViewController",@"TYPE":@"2"},
//                           @{@"ID":@"3",@"NAME":@"游记",@"IMG":@"menu3_homepage",@"VCNAME":@"TLTripNoteListViewController",@"TYPE":@"3"},
//                           @{@"ID":@"4",@"NAME":@"召集活动",@"IMG":@"menu4_homepage",@"VCNAME":@"TLGroupActivityListViewController",@"TYPE":@"4"},
//                           @{@"ID":@"5",@"NAME":@"车讯",@"IMG":@"menu5_homepage",@"VCNAME":@"TLCarMainListViewController",@"TYPE":@"5"},
//                           @{@"ID":@"6",@"NAME":@"二手平台",@"IMG":@"menu6_homepage",@"VCNAME":@"TLSecondPlatformViewController",@"TYPE":@"6"},
//                           @{@"ID":@"7",@"NAME":@"应急救援",@"IMG":@"menu7_homepage",@"VCNAME":@"TLEmergencyViewController",@"TYPE":@"7"},
//                           @{@"ID":@"8",@"NAME":@"商家",@"IMG":@"menu8_homepage",@"VCNAME":@"TLStoreListViewController",@"TYPE":@"8"}];
//    
//    [itemsData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSDictionary *itemData = @{@"NAME":[obj valueForKey:@"NAME"],@"IMAGE":[obj valueForKey:@"IMG"],@"ITEM_DATA":obj};
//        TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.contentScrollView.frame), 50.f) itemData:itemData];
//        [self.contentScrollView addSubview:storeItem];
//        [storeItem addTarget:self action:@selector(minePublishHandler:) forControlEvents:UIControlEventTouchUpInside];
//        
//        yOffSet = yOffSet + CGRectGetHeight(storeItem.frame);
//        
//    }];
//    
//}
//
//-(void)minePublishHandler:(TLMineListItem*)btn{
//    NSDictionary *itemData = [btn.itemData valueForKey:@"ITEM_DATA"];
//    [RTLHelper pushViewControllerWithName:[itemData valueForKey:@"VCNAME"] itemData:itemData block:^(id obj) {
//        
//    }];
//    
//}
//
//-(void)addAppeal{
//    NSDictionary *itemData = @{@"NAME":@"申诉",@"IMAGE":@"tl_mine_my_appeal"};
//    TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet+3.f, CGRectGetWidth(self.contentScrollView.frame), 50.f) itemData:itemData isShowAction:NO];
//    [self.contentScrollView addSubview:storeItem];
//    
//    yOffSet = yOffSet + CGRectGetHeight(storeItem.frame)+3.f;
//}


-(void)addInterestAndSign{
    CGFloat vGap = 3.f;
    CGFloat vSpace = 10.f;
    
    
    //yOffSet = yOffSet + CGRectGetHeight(interestFromItem.frame) + vGap;
    
    TLFormItem *signFromItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"群描述：",@"LABEL_VALUE":self.groupDetail.groupDesc,@"PLACE_HOLDER":@"写入个人签名"}];
    signFromItem.frame = signFromItem.itemFrame;
    [self.contentScrollView addSubview:signFromItem];
    yOffSet = yOffSet + CGRectGetHeight(signFromItem.frame) + vSpace;
    

    
    
    
}

-(void)addCountOfPublish{
    CGFloat vGap = 3.f;
    CGFloat hGap = 10.f;
    CGFloat itemWidth = 60.f;
    CGFloat itemHeight = 60.f;
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet+vGap, CGRectGetWidth(self.contentScrollView.frame), itemHeight+vGap*2)];
    infoView.backgroundColor = UIColorFromRGBA(0xffffff, 0.5);
    [self.contentScrollView addSubview:infoView];
    
    TLUserPublishCountItem *atr = [[TLUserPublishCountItem alloc] initWithFrame:CGRectMake(hGap, vGap, itemWidth, itemHeight) itemData:@{@"name":@"攻略",@"count":@"398"}];
    [infoView addSubview:atr];
    
    TLUserPublishCountItem *waybook = [[TLUserPublishCountItem alloc] initWithFrame:CGRectMake(hGap*2+itemWidth, vGap, itemWidth, itemHeight) itemData:@{@"name":@"路书",@"count":@"38"}];
    [infoView addSubview:waybook];
    
    TLUserPublishCountItem *tripNote = [[TLUserPublishCountItem alloc] initWithFrame:CGRectMake(hGap*3+itemWidth*2, vGap, itemWidth, itemHeight) itemData:@{@"name":@"游记",@"count":@"8"}];
    [infoView addSubview:tripNote];
    
    
    UIButton *allPublish = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentScrollView.frame)-80-hGap, (vGap*2+itemHeight-30.f)/2, 80, 30)];
    allPublish.layer.borderColor = COLOR_ORANGE_TEXT.CGColor;
    allPublish.layer.borderWidth = 1.f;
    allPublish.layer.cornerRadius = 4.f;
    allPublish.titleLabel.font = FONT_14;
    [allPublish setTitle:@"全部发布" forState:UIControlStateNormal];
    
    [allPublish setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
    [allPublish setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateHighlighted];
    [infoView addSubview:allPublish];
    
    yOffSet = yOffSet + vGap*2 + itemHeight;
}

-(void)addAccountInfo{
    CGFloat hGap = 10.f;
    CGFloat vGap = 10.f;
    //CGFloat userIconListHeight = 80.f;
    //username
//    NSString *label = @"账号信息：";
//    RUILabel *labelLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:label font:FONT_14 color:COLOR_MAIN_TEXT];
//    labelLabel.frame = CGRectMake(hGap,yOffSet+vGap, CGRectGetWidth(labelLabel.frame), CGRectGetHeight(labelLabel.frame));
//    [self.contentScrollView addSubview:labelLabel];
//    
//    yOffSet = yOffSet + CGRectGetHeight(labelLabel.frame)+vGap*2;
    
    
//    TLFormItem *accountFromItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"途乐号：",@"LABEL_VALUE":[self.userInfoDic valueForKey:@"TL_ACCOUNT"]}];
//    accountFromItem.frame = accountFromItem.itemFrame;
//    [self.contentScrollView addSubview:accountFromItem];
//    yOffSet = yOffSet + CGRectGetHeight(accountFromItem.frame) + vGap;
//    
//    TLFormItem *levelFromItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"会员星级：",@"LABEL_VALUE":[NSString stringWithFormat:@"%@LV",[self.userInfoDic valueForKey:@"VIP_LEVEL"]]}];
//    levelFromItem.frame = levelFromItem.itemFrame;
//    [self.contentScrollView addSubview:levelFromItem];
//    yOffSet = yOffSet + CGRectGetHeight(levelFromItem.frame) + vGap;
    
    TLFormItem *crateTimeFromItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"注册日期：",@"LABEL_VALUE":self.groupDetail.groupCreateTime}];
    crateTimeFromItem.frame = crateTimeFromItem.itemFrame;
    [self.contentScrollView addSubview:crateTimeFromItem];
    yOffSet = yOffSet + CGRectGetHeight(crateTimeFromItem.frame) + vGap;
    
    
    TLFormItem *accountFromItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"群主：",@"LABEL_VALUE":self.groupDetail.createUser.userName }];
        accountFromItem.frame = accountFromItem.itemFrame;
        [self.contentScrollView addSubview:accountFromItem];
        yOffSet = yOffSet + CGRectGetHeight(accountFromItem.frame) + vGap;

    
}


-(void)addLoveCars{
    
    CGFloat hGap = 10.f;
    CGFloat vGap = 10.f;
    CGFloat userIconListHeight = 80.f;
    //username
    NSString *label = @"我的爱车：";
    RUILabel *labelLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:label font:FONT_14 color:COLOR_MAIN_TEXT];
    labelLabel.frame = CGRectMake(hGap,yOffSet, CGRectGetWidth(labelLabel.frame), CGRectGetHeight(labelLabel.frame));
    [self.contentScrollView addSubview:labelLabel];
    
    yOffSet = yOffSet + CGRectGetHeight(labelLabel.frame);
    
    
    NSArray *userImages = [self.userInfoDic valueForKey:@"LOVE_CARS"];
    TLUserListView *imageList = [[TLUserListView alloc] initWithFrame:CGRectMake(0.f, yOffSet+vGap, CGRectGetWidth(self.view.frame), userIconListHeight) itemData:@{@"CURRENT_USERS":userImages} isShowImageName:NO];
    [self.contentScrollView addSubview:imageList];
    
    yOffSet = yOffSet + CGRectGetHeight(imageList.frame)+vGap;
    
    
}


-(void)addSendMessageBtn{
    
    if (self.groupDetail.join.integerValue!=1) {
        return;
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.view.frame)-TABBAR_HEIGHT, CGRectGetWidth(self.view.frame), TABBAR_HEIGHT)];
    [self.view addSubview:bottomView];
    
    
   
    
    
    bottomView.backgroundColor = UIColorFromRGBA(0xffffff, 0.5);
    
    
    UIButton *sendMessage = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-80)/2, CGRectGetHeight(self.view.frame)-30.f-(TABBAR_HEIGHT-30)/2, 80, 30)];
    //sendMessage.layer.borderColor = COLOR_ORANGE_TEXT.CGColor;
    //sendMessage.layer.borderWidth = 1.f;
    //    sendMessage.layer.cornerRadius = 4.f;
    sendMessage.titleLabel.font = FONT_16B;
    [sendMessage setTitle:@"发消息" forState:UIControlStateNormal];
    
    [sendMessage setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
    [sendMessage setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateHighlighted];
    [sendMessage addTarget:self action:@selector(sendMessageHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendMessage];
    
}

-(void)sendMessageHandler:(id)btn{
    //    ChatViewController * cvc = [[ChatViewController alloc]initWithSessionId:self.itemData[voipKey]];
    //    [self.navigationController setViewControllers:[NSArray arrayWithObjects:[self.navigationController.viewControllers objectAtIndex:0],cvc, nil] animated:YES];
    
    
    [self pushViewControllerWithName:@"ChatViewController" itemData:@{@"SESSION_ID":self.groupDetail.rlGroupId} block:^(ChatViewController *obj) {
        obj.title = self.groupDetail.groupName;
    }];
}



@end
