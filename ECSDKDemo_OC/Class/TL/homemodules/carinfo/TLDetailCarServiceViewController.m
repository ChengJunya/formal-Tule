//
//  TLDetailCarServiceViewController.m
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLDetailCarServiceViewController.h"
#import "TLPhotoBrowserViewController.h"
#import "TLCarServiceDetailView.h"
#import "TLStarLevel.h"
#import "TLCarServiceResult.h"

#import "TLPhotoBrowserViewController.h"
#import "TLCarRentDetailView.h"
#import "TLPhotoBrowserViewController.h"
#import "TLCarCommentDetailView.h"
#import "TLPhotoBrowserViewController.h"
#import "TLCarInfoDetailView.h"
#import "TLGroupActivityDetailView.h"
#import "TLPhotoBrowserViewController.h"
#import "TLShareDTO.h"
#import "TLActivityDetailDTO.h"
#import "TLActivityDetailRequestDTO.h"
#import "TLActivityDTO.h"
#import "TLTripDetailDTO.h"
#import "TLModuleDataHelper.h"
#import "TLTripDetailDTO.h"
#import "TLCarDEtailResultDTO.h"
#import "TLListCarDTO.h"
#import "TLCarEvalDetailResultDTO.h"
#import "TLViewCarRectResultDTO.h"
#import "TLCarRectDTO.h"
#import "TLCarServiceDTO.h"

#import "CoreData+MagicalRecord.h"
#import "TLTripDataEntity.h"
#import "TLTripTravelEntity.h"
#import "TLTripDetailEntity.h"
#import "TLImageEntity.h"
#import "TLTripUserEntity.h"

#import "TLCarServiceEntity.h"
#import "TLCarServiceDetailEntity.h"


@interface TLDetailCarServiceViewController ()
@property (nonatomic,strong) UIView *starCommentView;
@property (nonatomic,assign) NSUInteger currentStarLevel;

@property (nonatomic,strong) TLCarServiceResult *detailDto;
@end

@implementation TLDetailCarServiceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDetailData];
}


-(void)addDetailView{
    if ([self.view viewWithTag:1503211745]) {
        [[self.view viewWithTag:1503211745] removeFromSuperview];
    }
    
    TLTripDetailDTO *tripDetailDto = [[TLTripDetailDTO alloc] init];
    tripDetailDto.travelId = self.detailDto.serviceId;
    tripDetailDto.cityId = @"";
    tripDetailDto.cityName = @"";
    tripDetailDto.title = self.detailDto.serviceType;
    tripDetailDto.createTime = self.detailDto.createTime;
    tripDetailDto.viewCount = @"";
    tripDetailDto.commentCount = @"";
    tripDetailDto.collectCount = @"";
    tripDetailDto.content = self.detailDto.serviceDesc;
    tripDetailDto.images = self.detailDto.images;
    tripDetailDto.user = self.detailDto.user;
    
    
    //self.title = @"车辆服务";
    TLCarServiceDetailView *detailView = [[TLCarServiceDetailView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT) viewData:tripDetailDto detailData:self.detailDto];
    
    detailView.MoreImageBlock = ^(){
        [self initTLPhotoBrowser];
        
    };
    detailView.CommentItemBlock = ^(){
        [self addComment];
    };
    detailView.DeleteBlock = ^(){
        [self deleteAction];
    };
    detailView.StarBlock = ^(id itemData){
        [self starComment:itemData];
    };
    [self.view addSubview:detailView];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)deleteAction{
    TLSaveCarServiceRequest *request = [[TLSaveCarServiceRequest alloc] init];
    
    request.operateType = @"3";
    request.objId = self.detailDto.serviceId.length>0?self.detailDto.serviceId:@"";
    
    
    
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addCarService:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        ResponseDTO *response = obj;
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"删除成功"];
            [weakSelf gobackAction];
        }else{
            [GHUDAlertUtils toggleMessage:response.resultDesc];
            
        }
    }];
}

-(void)gobackAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)downloadAction{
    TLCarServiceDTO *itemDTO = self.itemData;
    
    
    NSArray *dataArray = [TLCarServiceEntity MR_findByAttribute:@"serviceId" withValue:itemDTO.serviceId];
    if (dataArray.count>0) {
        [GHUDAlertUtils toggleMessage:@"已经下载到本地！"];
        return;
    }
    
   
    TLCarServiceEntity *tripDataEndity = [TLCarServiceEntity MR_createEntity];
    tripDataEndity.serviceId = itemDTO.serviceId;
    tripDataEndity.title = itemDTO.title;
    tripDataEndity.rank = itemDTO.rank;
    tripDataEndity.serviceType = itemDTO.serviceType;
    tripDataEndity.address = itemDTO.address;
    tripDataEndity.createTime = itemDTO.createTime;
    tripDataEndity.serviceImageUrl = itemDTO.serviceImageUrl;
    
    
    
    
    TLCarServiceDetailEntity *tripDetailEntity = [TLCarServiceDetailEntity MR_createEntity];
    
    
    
    tripDetailEntity.serviceId = _detailDto.serviceId;
    tripDetailEntity.title = _detailDto.title;
    tripDetailEntity.createTime = _detailDto.createTime;
    tripDetailEntity.viewCount = _detailDto.viewCount;
    tripDetailEntity.commentCount = _detailDto.commentCount;
    tripDetailEntity.serviceType = _detailDto.serviceType;
    tripDetailEntity.rank = _detailDto.rank;
    tripDetailEntity.address = _detailDto.address;
    tripDetailEntity.serviceDesc = _detailDto.serviceDesc;
    tripDetailEntity.userPhone = _detailDto.userPhone;
    
    
    TLTripUserEntity *userEntity = [TLTripUserEntity MR_createEntity];
    userEntity.userIcon  = _detailDto.user.userIcon;
    userEntity.userIndex = _detailDto.user.userIndex;
    userEntity.userName = _detailDto.user.userName;
    userEntity.visitTime = _detailDto.user.visitTime;
    userEntity.loginId = _detailDto.user.loginId;
    tripDetailEntity.user = userEntity;
    
    
    
    
    [_detailDto.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLImageDTO *imageDto = obj;
        TLImageEntity *image = [TLImageEntity MR_createEntity];
        image.imageName = imageDto.imageName;
        image.imageUrl = imageDto.imageUrl;
        [tripDetailEntity addImagesObject:image];
    }];
    
    
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        [GHUDAlertUtils toggleMessage:@"下载成功"];
    }];
    
    
}

