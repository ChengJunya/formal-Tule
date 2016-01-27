//
//  TLContactDetailViewController.m
//  TL
//
//  Created by Rainbow on 3/1/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLContactDetailViewController.h"

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
#import "TLUserViewRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "TLUserViewResultDTO.h"
#import "TLPhotoBrowserViewController.h"
#import "TLAddFriendApplyRequestDTO.h"
#import "ZXColorButton.h"
#import "TLRenameFriendRequestDTO.h"
#import "TLResponseDTO.h"
#import "ZXCropViewController.h"
#import "KxMenu.h"
#import "TLUpdateUserNickNameViewController.h"
#import "TLToBlackViewController.h"
#import "TLUserOrgListView.h"
#define ImagePlayerView_Height 260.f
@interface TLContactDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>{
    CGFloat yOffSet;
    BOOL isEditingName;
    
    
    //UITextField *userNameField;
    //UIButton *updateUserNameBtn;
}
@property (nonatomic,strong) ImagePlayerView *imagePlayerView;
@property (nonatomic,strong) NSArray *imageURLs;
@property (nonatomic,strong) NSMutableDictionary *userInfoDic;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) TLUserViewResultDTO *userInfoDto;
@end

@implementation TLContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    
    
    isEditingName = NO;
    
    self.userInfoDic = self.itemData;
    
    
    
    
    
    
//    yOffSet = 0.f;
//    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT-TABBAR_HEIGHT)];
//    [self.view addSubview:self.contentScrollView];
    
    
    [self addAllUIResources];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;

    
    [self getUserInfoView];
    [self createActionButtons];
}

-(void)getUserInfoView{
    WEAK_SELF(self);
    TLUserViewRequestDTO *userViewRequest = [[TLUserViewRequestDTO alloc] init];
    userViewRequest.loginId = [self.userInfoDic valueForKey:@"loginId"];
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getUserView:userViewRequest requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            weakSelf.userInfoDto = obj;
            [weakSelf setupViews];
        }else{
            ResponseDTO *resDTO = obj;
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }
    }];
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
    [self addImages];
    //info
    [self addInfo];
    
    //addcountsof publish
    //[self addCountOfPublish];
    //visitors
    //[self addVisitors];
    
    //store
    //[self addStore];
    //download collection
    //[self addDownloadCollections];
    
    
    //mypublish
    [self addMyPublish];
    
    //appeal
    //[self addAppeal];
    
    
    //addUserInfo
    //[self addInterestAndSign];
    
    [self addGroups];
    [self addOrgs];
    
    [self addAccountInfo];
    
    
    
    
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentScrollView.frame), yOffSet);
    
    [self addSendMessageBtn];
    
}



