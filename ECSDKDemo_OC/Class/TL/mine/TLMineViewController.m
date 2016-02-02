//
//  TLMineViewController.m
//  TL
//
//  Created by Rainbow on 2/6/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLMineViewController.h"

#import "ImagePlayerView.h"
#import "UIImageView+WebCache.h"
#import "RImageList.h"
#import "RUILabel.h"
#import "TLUserListView.h"
#import "TLMineListItem.h"
#import "TLHelper.h"

#import "TLUserViewResultDTO.h"
#import "TLModuleDataHelper.h"
#import "TLUserViewRequestDTO.h"
#import "UserDataHelper.h"
#import "LoginRequestDTO.h"
#import "TLPhotoBrowserViewController.h"

#import "UserDataHelper.h"
#import "LoginRequestDTO.h"

#define ImagePlayerView_Height 260.f
@interface TLMineViewController (){
    CGFloat yOffSet;
}
@property (nonatomic,strong) ImagePlayerView *imagePlayerView;
@property (nonatomic,strong) NSArray *imageURLs;
@property (nonatomic,strong) NSMutableDictionary *userInfoDic;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) TLUserViewResultDTO *userInfoDto;
@end

@implementation TLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
//    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"userinfo.json"]];
//    NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//    NSDictionary *userInfoData = [jsonParser objectWithString:jsonStr];
//    self.userInfoDic = [NSMutableDictionary dictionaryWithDictionary:userInfoData];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.listBtnHidden = NO;

    [self getUserInfoView];
}

