//
//  TLWayBookDetailViewController.m
//  TL
//
//  Created by Rainbow on 2/15/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLWayBookDetailViewController.h"
#import "TLPhotoBrowserViewController.h"
#import "TLDetailView.h"
#import "TLWayNodeView.h"
#import "TLTripDetailDTO.h"
#import "TLShareDTO.h"
#import "TLWayBookDetailDTO.h"
#import "TLWayBookDetailRequestDTO.h"
#import "TLTripDataDTO.h"
#import "TLModuleDataHelper.h"
#import "TLTripTravelDTO.h"
#import "TLWayBookNodeDTO.h"


#import "CoreData+MagicalRecord.h"
#import "TLTripDataEntity.h"
#import "TLTripTravelEntity.h"
#import "TLTripDetailEntity.h"
#import "TLImageEntity.h"
#import "TLTripUserEntity.h"
#import "TLWaybookNodeDetailViewController.h"


@interface TLWayBookDetailViewController (){
    TLWayBookDetailDTO *detailDto;
}
@property (nonatomic,strong) TLDetailView *detailView;

@end

@implementation TLWayBookDetailViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //[self getDetailData];

}

-(void)addWayNodes{
    CGFloat nodeHeight = 200.f;
    NSArray<TLWayBookNodeDTO> *nodes = detailDto.travel;
    [nodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLWayNodeView *nodeView = [[TLWayNodeView alloc] initWithFrame:CGRectMake(0.f, self.detailView.yOffSet, CGRectGetWidth(self.detailView.frame), nodeHeight) itemData:obj];
        __weak TLWayBookDetailViewController *weak = self;
        nodeView.ItemSelectBlock = ^(id itemData){
            [weak nodeItemSelectHandler:itemData];
        };
        [self.detailView.viewContentScroll addSubview:nodeView];
        self.detailView.yOffSet = self.detailView.yOffSet + nodeHeight;
        self.detailView.viewContentScroll.contentSize = CGSizeMake(self.detailView.viewContentScroll.contentSize.width, self.detailView.yOffSet);
        
    }];
    
}

-(void)addDetailView{
    WEAK_SELF(self);
    if ([self.view viewWithTag:1503211746]) {
        [[self.view viewWithTag:1503211746] removeFromSuperview];
    }
    
    self.detailView = [[TLDetailView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT) viewData:detailDto type:[NSString stringWithFormat:@"%@1",self.type]];
    self.detailView.tag = 1503211746;
    
    self.detailView.MoreImageBlock = ^(){
        [weakSelf initTLPhotoBrowser];
        
    };
    self.detailView.DeleteBlock = ^(){
        [weakSelf deleteAction];
        
    };

    
    [self.view addSubview:self.detailView];
    
    [self addWayNodes];
}

-(void)deleteAction{
    TLAddTripRequestDTO *tripRequestDTO = [[TLAddTripRequestDTO alloc] init];
    
    tripRequestDTO.operateType = @"3";
    tripRequestDTO.type = self.type;
    tripRequestDTO.objId = detailDto.travelId.length>0?detailDto.travelId:@"";
    
    WEAK_SELF(self);
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addTrip:tripRequestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
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

-(void)nodeItemSelectHandler:(id)itemData{
    NSDictionary *param = @{@"dto":itemData,@"detailDto":detailDto};
    
    
    [self pushViewControllerWithName:@"TLWaybookNodeDetailViewController" itemData:param block:^(TLWaybookNodeDetailViewController* obj) {
        obj.type = [NSString stringWithFormat:@"%@2",self.type];
    }];
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
    tripDataEndity.type = self.type;
    
    
    
    [itemDTO.travel enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLTripTravelDTO *nodeDto = obj;
        TLTripTravelEntity *tlTripTravelEntity = [TLTripTravelEntity MR_createEntity];
        tlTripTravelEntity.lsNodeId = nodeDto.lsNodeId;
        tlTripTravelEntity.travelId = nodeDto.travelId;
        tlTripTravelEntity.cityId = nodeDto.cityId;
        tlTripTravelEntity.cityName = nodeDto.cityName;
        tlTripTravelEntity.content = nodeDto.content;
        tlTripTravelEntity.createTime = nodeDto.createTime;
        tlTripTravelEntity.createUser = nodeDto.createUser;
        tlTripTravelEntity.modifyTime = nodeDto.modifyTime;
        [tripDataEndity addTravelObject:tlTripTravelEntity];
    }];
    
    
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
    
    [detailDto.travel enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLWayBookNodeDTO *nodeDto = obj;
        TLTripTravelEntity *tlTripTravelEntity = [TLTripTravelEntity MR_createEntity];
        tlTripTravelEntity.lsNodeId = nodeDto.lsNodeId;
        tlTripTravelEntity.travelId = nodeDto.travelId;
        tlTripTravelEntity.cityId = nodeDto.cityId;
        tlTripTravelEntity.cityName = nodeDto.cityName;
        tlTripTravelEntity.content = nodeDto.content;
        tlTripTravelEntity.createTime = nodeDto.createTime;
        tlTripTravelEntity.createUser = nodeDto.createUser;
        tlTripTravelEntity.modifyTime = nodeDto.modifyTime;
        [nodeDto.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TLImageDTO *imageDto = obj;
            TLImageEntity *image = [TLImageEntity MR_createEntity];
            image.imageName = imageDto.imageName;
            image.imageUrl = imageDto.imageUrl;
            [tlTripTravelEntity addImagesObject:image];
        }];
        
        [tripDataEndity addTravelObject:tlTripTravelEntity];
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
    
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,[detailDto.images[0] imageUrl]];
    
    TLShareDTO *shareDto = [[TLShareDTO alloc] init];
    shareDto.shareUrl = UMSOCIAL_WXAPP_URL;//obj.shareUrl;
    shareDto.shareDesc = detailDto.content.length>50?[detailDto.content substringToIndex:49]:detailDto.content;//obj.shareDesc;
    shareDto.shareTitle = detailDto.title;//obj.title;
    shareDto.shareImageUrl = imageUrl;//obj.imageUrl;
    shareDto.patAwardId = @"";//obj.patAwardId;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHARE object:shareDto];
}

-(void)getDetailData{
    WEAK_SELF(self);
    TLWayBookDetailRequestDTO *requestDTO = [[TLWayBookDetailRequestDTO alloc] init];
    TLTripDataDTO *itemDTO = self.itemData;
    requestDTO.travelId = itemDTO.travelId;
    requestDTO.dataType = self.dataType;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getWayBookDetail:requestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
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
    requestDTO.type = self.type;
    
    
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
    
    NSDictionary *itemData = @{@"travelId":detailDto.travelId,@"type":self.type};
    
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