#pragma mark-
#pragma mark-添加右侧菜单




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
    
    
    
    NSArray *menuItems;
    KxMenuItem *item1 = [KxMenuItem menuItem:@"修改备注"
                                       image:nil
                                      extNum:0
                                      target:self
                                      action:@selector(updateUserNameAction)];
    item1.foreColor = COLOR_MAIN_TEXT;
    KxMenuItem *item2 = [KxMenuItem menuItem:@"拉黑举报"
                                       image:nil
                                      extNum:0
                                      target:self
                                      action:@selector(toBlackAction)];
    
    item2.foreColor = COLOR_MAIN_TEXT;
    
    NSString *item3Title = @"";
    if (self.userInfoDto.isFriend.integerValue==1) {
        item3Title = @"删除好友";
    }else{
        item3Title = @"添加好友";
    }
    
    KxMenuItem *item3 = [KxMenuItem menuItem:item3Title
                                       image:nil
                                      extNum:0
                                      target:self
                                      action:@selector(deleteFriedAction)];
    
    item3.foreColor = COLOR_MAIN_TEXT;

    if (self.userInfoDto.isFriend.integerValue==1) {
        menuItems = @[item1,item2,item3];
    }else{
        menuItems = @[item3];
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

#pragma mark-
#pragma mark-操作事件
-(void)updateUserNameAction{
    [self pushViewControllerWithName:@"TLUpdateUserNickNameViewController" block:^(TLUpdateUserNickNameViewController* obj) {
        obj.userInfoDto = self.userInfoDto;
    }];
}
-(void)toBlackAction{
    [self pushViewControllerWithName:@"TLToBlackViewController" block:^(TLToBlackViewController* obj) {
        obj.userInfoDto = self.userInfoDto;
    }];
}
-(void)deleteFriedAction{
    if (self.userInfoDto.isFriend.integerValue==1) {
        //删除好友
        [self deleteFried];
    }else{
        //添加好友
        [self addFriendButtonHandler:nil];
    }
}

#pragma mark-
#pragma mark- 添加视图

-(void)addGroups{
    NSMutableArray *gourps = [NSMutableArray array];
    [self.userInfoDto.joinGroupInfo enumerateObjectsUsingBlock:^(TLGroupDataDTO* obj, NSUInteger idx, BOOL *stop) {
        TLTripUserDTO *item = [[TLTripUserDTO alloc] init];
        item.userName = obj.groupName;
        item.loginId = obj.groupId;
        item.userIcon = obj.groupIcon;
        [gourps addObject:item];
    }];
    
    
    CGFloat hGap = 10.f;
    CGFloat vGap = 10.f;
    CGFloat userIconListHeight = 120.f;
    //username
    NSString *label = @"Ta的群：";
    RUILabel *labelLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:label font:FONT_14 color:COLOR_MAIN_TEXT];
    labelLabel.frame = CGRectMake(hGap,yOffSet + vGap, CGRectGetWidth(labelLabel.frame), CGRectGetHeight(labelLabel.frame));
    [self.contentScrollView addSubview:labelLabel];
    
    yOffSet = yOffSet + CGRectGetHeight(labelLabel.frame)+vGap;
    
    
    NSArray *userImages = gourps;
    
    TLUserListView *imageList = [[TLUserListView alloc] initWithFrame:CGRectMake(0.f, yOffSet+vGap, CGRectGetWidth(self.view.frame), userIconListHeight) itemData:userImages isShowImageName:YES];
    imageList.type = 1;
    [self.contentScrollView addSubview:imageList];
    
    yOffSet = yOffSet + CGRectGetHeight(imageList.frame)+vGap;
    
    
}


-(void)addOrgs{
    
    CGFloat hGap = 10.f;
    CGFloat vGap = 10.f;
    CGFloat userIconListHeight = 60.f;
    //username
    NSString *label = @"Ta的组织：";
    RUILabel *labelLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:label font:FONT_14 color:COLOR_MAIN_TEXT];
    labelLabel.frame = CGRectMake(hGap,yOffSet + vGap, CGRectGetWidth(labelLabel.frame), CGRectGetHeight(labelLabel.frame));
    [self.contentScrollView addSubview:labelLabel];
    
    yOffSet = yOffSet + CGRectGetHeight(labelLabel.frame)+vGap;
    
    

    TLUserOrgListView *imageList = [[TLUserOrgListView alloc] initWithFrame:CGRectMake(0.f, yOffSet+vGap, CGRectGetWidth(self.view.frame), userIconListHeight) list:self.userInfoDto.orgInfo];
    [self.contentScrollView addSubview:imageList];
    
    yOffSet = yOffSet + CGRectGetHeight(imageList.frame)+vGap;
    
    
}




-(void)addImages{
    
    NSArray *userImages = self.userInfoDto.userImages;
    if (userImages.count==0) {
        return;
    }
    RImageList *imageList = [[RImageList alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 80.0f) itemData:@{@"IMAGE_LIST":userImages} isShowImageName:NO];
    [self.contentScrollView addSubview:imageList];
    
    
    //添加手势
    UITapGestureRecognizer* infoTapRecognizer;
    infoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personInfoHandler:)];
    infoTapRecognizer.numberOfTapsRequired = 1;
    [imageList addGestureRecognizer:infoTapRecognizer];
    
    
    yOffSet = yOffSet + CGRectGetHeight(imageList.frame);
    
}

