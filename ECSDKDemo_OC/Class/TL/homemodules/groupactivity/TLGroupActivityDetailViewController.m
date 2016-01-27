//
//  TLGroupActivityDetailViewController.m
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLGroupActivityDetailViewController.h"
#import "TLGroupActivityDetailView.h"
#import "TLPhotoBrowserViewController.h"
#import "TLShareDTO.h"
#import "TLActivityDetailDTO.h"
#import "TLActivityDetailRequestDTO.h"
#import "TLActivityDTO.h"
#import "TLModuleDataHelper.h"
#import "TLTripDetailExtDTO.h"

#import "CoreData+MagicalRecord.h"
#import "TLTripDataEntity.h"
#import "TLTripTravelEntity.h"
#import "TLTripDetailEntity.h"
#import "TLImageEntity.h"
#import "TLTripUserEntity.h"
#import "TLActivityEntity.h"
#import "TLActivityDetailEntity.h"

@interface TLGroupActivityDetailViewController (){

}
@property (nonatomic,strong)    TLActivityDetailDTO *detailDto;
@end

@implementation TLGroupActivityDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDetailData];
}


-(void)addDetailView{
    if ([self.view viewWithTag:1503211745]) {
        [[self.view viewWithTag:1503211745] removeFromSuperview];
    }
    
    TLTripDetailDTO *tripDetailDto = [[TLTripDetailDTO alloc] init];
    tripDetailDto.travelId = self.detailDto.activityId;
    tripDetailDto.cityId = self.detailDto.destnation;
    tripDetailDto.cityName = self.detailDto.destnation;
    tripDetailDto.title = self.detailDto.title;
    tripDetailDto.createTime = self.detailDto.publishTime;
    tripDetailDto.viewCount = self.detailDto.viewCount;
    tripDetailDto.commentCount = self.detailDto.commentCount;
    tripDetailDto.collectCount = self.detailDto.collectCount;
    tripDetailDto.content = self.detailDto.desc;
    tripDetailDto.images = self.detailDto.images;
    tripDetailDto.user = self.detailDto.user;
    

    
    TLGroupActivityDetailView *detailView = [[TLGroupActivityDetailView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT) viewData:tripDetailDto detailData:self.detailDto];
    detailView.tag = 1503211745;
    detailView.MoreImageBlock = ^(){
        [self initTLPhotoBrowser];
        
    };
    detailView.CommentItemBlock = ^(){
        [self addComment];
    };
    
    detailView.DeleteBlock = ^(){
        [self deleteAction];
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
    TLActivitySaveRequestDTO *request = [[TLActivitySaveRequestDTO alloc] init];
    
    request.operateType = @"3";
    request.objId = self.detailDto.activityId.length>0?self.detailDto.activityId:@"1";
    
  
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper activitySave:request requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
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
    
    
    TLActivityDTO *itemDTO = self.itemData;
    
    
    NSArray *dataArray = [TLActivityEntity MR_findByAttribute:@"activityId" withValue:itemDTO.activityId];
    if (dataArray.count>0) {
        [GHUDAlertUtils toggleMessage:@"已经下载到本地！"];
        return;
    }
    
    
    
    TLActivityEntity *tripDataEndity = [TLActivityEntity MR_createEntity];
    tripDataEndity.title = itemDTO.title;
    tripDataEndity.destnation = itemDTO.destnation;
    tripDataEndity.costAverage = itemDTO.costAverage;
    tripDataEndity.personNum = itemDTO.personNum;
    tripDataEndity.desc = itemDTO.desc;
    tripDataEndity.viewCount = itemDTO.viewCount;
    tripDataEndity.commentCount = itemDTO.commentCount;
    tripDataEndity.activityImage = itemDTO.activityImage;
    tripDataEndity.activityId = itemDTO.activityId;
    tripDataEndity.enrollCount = itemDTO.enrollCount;
    tripDataEndity.publishTime = itemDTO.publishTime;
    
   
    

    
    
    TLActivityDetailEntity *tripDetailEntity = [TLActivityDetailEntity MR_createEntity];
    tripDetailEntity.activityId = _detailDto.activityId;
    tripDetailEntity.title = _detailDto.title;
    tripDetailEntity.destnation = _detailDto.destnation;
    tripDetailEntity.costAverage = _detailDto.costAverage;
    tripDetailEntity.personNum = _detailDto.personNum;
    tripDetailEntity.desc = _detailDto.desc;
    tripDetailEntity.viewCount = _detailDto.viewCount;
    tripDetailEntity.commentCount = _detailDto.commentCount;
    tripDetailEntity.collectCount = _detailDto.collectCount;
    tripDetailEntity.publishTime = _detailDto.publishTime;
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
    
    [_detailDto.enrollUsers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLTripUserDTO *userDto = obj;
        TLTripUserEntity *userEntity = [TLTripUserEntity MR_createEntity];
        userEntity.userIcon  = userDto.userIcon;
        userEntity.userIndex = userDto.userIndex;
        userEntity.userName = userDto.userName;
        userEntity.visitTime = userDto.visitTime;
        userEntity.loginId = userDto.loginId;
        [tripDetailEntity addEnrollUsersObject:userEntity];
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
    
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,[self.detailDto.images[0] imageUrl]];
    
    TLShareDTO *shareDto = [[TLShareDTO alloc] init];
    shareDto.shareUrl = UMSOCIAL_WXAPP_URL;//obj.shareUrl;
    shareDto.shareDesc = self.detailDto.desc.length>50?[self.detailDto.desc substringToIndex:49]:self.detailDto.desc;//self.detailDto.desc;//obj.shareDesc;
    shareDto.shareTitle = self.detailDto.title;//obj.title;
    shareDto.shareImageUrl = imageUrl;//obj.imageUrl;
    shareDto.patAwardId = @"";//obj.patAwardId;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHARE object:shareDto];
}

-(void)getDetailData{
    WEAK_SELF(self);
    TLActivityDetailRequestDTO *requestDTO = [[TLActivityDetailRequestDTO alloc] init];
    TLActivityDTO *itemDTO = self.itemData;
    requestDTO.activityId = itemDTO.activityId;
    requestDTO.dataType = self.dataType;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getActivityDetail:requestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
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
    TLActivityDTO *itemDTO = self.itemData;
    requestDTO.objId = itemDTO.activityId;
    requestDTO.type = MODULE_GROUPACTIVITY_TYPE;
    
    
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
    
    NSDictionary *itemData = @{@"travelId":self.detailDto.activityId,@"type":MODULE_GROUPACTIVITY_TYPE};
    
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


@end