-(void)getUserInfoView{
    WEAK_SELF(self);
    TLUserViewRequestDTO *userViewRequest = [[TLUserViewRequestDTO alloc] init];
    userViewRequest.loginId = GUserDataHelper.tlUserInfo.loginId;
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

#pragma mark -
#pragma mark - ui

- (void)addAllUIResources{
    
}

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
    //visitors
    [self addVisitors];
    
    //认证
    [self addCertificate];
    
    //store
    [self addStore];
    [self addRecharge];
    //download collection
    [self addDownloadCollections];

    
    //mypublish
    [self addMyPublish];
    
    //appeal
    [self addAppeal];
    
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentScrollView.frame), yOffSet);
    
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
    RUILabel *userNameLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:userName font:FONT_16B color:COLOR_MAIN_TEXT];
    userNameLabel.frame = CGRectMake(hGap,infoYOffSet + vGap, CGRectGetWidth(userNameLabel.frame), CGRectGetHeight(userNameLabel.frame));
    [infoView addSubview:userNameLabel];
    
   
   
    
    UIImageView *vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLabel.frame)+hGap*2, infoYOffSet + vGap+(CGRectGetHeight(userNameLabel.frame)-14)/2, 60.f, 14)];
    NSString *vipImageStr =[NSString stringWithFormat:@"tl_mine_viplv%@",self.userInfoDto.vipLevel];
    if (self.userInfoDto.isAuth.integerValue==1) {
        vipImageStr = @"v";
        [vipImageView setW:14.f];
    }

    vipImageView.image = [UIImage imageNamed:vipImageStr];
    [infoView addSubview:vipImageView];
    
    
    
    infoYOffSet = infoYOffSet + CGRectGetHeight(userNameLabel.frame)+vGap;
    
    
    NSString *tlId = [NSString stringWithFormat:@"ID:%@",self.userInfoDto.loginId];
    RUILabel *tlIdLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:tlId font:FONT_14 color:COLOR_MAIN_TEXT];
    tlIdLabel.frame = CGRectMake(hGap,infoYOffSet + vGap, CGRectGetWidth(tlIdLabel.frame), CGRectGetHeight(tlIdLabel.frame));
    [infoView addSubview:tlIdLabel];
    
    infoYOffSet = infoYOffSet + CGRectGetHeight(tlIdLabel.frame)+vGap;
    
    
    if ([GUserDataHelper isUserAuth]) {
        //work
        NSString *job = self.userInfoDto.job;
        RUILabel *jobLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:job font:FONT_14 color:COLOR_MAIN_TEXT];
        jobLabel.frame = CGRectMake(hGap,infoYOffSet + vGap, CGRectGetWidth(jobLabel.frame), CGRectGetHeight(jobLabel.frame));
        [infoView addSubview:jobLabel];
        
        infoYOffSet = infoYOffSet + CGRectGetHeight(jobLabel.frame)+vGap;
    }
   
    
    
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
    CGFloat btnWidth = 60.f;
    UIButton *updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(infoView.frame)-hGap-(userIconWidth-btnWidth)/2-btnWidth, vGap*2+userIconWidth, btnWidth, updateBtnHeight)];
    [updateBtn setBackgroundColor:COLOR_ORANGE_TEXT];
    [updateBtn setTitle:@"修改资料" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    updateBtn.titleLabel.font = FONT_14;
    [updateBtn addTarget:self action:@selector(updateInfoHandler:) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:updateBtn];
    
    [infoView setH:MAX(infoView.height, infoYOffSet)];
    
    yOffSet = yOffSet + CGRectGetHeight(infoView.frame);
    
    
}
-(void)updateInfoHandler:(id)btn{
    [RTLHelper pushViewControllerWithName:@"TLMineInfoViewController" itemData:self.userInfoDto block:^(id obj) {
        
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
    
    
    NSArray *userImages = self.userInfoDto.visitors;
    TLUserListView *imageList = [[TLUserListView alloc] initWithFrame:CGRectMake(0.f, yOffSet+vGap, CGRectGetWidth(self.view.frame), userIconListHeight) itemData:userImages isShowImageName:NO];
    [self.contentScrollView addSubview:imageList];
    
    yOffSet = yOffSet + CGRectGetHeight(imageList.frame)+vGap;
    

}

-(void)addCertificate{
    
    NSString *title = @"用户还未认证";
    if(self.userInfoDto.isAuth.integerValue==0){
        title = @"用户还未认证";
    }else{
        title = @"用户已认证";
    }
    
    NSDictionary *itemData = @{@"NAME":title,@"IMAGE":@"vip_icon"};
    TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.contentScrollView.frame), 50.f) itemData:itemData isShowAction:YES imageSize:CGSizeMake(40.f, 20.f)];
    [self.contentScrollView addSubview:storeItem];

    if(self.userInfoDto.isAuth.integerValue==0){
        [storeItem addTarget:self action:@selector(userCertificateHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    
    yOffSet = yOffSet + CGRectGetHeight(storeItem.frame);
}

//去认证
-(void)userCertificateHandler{
    [RTLHelper pushViewControllerWithName:@"TLUserCertificateViewController" block:^(id obj) {
        
    }];
}

-(void)addStore{
    
    NSDictionary *itemData = @{@"NAME":@"会员中心",@"IMAGE":@"vip_icon"};
    TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.contentScrollView.frame), 50.f) itemData:itemData isShowAction:YES imageSize:CGSizeMake(40.f, 20.f)];
    [self.contentScrollView addSubview:storeItem];
    [storeItem addTarget:self action:@selector(memberStoreHandler:) forControlEvents:UIControlEventTouchUpInside];
    yOffSet = yOffSet + CGRectGetHeight(storeItem.frame);
}

-(void)addRecharge{
    
    NSDictionary *itemData = @{@"NAME":@"用户充值",@"IMAGE":@"charge",@"SUB_NAME":[NSString stringWithFormat:@"余额 ￥%@",self.userInfoDto.tlb]};
    TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.contentScrollView.frame), 50.f) itemData:itemData isShowAction:YES imageSize:CGSizeMake(40.f, 20.f)];
    [self.contentScrollView addSubview:storeItem];
    [storeItem addTarget:self action:@selector(rechargeHandler:) forControlEvents:UIControlEventTouchUpInside];
    yOffSet = yOffSet + CGRectGetHeight(storeItem.frame);
}




-(void)rechargeHandler:(id)btn{
    [RTLHelper pushViewControllerWithName:@"TLMemberRechargeViewController" itemData:self.userInfoDto block:^(id obj) {
        
    }];
    
}

-(void)memberStoreHandler:(id)btn{
    [RTLHelper pushViewControllerWithName:@"TLMemberStoreViewController" itemData:self.userInfoDto block:^(id obj) {
        
    }];

}