-(void)addInfo{
    
    
    CGFloat updateBtnHeight = 20.f;
    CGFloat userIconWidth = 80.f;
    CGFloat vGap = 5.f;
    CGFloat hGap = 10.f;
    
    CGFloat textMaxWidth = CGRectGetWidth(self.contentScrollView.frame)-hGap*3-userIconWidth;
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.contentScrollView.frame), userIconWidth+vGap*3+updateBtnHeight)];
    [self.contentScrollView addSubview:infoView];
    infoView.backgroundColor = UIColorFromRGBA(0xffffff, 0.5);
    
    CGFloat infoYOffSet = 0.f;
    
    

    //username
   NSString *userName = [NSString stringWithFormat:@"%@",self.userInfoDto.userName];
//    
//    CGSize nameSize = [userName sizeWithAttributes:@{NSFontAttributeName:FONT_16B}];
//    
//    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(hGap,infoYOffSet + vGap,100.f, nameSize.height+vGap*2)];
//    [infoView addSubview:userNameField];
//    userNameField.text = userName;
//    userNameField.enabled = NO;
    //WEAK_SELF(self);
//    updateUserNameBtn = [ZXColorButton buttonWithType:EZXBT_BOX_GREEN frame:CGRectMake(userNameField.maxX, userNameField.frame.origin.y, 80.f, userNameField.height) title:@"修改备注" font:FONT_14 block:^{
//        [weakSelf updateUserNickName];
//    }];
//    
//    [infoView addSubview:updateUserNameBtn];
//    
//    if (!self.userInfoDto.isFriend.integerValue==1) {
//        [updateUserNameBtn setW:0.f];
//        updateUserNameBtn.hidden = YES;
//    }

    
    RUILabel *userNameLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:userName font:FONT_16B color:COLOR_MAIN_TEXT];
    userNameLabel.frame = CGRectMake(hGap,infoYOffSet + vGap, CGRectGetWidth(userNameLabel.frame), CGRectGetHeight(userNameLabel.frame));
    [infoView addSubview:userNameLabel];
    
    
    UIImageView *vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(userNameLabel.maxX+hGap, infoYOffSet + vGap+(CGRectGetHeight(userNameLabel.frame)-14)/2, 60.f, 14)];
    NSString *vipImageStr =[NSString stringWithFormat:@"tl_mine_viplv%@",self.userInfoDto.vipLevel];
    vipImageView.image = [UIImage imageNamed:vipImageStr];
    [infoView addSubview:vipImageView];
    
    
    
    infoYOffSet = infoYOffSet + CGRectGetHeight(userNameLabel.frame)+vGap;
    //location
    NSString *location = self.userInfoDto.cityName;
    RUILabel *locationLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:location font:FONT_14 color:COLOR_MAIN_TEXT];
    locationLabel.frame = CGRectMake(hGap,infoYOffSet + vGap, CGRectGetWidth(locationLabel.frame), CGRectGetHeight(locationLabel.frame));
    [infoView addSubview:locationLabel];
    
    infoYOffSet = infoYOffSet + CGRectGetHeight(locationLabel.frame)+vGap;
    //age
    //gender
    NSString *age = [NSString stringWithFormat:@"%@岁",self.userInfoDto.age];
    RUILabel *ageLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:age font:FONT_14 color:COLOR_MAIN_TEXT];
    ageLabel.frame = CGRectMake(hGap,infoYOffSet + vGap,CGRectGetWidth(ageLabel.frame), CGRectGetHeight(ageLabel.frame));
    [infoView addSubview:ageLabel];
    
    UIImageView *genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ageLabel.frame)+hGap, infoYOffSet + vGap, CGRectGetHeight(ageLabel.frame), CGRectGetHeight(ageLabel.frame))];
    NSString *genderImageStr = [self.userInfoDto.gender integerValue]==1?@"tl_mine_personal_male":@"tl_mine_personal_female";
    genderImageView.image = [UIImage imageNamed:genderImageStr];
    [infoView addSubview:genderImageView];
    
    //profession
    
    NSString *profession = self.userInfoDto.profession;
    RUILabel *professionLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:profession font:FONT_14 color:COLOR_MAIN_TEXT];
    professionLabel.frame = CGRectMake(hGap+CGRectGetMaxX(genderImageView.frame),infoYOffSet + vGap, CGRectGetWidth(professionLabel.frame), CGRectGetHeight(professionLabel.frame));
    [infoView addSubview:professionLabel];
    infoYOffSet = infoYOffSet + CGRectGetHeight(professionLabel.frame)+vGap;
    
    //sign
    NSString *signature = [NSString stringWithFormat:@"个人签名：%@",self.userInfoDto.signature];
    RUILabel *signatureLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:signature font:FONT_14 color:COLOR_MAIN_TEXT];
    signatureLabel.frame = CGRectMake(hGap,infoYOffSet + vGap, MIN(textMaxWidth, CGRectGetWidth(signatureLabel.frame)), CGRectGetHeight(signatureLabel.frame)*2);
    signatureLabel.numberOfLines = 2;
    [infoView addSubview:signatureLabel];
    infoYOffSet = infoYOffSet + CGRectGetHeight(signatureLabel.frame)+vGap;
    
    //userIcon
    NSString *userIconUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,self.userInfoDto.userIcon];
    
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

