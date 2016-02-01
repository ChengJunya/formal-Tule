//
//  TLSecondDetailViewController.m
//  TL
//
//  Created by Rainbow on 2/20/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLSecondDetailViewController.h"
#import "TLSecondDetailView.h"
#import "TLPhotoBrowserViewController.h"
#import "TLSecondGoodsResult.h"

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
#import "TLCarEvalutionDTO.h"
#import "TLSecondGoodsDTO.h"

#import "CoreData+MagicalRecord.h"
#import "TLTripDataEntity.h"
#import "TLTripTravelEntity.h"
#import "TLTripDetailEntity.h"
#import "TLImageEntity.h"
#import "TLTripUserEntity.h"
#import "TLSecondGoodsEntity.h"
#import "TLSecondGoodsDetailEntity.h"

@interface TLSecondDetailViewController ()
@property (nonatomic,strong) TLSecondGoodsResult *detailDto;
@end

@implementation TLSecondDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDetailData];
}


-(void)addDetailView{
    if ([self.view viewWithTag:1503211745]) {
        [[self.view viewWithTag:1503211745] removeFromSuperview];
    }
    
    TLTripDetailDTO *tripDetailDto = [[TLTripDetailDTO alloc] init];
    tripDetailDto.travelId = self.detailDto.goodsId;
    tripDetailDto.cityId = @"";
    tripDetailDto.cityName = @"";
    tripDetailDto.title = self.detailDto.goodsName;
    tripDetailDto.createTime = self.detailDto.createTime;
    tripDetailDto.viewCount = self.detailDto.viewCount;
    tripDetailDto.commentCount = self.detailDto.commentCount;
    tripDetailDto.collectCount = @"";
    tripDetailDto.content = self.detailDto.goodsDesc;
    tripDetailDto.images = self.detailDto.images;
    tripDetailDto.user = self.detailDto.user;
    
    
    
    //self.title = @"车评";
    TLSecondDetailView *detailView = [[TLSecondDetailView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT) viewData:tripDetailDto detailData:self.detailDto ];
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
-(void)communicateAction{
    [self addComment];
}

-(void)downloadAction{
    TLSecondGoodsDTO *itemDTO = self.itemData;
    
    
    NSArray *dataArray = [TLSecondGoodsEntity MR_findByAttribute:@"goodsId" withValue:itemDTO.goodsId];
    if (dataArray.count>0) {
        [GHUDAlertUtils toggleMessage:@"已经下载到本地！"];
        return;
    }
    
    
    
    TLSecondGoodsEntity *tripDataEndity = [TLSecondGoodsEntity MR_createEntity];
    tripDataEndity.goodsId = itemDTO.goodsId;
    tripDataEndity.goodsName = itemDTO.goodsName;
    tripDataEndity.oldDesc = itemDTO.oldDesc;
    tripDataEndity.goodsDesc = itemDTO.goodsDesc;
    tripDataEndity.price = itemDTO.price;
    tripDataEndity.editor = itemDTO.editor;
    tripDataEndity.createTime = itemDTO.createTime;
    tripDataEndity.goodsImageUrl = itemDTO.goodsImageUrl;
    
    
    
    
    
    TLSecondGoodsDetailEntity *tripDetailEntity = [TLSecondGoodsDetailEntity MR_createEntity];
    tripDetailEntity.goodsId = _detailDto.goodsId;
    tripDetailEntity.title = _detailDto.title;
    tripDetailEntity.createTime = _detailDto.createTime;
    tripDetailEntity.viewCount = _detailDto.viewCount;
    tripDetailEntity.commentCount = _detailDto.commentCount;
    tripDetailEntity.goodsName = _detailDto.goodsName;
    tripDetailEntity.oldDesc = _detailDto.oldDesc;
    tripDetailEntity.price = _detailDto.price;
    tripDetailEntity.address = _detailDto.address;
    tripDetailEntity.goodsDesc = _detailDto.goodsDesc;
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



-(void)deleteAction{
    TLSaveSecondGoodsRequest *request = [[TLSaveSecondGoodsRequest alloc] init];
       request.operateType = @"3";
    request.objId = self.detailDto.goodsId.length>0?self.detailDto.goodsId:@"";
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addSecondGoods:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        
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
    shareDto.shareDesc = self.detailDto.goodsDesc.length>50?[self.detailDto.goodsDesc substringToIndex:49]:self.detailDto.goodsDesc;//self.detailDto.goodsDesc;//obj.shareDesc;
    shareDto.shareTitle = self.detailDto.title;//obj.title;

    shareDto.patAwardId = @"";//obj.patAwardId;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHARE object:shareDto];
}

-(void)getDetailData{
    WEAK_SELF(self);
    TLSecondGoodsDetailRequest *requestDTO = [[TLSecondGoodsDetailRequest alloc] init];
    TLSecondGoodsDTO *itemDTO = self.itemData;
    requestDTO.goodsId = itemDTO.goodsId;
    requestDTO.dataType = self.dataType;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getSecondGoodsDetail:requestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
        
        
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
    TLSecondGoodsDTO *itemDTO = self.itemData;
    requestDTO.objId = itemDTO.goodsId;
    requestDTO.type = @"9";
    
    
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
    
    NSDictionary *itemData = @{@"travelId":self.detailDto.goodsId,@"type":@"9"};
    
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
