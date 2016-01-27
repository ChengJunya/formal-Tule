//
//  TLDetailCarRentViewController.m
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLDetailCarRentViewController.h"
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

#import "CoreData+MagicalRecord.h"
#import "TLTripDataEntity.h"
#import "TLTripTravelEntity.h"
#import "TLTripDetailEntity.h"
#import "TLImageEntity.h"
#import "TLTripUserEntity.h"

#import "TLCarRectEntity.h"
#import "TLCarRectDetailEntity.h"


@interface TLDetailCarRentViewController ()
@property (nonatomic,strong) TLViewCarRectResultDTO *detailDto;
@end

@implementation TLDetailCarRentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDetailData];
}


-(void)addDetailView{
    if ([self.view viewWithTag:1503211745]) {
        [[self.view viewWithTag:1503211745] removeFromSuperview];
    }
    
    TLTripDetailDTO *tripDetailDto = [[TLTripDetailDTO alloc] init];
    tripDetailDto.travelId = self.detailDto.rentId;
    tripDetailDto.cityId = @"";
    tripDetailDto.cityName = @"";
    tripDetailDto.title = self.detailDto.carType;
    tripDetailDto.createTime = self.detailDto.createTime;
    tripDetailDto.viewCount = @"";
    tripDetailDto.commentCount = @"";
    tripDetailDto.collectCount = @"";
    tripDetailDto.content = self.detailDto.carDesc;
    tripDetailDto.images = self.detailDto.images;
    tripDetailDto.user = self.detailDto.user;
    
    
    //self.title = @"车辆租赁";
    TLCarRentDetailView *detailView = [[TLCarRentDetailView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT) viewData:tripDetailDto detailData:self.detailDto];
    
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
    TLSaveCarRectRequestDTO *request = [[TLSaveCarRectRequestDTO alloc] init];
    
    request.operateType = @"3";
    request.objId = self.detailDto.rentId.length>0?self.detailDto.rentId:@"";
    
    
    
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addCarRect:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
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
    TLCarRectDTO *itemDTO = self.itemData;
    
    
    NSArray *dataArray = [TLCarRectEntity MR_findByAttribute:@"rentId" withValue:itemDTO.rentId];
    if (dataArray.count>0) {
        [GHUDAlertUtils toggleMessage:@"已经下载到本地！"];
        return;
    }
    
    
    
    TLCarRectEntity *tripDataEndity = [TLCarRectEntity MR_createEntity];
    tripDataEndity.rentId = itemDTO.rentId;
    tripDataEndity.carType = itemDTO.carType;
    tripDataEndity.rentType = itemDTO.rentType;
    tripDataEndity.driveDistance = itemDTO.driveDistance;
    tripDataEndity.editor = itemDTO.editor;
    tripDataEndity.createTime = itemDTO.createTime;
    tripDataEndity.carImageUrl = itemDTO.carImageUrl;
    
    

    
    TLCarRectDetailEntity *tripDetailEntity = [TLCarRectDetailEntity MR_createEntity];
    tripDetailEntity.rentId = _detailDto.rentId;
    tripDetailEntity.title = _detailDto.title;
    tripDetailEntity.createTime = _detailDto.createTime;
    tripDetailEntity.viewCount = _detailDto.viewCount;
    tripDetailEntity.commentCount = _detailDto.commentCount;
    tripDetailEntity.carType = _detailDto.carType;
    tripDetailEntity.driveDistance = _detailDto.driveDistance;
    tripDetailEntity.rentType = _detailDto.rentType;
    tripDetailEntity.address = _detailDto.address;
    tripDetailEntity.carDesc = _detailDto.carDesc;
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
    
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,[self.detailDto.images[0] imageUrl]];
    
    TLShareDTO *shareDto = [[TLShareDTO alloc] init];
    shareDto.shareUrl = UMSOCIAL_WXAPP_URL;//obj.shareUrl;
    shareDto.shareDesc = self.detailDto.carDesc.length>50?[self.detailDto.carDesc substringToIndex:49]:self.detailDto.carDesc;//self.detailDto.carDesc;//obj.shareDesc;
    shareDto.shareTitle = self.detailDto.carType;//obj.title;
    shareDto.shareImageUrl = imageUrl;//obj.imageUrl;
    shareDto.patAwardId = @"";//obj.patAwardId;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHARE object:shareDto];
}

-(void)getDetailData{
    WEAK_SELF(self);
    TLViewCarRentRequestDTO *requestDTO = [[TLViewCarRentRequestDTO alloc] init];
    TLCarRectDTO *itemDTO = self.itemData;
    requestDTO.rentId = itemDTO.rentId;
    requestDTO.dataType = self.dataType;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getCarRentDetail:requestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
        
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
    TLCarRectDTO *itemDTO = self.itemData;
    requestDTO.objId = itemDTO.rentId;
    requestDTO.type = @"7";
    
    
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
    
    NSDictionary *itemData = @{@"travelId":self.detailDto.rentId,@"type":MODULE_CARINFO_HIRE_TYPE};
    
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