//保存备注
//-(void)updateUserNickName{
//    
//    if (userNameField.text.length==0) {
//        [GHUDAlertUtils toggleMessage:@"请输入备注名称"];
//        return;
//    }
//    
//    if (isEditingName) {
//        userNameField.enabled = NO;
//        [updateUserNameBtn setTitle:@"修改备注" forState:UIControlStateNormal];
//        
//        TLRenameFriendRequestDTO *request = [[TLRenameFriendRequestDTO alloc] init];
//        request.friendLoginId = self.userInfoDto.loginId;
//        request.friendNote = userNameField.text;
//        
//            [GHUDAlertUtils toggleLoadingInView:self.view];
//        isEditingName = NO;
//        [GTLModuleDataHelper reNameFriend:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
//           [GHUDAlertUtils hideLoadingInView:self.view];
//            TLResponseDTO *response = obj;
//            [GHUDAlertUtils toggleMessage:response.resultDesc];
//        }];
//        
//        
//        
//        
//    }else{
//        userNameField.enabled = YES;
//        [userNameField becomeFirstResponder];
//        [updateUserNameBtn setTitle:@"保存" forState:UIControlStateNormal];
//        isEditingName = YES;
//    }
//}

-(void)updateInfoHandler:(id)btn{
    [RTLHelper pushViewControllerWithName:@"TLMineInfoViewController" itemData:self.userInfoDic block:^(id obj) {
        
    }];
    
}
-(void)addVisitors{
    
    CGFloat hGap = 10.f;
    CGFloat vGap = 10.f;
    CGFloat userIconListHeight = 60.f;
    //username
    NSString *label = @"最近访客：";
    RUILabel *labelLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:label font:FONT_14 color:COLOR_MAIN_TEXT];
    labelLabel.frame = CGRectMake(hGap,yOffSet + vGap, CGRectGetWidth(labelLabel.frame), CGRectGetHeight(labelLabel.frame));
    [self.contentScrollView addSubview:labelLabel];
    
    yOffSet = yOffSet + CGRectGetHeight(labelLabel.frame)+vGap;
    
    
    NSArray *userImages = [self.userInfoDic valueForKey:@"VISITORS"];
    TLUserListView *imageList = [[TLUserListView alloc] initWithFrame:CGRectMake(0.f, yOffSet+vGap, CGRectGetWidth(self.view.frame), userIconListHeight) itemData:@{@"CURRENT_USERS":userImages} isShowImageName:NO];
    [self.contentScrollView addSubview:imageList];
    
    yOffSet = yOffSet + CGRectGetHeight(imageList.frame)+vGap;
    
    
}
-(void)addStore{
    
    NSDictionary *itemData = @{@"NAME":@"途乐商店",@"IMAGE":@"tl_mine_tule_store"};
    TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.contentScrollView.frame), 50.f) itemData:itemData];
    [self.contentScrollView addSubview:storeItem];
    [storeItem addTarget:self action:@selector(memberStoreHandler:) forControlEvents:UIControlEventTouchUpInside];
    yOffSet = yOffSet + CGRectGetHeight(storeItem.frame);
}