-(void)addDownloadCollections{
    CGFloat vGap = 3.f;
    NSDictionary *itemData1 = @{@"NAME":@"我的下载",@"IMAGE":@"tl_mine_my_download"};
    TLMineListItem *storeItem1 = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet+vGap, CGRectGetWidth(self.contentScrollView.frame)/2, 50.f) itemData:itemData1 isShowAction:NO];
    storeItem1.layer.borderColor = UIColorFromRGBA(0xcccccc, 0.5).CGColor;
    storeItem1.layer.borderWidth = 0.5f;
    [self.contentScrollView addSubview:storeItem1];
        [storeItem1 addTarget:self action:@selector(selectDownloadHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *itemData2 = @{@"NAME":@"我的收藏",@"IMAGE":@"tl_mine_my_collect"};
    TLMineListItem *storeItem2 = [[TLMineListItem alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentScrollView.frame)/2, yOffSet+vGap, CGRectGetWidth(self.contentScrollView.frame)/2, 50.f) itemData:itemData2 isShowAction:NO];
    storeItem2.layer.borderColor = UIColorFromRGBA(0xcccccc, 0.5).CGColor;
    storeItem2.layer.borderWidth = 0.5f;
    [self.contentScrollView addSubview:storeItem2];
    [storeItem2 addTarget:self action:@selector(selectCollectionHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
    yOffSet = yOffSet + CGRectGetHeight(storeItem1.frame)+vGap*2;
}


-(void)selectDownloadHandler:(id)btn{
    [RTLHelper pushViewControllerWithName:@"TLMyDownloadViewController" block:^(id obj) {
        
    }];
}

-(void)selectCollectionHandler:(id)btn{
    [RTLHelper pushViewControllerWithName:@"TLMyCollectionViewController" block:^(id obj) {
        
    }];
}

-(void)addMyPublish{
    CGFloat hGap = 3.f;
     CGFloat vGap = 3.f;
    NSString *label = @"我的发布：";
    RUILabel *labelLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:label font:FONT_14 color:COLOR_MAIN_TEXT];
    labelLabel.frame = CGRectMake(hGap,yOffSet + vGap, CGRectGetWidth(labelLabel.frame), CGRectGetHeight(labelLabel.frame));
    [self.contentScrollView addSubview:labelLabel];
    
    yOffSet = yOffSet + CGRectGetHeight(labelLabel.frame)+vGap*2;
    
    NSString *loginId = GUserDataHelper.tlUserInfo.loginId;
    //MODULE_TYPE 1-我的发布
    NSArray *itemsData = @[
  @{@"ID":@"1",@"NAME":@"攻略",@"IMG":@"menu1_homepage",@"VCNAME":@"TLStrategyListViewController",@"TYPE":@"1",@"IS_SHOW_MENU":@"1",@"MODULE_TYPE":@"1",@"DATATYPE":@"1",@"LOGINID":loginId},
   @{@"ID":@"2",@"NAME":@"路书",@"IMG":@"menu2_homepage",@"VCNAME":@"TLWayBookListViewController",@"TYPE":@"2",@"IS_SHOW_MENU":@"1",@"MODULE_TYPE":@"1",@"DATATYPE":@"1",@"LOGINID":loginId},
   @{@"ID":@"3",@"NAME":@"游记",@"IMG":@"menu3_homepage",@"VCNAME":@"TLTripNoteListViewController",@"TYPE":@"3",@"IS_SHOW_MENU":@"1",@"MODULE_TYPE":@"1",@"DATATYPE":@"1",@"LOGINID":loginId},
   @{@"ID":@"4",@"NAME":@"活动",@"IMG":@"menu4_homepage",@"VCNAME":@"TLGroupActivityListViewController",@"TYPE":@"4",@"IS_SHOW_MENU":@"1",@"MODULE_TYPE":@"1",@"DATATYPE":@"1",@"LOGINID":loginId},
   @{@"ID":@"5",@"NAME":@"车讯",@"IMG":@"menu5_homepage",@"VCNAME":@"TLCarMainListViewController",@"TYPE":@"5",@"IS_SHOW_MENU":@"1",@"MODULE_TYPE":@"1",@"DATATYPE":@"1",@"LOGINID":loginId},
   @{@"ID":@"6",@"NAME":@"跳蚤",@"IMG":@"menu6_homepage",@"VCNAME":@"TLSecondPlatformViewController",@"TYPE":@"6",@"IS_SHOW_MENU":@"1",@"MODULE_TYPE":@"1",@"DATATYPE":@"1",@"LOGINID":loginId}];
    
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
    [storeItem addTarget:self action:@selector(applealHandler:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)applealHandler:(id)btn{
    [RTLHelper pushViewControllerWithName:@"TLAppealViewController" block:^(id obj) {
        
    }];
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



@end
