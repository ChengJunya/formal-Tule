//
//  TLTripNoteDetailViewController.m
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLTripNoteDetailViewController.h"
#import "TLDetailView.h"
#import "TLPhotoBrowserViewController.h"
#import "TLModuleDataHelper.h"
#import "TLTripDetailRequestDTO.h"
#import "TLTripDataDTO.h"
#import "TLTripDetailDTO.h"
#import "TLImageDTO.h"
#import "TLSaveCollectRequestDTO.h"
#import "TLShareDTO.h"

#import "CoreData+MagicalRecord.h"
#import "TLTripDataEntity.h"
#import "TLTripTravelEntity.h"
#import "TLTripDetailEntity.h"
#import "TLImageEntity.h"
#import "TLTripUserEntity.h"

@interface TLTripNoteDetailViewController (){
    TLTripDetailDTO *detailDto;
}
@end

@implementation TLTripNoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)addDetailView{
    
    if ([self.view viewWithTag:1503211746]) {
        [[self.view viewWithTag:1503211746] removeFromSuperview];
    }
    
    TLDetailView *detailView = [[TLDetailView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT) viewData:detailDto type:@"2"];
    detailView.tag = 1503211746;
    
    detailView.MoreImageBlock = ^(){
        [self initTLPhotoBrowser];
        
    };
    
    [self.view addSubview:detailView];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
        [self getDetailData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadAction{
    
    
    TLTripDataDTO *itemDTO = self.itemData;
    
    
    NSArray *dataArray = [TLTripDataEntity MR_findByAttribute:@"travelId" withValue:itemDTO.travelId];
    if (dataArray.count>0) {
        [GHUDAlertUtils toggleMessage:@"已经下载到本地！"];
        return;
    }
    
    TLTripDataEntity *tripDataEndity = [TLTripDataEntity MR_createEntity];
    tripDataEndity.travelId = itemDTO.travelId;
    tripDataEndity.cityId = itemDTO.cityId;
    tripDataEndity.cityName = itemDTO.cityName;
    tripDataEndity.title = itemDTO.title;
    tripDataEndity.createTime = itemDTO.createTime;
    tripDataEndity.viewCount = itemDTO.viewCount;
    tripDataEndity.userIcon = itemDTO.userIcon;
    tripDataEndity.userPic = itemDTO.userPic;
    tripDataEndity.type = MODULE_TRIPNOTE_TYPE;
    
    TLTripDetailEntity *tripDetailEntity = [TLTripDetailEntity MR_createEntity];
    tripDetailEntity.travelId = detailDto.travelId;
    tripDetailEntity.cityId = detailDto.cityId;
    tripDetailEntity.cityName = detailDto.cityName;
    tripDetailEntity.title = detailDto.title;
    tripDetailEntity.createTime = detailDto.createTime;
    tripDetailEntity.viewCount = detailDto.viewCount;
    tripDetailEntity.commentCount = detailDto.commentCount;
    tripDetailEntity.collectCount = detailDto.collectCount;
    tripDetailEntity.content = detailDto.content;
    
    
    TLTripUserEntity *userEntity = [TLTripUserEntity MR_createEntity];
    userEntity.userIcon  = detailDto.user.userIcon;
    userEntity.userIndex = detailDto.user.userIndex;
    userEntity.userName = detailDto.user.userName;
    userEntity.visitTime = detailDto.user.visitTime;
    userEntity.loginId = detailDto.user.loginId;
    tripDetailEntity.user = userEntity;
    
    [detailDto.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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

- (void)shareAction{
    TLShareDTO *shareDto = [[TLShareDTO alloc] init];
    if (detailDto.images.count){
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,[detailDto.images[0] imageUrl]];
        shareDto.shareImageUrl = imageUrl;//obj.imageUrl;
    }
    shareDto.shareUrl = UMSOCIAL_WXAPP_URL;//obj.shareUrl;
    shareDto.shareDesc = detailDto.content.length>50?[detailDto.content substringToIndex:49]:detailDto.content;//obj.shareDesc;
    shareDto.shareTitle = detailDto.title;//obj.title;

    shareDto.patAwardId = @"";//obj.patAwardId;


    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHARE object:shareDto];
}
-(void)getDetailData{
    WEAK_SELF(self);
    TLTripDetailRequestDTO *requestDTO = [[TLTripDetailRequestDTO alloc] init];
    TLTripDataDTO *itemDTO = self.itemData;
    requestDTO.travelId = itemDTO.travelId;
    requestDTO.type = MODULE_TRIPNOTE_TYPE;
    requestDTO.dataType = self.dataType;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getTripDetail:requestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            detailDto = obj;
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
    TLTripDataDTO *itemDTO = self.itemData;
    requestDTO.objId = itemDTO.travelId;
    requestDTO.type = MODULE_TRIPNOTE_TYPE;
    
    
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
    
    NSDictionary *itemData = @{@"travelId":detailDto.travelId,@"type":MODULE_TRIPNOTE_TYPE};
    
    [self pushViewControllerWithName:@"TLCommentViewController" itemData:itemData block:^(id obj) {
        
    }];
}


-(void)initTLPhotoBrowser{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSArray *imageURLs = detailDto.images;
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