-(void)memberStoreHandler:(id)btn{
    [RTLHelper pushViewControllerWithName:@"TLMemberStoreViewController" itemData:self.userInfoDic block:^(id obj) {
        
    }];
    
}

-(void)addDownloadCollections{
    CGFloat vGap = 3.f;
    NSDictionary *itemData1 = @{@"NAME":@"我的下载",@"IMAGE":@"tl_mine_my_download"};
    TLMineListItem *storeItem1 = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet+vGap, CGRectGetWidth(self.contentScrollView.frame)/2, 50.f) itemData:itemData1 isShowAction:NO];
    storeItem1.layer.borderColor = UIColorFromRGBA(0xcccccc, 0.5).CGColor;
    storeItem1.layer.borderWidth = 0.5f;
    [self.contentScrollView addSubview:storeItem1];
    
    NSDictionary *itemData2 = @{@"NAME":@"我的收藏",@"IMAGE":@"tl_mine_my_collect"};
    TLMineListItem *storeItem2 = [[TLMineListItem alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentScrollView.frame)/2, yOffSet+vGap, CGRectGetWidth(self.contentScrollView.frame)/2, 50.f) itemData:itemData2 isShowAction:NO];
    storeItem2.layer.borderColor = UIColorFromRGBA(0xcccccc, 0.5).CGColor;
    storeItem2.layer.borderWidth = 0.5f;
    [self.contentScrollView addSubview:storeItem2];
    
    
    
    yOffSet = yOffSet + CGRectGetHeight(storeItem1.frame)+vGap*2;
}

-(void)addMyPublish{
    CGFloat hGap = 3.f;
    CGFloat vGap = 3.f;
    NSString *label = @"Ta的发布：";
    RUILabel *labelLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:label font:FONT_14 color:COLOR_MAIN_TEXT];
    labelLabel.frame = CGRectMake(hGap,yOffSet + vGap, CGRectGetWidth(labelLabel.frame), CGRectGetHeight(labelLabel.frame));
    [self.contentScrollView addSubview:labelLabel];
    
    yOffSet = yOffSet + CGRectGetHeight(labelLabel.frame)+vGap*2;
    
    NSString *loginId = [self.userInfoDic valueForKey:@"loginId"];
    NSArray *itemsData = @[
  @{@"ID":@"1",@"NAME":@"攻略",@"IMG":@"menu1_homepage",@"VCNAME":@"TLStrategyListViewController",@"TYPE":@"1",@"IS_SHOW_MENU":@"1",@"IS_SHOW_ADD":@"1",@"DATATYPE":@"1",@"LOGINID":loginId},
   @{@"ID":@"2",@"NAME":@"路书",@"IMG":@"menu2_homepage",@"VCNAME":@"TLWayBookListViewController",@"TYPE":@"2",@"IS_SHOW_MENU":@"1",@"IS_SHOW_ADD":@"1",@"DATATYPE":@"1",@"LOGINID":loginId},
   @{@"ID":@"3",@"NAME":@"游记",@"IMG":@"menu3_homepage",@"VCNAME":@"TLTripNoteListViewController",@"TYPE":@"3",@"IS_SHOW_MENU":@"1",@"IS_SHOW_ADD":@"1",@"DATATYPE":@"1",@"LOGINID":loginId},
   @{@"ID":@"4",@"NAME":@"活动",@"IMG":@"menu4_homepage",@"VCNAME":@"TLGroupActivityListViewController",@"TYPE":@"4",@"IS_SHOW_MENU":@"1",@"IS_SHOW_ADD":@"1",@"DATATYPE":@"1",@"LOGINID":loginId}];
    
    [itemsData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *itemData = @{@"NAME":[obj valueForKey:@"NAME"],@"IMAGE":[obj valueForKey:@"IMG"],@"ITEM_DATA":obj};
        TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.contentScrollView.frame), 50.f) itemData:itemData];
        [self.contentScrollView addSubview:storeItem];
        [storeItem addTarget:self action:@selector(minePublishHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        yOffSet = yOffSet + CGRectGetHeight(storeItem.frame);
        
    }];
    
}