-(void)communicateAction{
    [self addComment];
}

-(void)collectAction{
    [self addCollect];
}

-(void)shareAction{
    TLShareDTO *shareDto = [[TLShareDTO alloc] init];
    if (self.detailDto.images.count) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,[self.detailDto.images[0] imageUrl]];
        shareDto.shareImageUrl = imageUrl;//obj.imageUrl;
    }
    shareDto.shareUrl = UMSOCIAL_WXAPP_URL;//obj.shareUrl;
    shareDto.shareDesc = self.detailDto.serviceDesc.length>50?[self.detailDto.serviceDesc substringToIndex:49]:self.detailDto.serviceDesc;//self.detailDto.serviceDesc;//obj.shareDesc;
    shareDto.shareTitle = self.detailDto.serviceType;//obj.title;

    shareDto.patAwardId = @"";//obj.patAwardId;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHARE object:shareDto];
}

-(void)getDetailData{
    WEAK_SELF(self);
    TLCarServiceDetailRequest *requestDTO = [[TLCarServiceDetailRequest alloc] init];
    TLCarServiceDTO *itemDTO = self.itemData;
    requestDTO.serviceId = itemDTO.serviceId;
    requestDTO.dataType = self.dataType;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getCarServiceDetail:requestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            weakSelf.detailDto = obj;
            [weakSelf addDetailView];
            
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];
    
}



-(void)addCollect{
    WEAK_SELF(self);
    TLSaveCollectRequestDTO *requestDTO = [[TLSaveCollectRequestDTO alloc] init];
    TLCarServiceDTO *itemDTO = self.itemData;
    requestDTO.objId = itemDTO.serviceId;
    requestDTO.type = @"8";
    
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addCollect:requestDTO requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            [weakSelf addDetailView];
            
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];
    
}


-(void)addComment{
    
    NSDictionary *itemData = @{@"travelId":self.detailDto.serviceId,@"type":MODULE_CARINFO_SERVICE_TYPE};
    
    [self pushViewControllerWithName:@"TLCommentViewController" itemData:itemData block:^(id obj) {
        
    }];
}

-(void)initTLPhotoBrowser{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSArray *imageURLs = self.detailDto.images;
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




-(void)starComment:(id)itemData{
    [self addStarCommentView];
}

-(void)addStarCommentView{
    CGFloat viewWidth = 220.f;
    CGFloat viewHeight = 130.f;
    CGFloat vGap = 10.f;
    CGFloat hGap = 10.f;
    self.starCommentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.starCommentView];
    self.starCommentView.backgroundColor = UIColorFromRGBA(0x000000, 0.2f);
    UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake((CGRectWidth(self.starCommentView.frame)-viewWidth)/2, (CGRectGetHeight(self.starCommentView.frame)-viewHeight)/2, viewWidth, viewHeight)];
    smallView.backgroundColor = COLOR_DEF_BG;
    [self.starCommentView addSubview:smallView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, vGap, viewWidth-hGap*2, 20.f)];
    titleLabel.font = FONT_16B;
    titleLabel.text = @"点击星星评分：";
    titleLabel.textColor = COLOR_MAIN_TEXT;
    [smallView addSubview:titleLabel];
    
    TLStarLevel *starLevel = [[TLStarLevel alloc] initWithFrame:CGRectMake(hGap, CGRectGetMaxY(titleLabel.frame)+vGap, viewWidth, 40.f) level:5 currentLevel:1];
    starLevel.tag = 201502;
    starLevel.isStarSelect = YES;
    [smallView addSubview:starLevel];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(smallView.frame)-30.f, viewWidth/2, 30.f)];
    cancelBtn.layer.borderColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    cancelBtn.layer.borderWidth = 0.5f;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(closeViewHandler) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    [smallView addSubview:cancelBtn];
    
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2, CGRectGetHeight(smallView.frame)-30.f, viewWidth/2, 30.f)];
    [okBtn addTarget:self action:@selector(closeViewHandler) forControlEvents:UIControlEventTouchUpInside];
    okBtn.layer.borderColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    okBtn.layer.borderWidth = 0.5f;
    [okBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [smallView addSubview:okBtn];
    
}

-(void)closeViewHandler{
    if (self.starCommentView) {
        TLStarLevel *tmpLevel = (TLStarLevel*)[self.starCommentView viewWithTag:201502];
        self.currentStarLevel = tmpLevel.currentLevel;
        [self mackScore:[NSString stringWithFormat:@"%d",self.currentStarLevel]];
        [self.starCommentView removeFromSuperview];
    }
}


-(void)mackScore:(NSString *)level{
    WEAK_SELF(self);
    TLCarServiceMackScoreRequest *requestDTO = [[TLCarServiceMackScoreRequest alloc] init];
    TLCarServiceDTO *itemDTO = self.itemData;
    requestDTO.serviceId = itemDTO.serviceId;
    requestDTO.score = level;
    
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper makeCarScore:requestDTO requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            [weakSelf getDetailData];
            
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];
}


@end