-(void)minePublishHandler:(TLMineListItem*)btn{
    NSDictionary *itemData = [btn.itemData valueForKey:@"ITEM_DATA"];
    [RTLHelper pushViewControllerWithName:[itemData valueForKey:@"VCNAME"] itemData:itemData block:^(id obj) {
        
    }];
    
}

-(void)addAppeal{
    NSDictionary *itemData = @{@"NAME":@"申诉",@"IMAGE":@"tl_mine_my_appeal"};
    TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet+3.f, CGRectGetWidth(self.contentScrollView.frame), 50.f) itemData:itemData isShowAction:NO];
    [self.contentScrollView addSubview:storeItem];
    
    yOffSet = yOffSet + CGRectGetHeight(storeItem.frame)+3.f;
}


-(void)addInterestAndSign{
    CGFloat vGap = 3.f;
    CGFloat vSpace = 10.f;
    
    
    TLFormItem *interestFromItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"兴趣爱好：",@"LABEL_VALUE":[self.userInfoDic valueForKey:@"INTERRESTING"],@"PLACE_HOLDER":@"写入兴趣爱好，逗号分割"}];
    interestFromItem.frame = interestFromItem.itemFrame;
    [self.contentScrollView addSubview:interestFromItem];
    yOffSet = yOffSet + CGRectGetHeight(interestFromItem.frame) + vGap;
    
    TLFormItem *signFromItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"个人签名：",@"LABEL_VALUE":[self.userInfoDic valueForKey:@"SIGNATURE"],@"PLACE_HOLDER":@"写入个人签名"}];
    signFromItem.frame = signFromItem.itemFrame;
    [self.contentScrollView addSubview:signFromItem];
    yOffSet = yOffSet + CGRectGetHeight(signFromItem.frame) + vSpace;
    
    
    [self addLoveCars];
    
    TLFormItem *schoolFromItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"毕业学校：",@"LABEL_VALUE":[self.userInfoDic valueForKey:@"SCHOOL"],@"PLACE_HOLDER":@"写入毕业学校名称"}];
    schoolFromItem.frame = schoolFromItem.itemFrame;
    [self.contentScrollView addSubview:schoolFromItem];
    yOffSet = yOffSet + CGRectGetHeight(schoolFromItem.frame) + vGap;
    
    TLFormItem *jobFromItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"就职公司：",@"LABEL_VALUE":[self.userInfoDic valueForKey:@"JOB"],@"PLACE_HOLDER":@"写入就职公司名称"}];
    jobFromItem.frame = jobFromItem.itemFrame;
    [self.contentScrollView addSubview:jobFromItem];
    yOffSet = yOffSet + CGRectGetHeight(jobFromItem.frame) + vGap;
    
    
    
    
    
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
    NSString *label = @"账号信息：";
    RUILabel *labelLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:label font:FONT_14 color:COLOR_MAIN_TEXT];
    labelLabel.frame = CGRectMake(hGap,yOffSet+vGap, CGRectGetWidth(labelLabel.frame), CGRectGetHeight(labelLabel.frame));
    [self.contentScrollView addSubview:labelLabel];
    
    yOffSet = yOffSet + CGRectGetHeight(labelLabel.frame)+vGap*2;
    
    
    TLFormItem *accountFromItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"途乐号：",@"LABEL_VALUE":self.userInfoDto.loginId}];
    accountFromItem.frame = accountFromItem.itemFrame;
    [self.contentScrollView addSubview:accountFromItem];
    yOffSet = yOffSet + CGRectGetHeight(accountFromItem.frame) + vGap;
    
    TLFormItem *levelFromItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"会员星级：",@"LABEL_VALUE":[NSString stringWithFormat:@"%@LV",self.userInfoDto.vipLevel]}];
    levelFromItem.frame = levelFromItem.itemFrame;
    [self.contentScrollView addSubview:levelFromItem];
    yOffSet = yOffSet + CGRectGetHeight(levelFromItem.frame) + vGap;
    
    TLFormItem *crateTimeFromItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"注册日期：",@"LABEL_VALUE":self.userInfoDto.createTime}];
    crateTimeFromItem.frame = crateTimeFromItem.itemFrame;
    [self.contentScrollView addSubview:crateTimeFromItem];
    yOffSet = yOffSet + CGRectGetHeight(crateTimeFromItem.frame) + vGap;
    
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
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.view.frame)-TABBAR_HEIGHT, CGRectGetWidth(self.view.frame), TABBAR_HEIGHT)];
    [self.view addSubview:bottomView];
    
    bottomView.backgroundColor = UIColorFromRGBA(0xffffff, 0.5);
    
    
   
    
    
    
//    if (self.userInfoDto.isFriend.integerValue==0) {
//        UIButton *addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)/3-80)/2+CGRectGetWidth(self.view.frame)/3, CGRectGetHeight(self.view.frame)-30.f-(TABBAR_HEIGHT-30)/2, 80, 30)];
//        //sendMessage.layer.borderColor = COLOR_ORANGE_TEXT.CGColor;
//        //sendMessage.layer.borderWidth = 1.f;
//        //    sendMessage.layer.cornerRadius = 4.f;
//        addFriendButton.titleLabel.font = FONT_16B;
//        [addFriendButton setTitle:@"添加好友" forState:UIControlStateNormal];
//        
//        [addFriendButton setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
//        [addFriendButton setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateHighlighted];
//        [addFriendButton addTarget:self action:@selector(addFriendButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:addFriendButton];
//
//    }
//if (self.userInfoDto.isFriend.integerValue==1){
        
        UIButton *sendMessage = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)/3-80)/2+CGRectGetWidth(self.view.frame)/3, CGRectGetHeight(self.view.frame)-30.f-(TABBAR_HEIGHT-30)/2, 80, 30)];
        //sendMessage.layer.borderColor = COLOR_ORANGE_TEXT.CGColor;
        //sendMessage.layer.borderWidth = 1.f;
        //    sendMessage.layer.cornerRadius = 4.f;
        sendMessage.titleLabel.font = FONT_16B;
        [sendMessage setTitle:@"发消息" forState:UIControlStateNormal];
        
        [sendMessage setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
        [sendMessage setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateHighlighted];
        [sendMessage addTarget:self action:@selector(sendMessageHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sendMessage];
        
        
//        UIButton *toBlackButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)/3-80)/2+CGRectGetWidth(self.view.frame)*2/3, CGRectGetHeight(self.view.frame)-30.f-(TABBAR_HEIGHT-30)/2, 80, 30)];
//        //sendMessage.layer.borderColor = COLOR_ORANGE_TEXT.CGColor;
//        //sendMessage.layer.borderWidth = 1.f;
//        //    sendMessage.layer.cornerRadius = 4.f;
//        toBlackButton.titleLabel.font = FONT_16B;
//        [toBlackButton setTitle:@"拉黑" forState:UIControlStateNormal];
//        
//        [toBlackButton setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
//        [toBlackButton setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateHighlighted];
//        [toBlackButton addTarget:self action:@selector(toBlackButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:toBlackButton];

    //}
    
    
    
    
   

}

-(void)sendMessageHandler:(id)btn{
//    ChatViewController * cvc = [[ChatViewController alloc]initWithSessionId:self.itemData[voipKey]];
//    [self.navigationController setViewControllers:[NSArray arrayWithObjects:[self.navigationController.viewControllers objectAtIndex:0],cvc, nil] animated:YES];
    
    
    [self pushViewControllerWithName:@"ChatViewController" itemData:@{@"SESSION_ID":self.userInfoDto.voipAccount} block:^(ChatViewController* obj) {
        obj.title = self.userInfoDto.userName;
    }];
}


-(void)deleteFried{
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper removeFreind:self.userInfoDto.loginId requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        ResponseDTO *resDTO = obj;
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }
    }];

}

-(void)addFriendButtonHandler:(id)btn{
    TLAddFriendApplyRequestDTO *request = [[TLAddFriendApplyRequestDTO alloc] init];
    request.loginId = self.userInfoDto.loginId;
    if (self.userInfoDto.isFriend.integerValue==1) {
        request.type = @"2";//删除 如果是好友
    }else{
        request.type = @"1";//添加 如果不是好友
    }

    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addFriendApply:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
         ResponseDTO *resDTO = obj;
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }else{
           
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }
    }];
}

-(void)toBlackButtonHandler:(id)btn{
    
    [self didImageSelected];
    
    
    
}

-(void)personInfoHandler:(id)sender{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSArray *imageURLs = self.userInfoDto.userImages;
    [imageURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLImageDTO *imageDto = obj;
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,imageDto.imageUrl];
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]]];
    }];
    TLPhotoBrowserViewController *browser = [[TLPhotoBrowserViewController alloc] initWithTLPhotos:photos];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
    
}




/**
 *  ////////////////////////////////////  图片选择
 */



#pragma mark-

//textMessageDelegate选择图库按钮事件
-(void)didImageSelected{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setEditing:NO];
    
    imagePicker.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.allowsEditing = NO;
    //isCamera = 0;
    
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

//图片选择
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    NSString *strType = [info valueForKey:UIImagePickerControllerMediaType];//媒体类型
    
    if ([strType hasSuffix:@"image"]) {
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];//获取图片
        
        
        
        ZXCropViewController* pecontroller = [[ZXCropViewController alloc] init];
        pecontroller.delegate = self;
        pecontroller.image = image;
        
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat length = MIN(width, height);
        pecontroller.imageCropRect = CGRectMake((width - length) / 2,
                                                (height - length) / 2,
                                                length,
                                                length);
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pecontroller];
        [self presentViewController:nav animated:NO completion:nil];
        
        
    }
    
    
}

#pragma mark -
#pragma mark - PECropViewControllerDelegate method

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
    WEAK_SELF(self);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *newImage = [croppedImage cropImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf saveAndShowImage:newImage];
            
            
        });
    });
}

-(void)saveAndShowImage:(UIImage*)image{
    
    
    TLReportBlackRequestDTO *request = [[TLReportBlackRequestDTO alloc] init];
    request.blackUser = self.userInfoDto.loginId;
    request.reportFiles = @[image];
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper reportBlack:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"拉黑成功"];
        }else{
            ResponseDTO *resDTO = obj;
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }
    }];

    
    
    
}



-(void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller.navigationController dismissViewControllerAnimated:YES completion:nil];
}




@end
