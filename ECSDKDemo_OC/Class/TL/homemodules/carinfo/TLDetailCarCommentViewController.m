//
//  TLDetailCarCommentViewController.m
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLDetailCarCommentViewController.h"
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

#import "CoreData+MagicalRecord.h"
#import "TLTripDataEntity.h"
#import "TLTripTravelEntity.h"
#import "TLTripDetailEntity.h"
#import "TLImageEntity.h"
#import "TLTripUserEntity.h"
#import "TLCarEvalDetailEntity.h"
#import "TLCarEvalutionEntity.h"

@interface TLDetailCarCommentViewController ()
@property (nonatomic,strong) TLCarEvalDetailResultDTO *detailDto;
@end

@implementation TLDetailCarCommentViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDetailData];
}


-(void)addDetailView{
    if ([self.view viewWithTag:1503211745]) {
        [[self.view viewWithTag:1503211745] removeFromSuperview];
    }
    
    TLTripDetailDTO *tripDetailDto = [[TLTripDetailDTO alloc] init];
    tripDetailDto.travelId = self.detailDto.carEvaId;
    tripDetailDto.cityId = @"";
    tripDetailDto.cityName = @"";
    tripDetailDto.title = self.detailDto.carType;
    tripDetailDto.createTime = self.detailDto.createTime;
    tripDetailDto.viewCount = @"";
    tripDetailDto.commentCount = @"";
    tripDetailDto.collectCount = @"";
    tripDetailDto.content = self.detailDto.carEvalDesc;
    tripDetailDto.images = self.detailDto.images;
    tripDetailDto.user = nil;
    
    
     //self.title = @"车评";
    TLCarCommentDetailView *detailView = [[TLCarCommentDetailView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT) viewData:tripDetailDto detailData:self.detailDto];
    
    detailView.MoreImageBlock = ^(){
        [self initTLPhotoBrowser];
        
    };
    detailView.CommentItemBlock = ^(){
        [self addComment];
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

-(void)downloadAction{
    TLCarEvalutionDTO *itemDTO = self.itemData;
    
    
    NSArray *dataArray = [TLCarEvalutionEntity MR_findByAttribute:@"carEvaId" withValue:itemDTO.carEvaId];
    if (dataArray.count>0) {
        [GHUDAlertUtils toggleMessage:@"已经下载到本地！"];
        return;
    }
    
   
    
    TLCarEvalutionEntity *tripDataEndity = [TLCarEvalutionEntity MR_createEntity];
    tripDataEndity.carEvaId = itemDTO.carEvaId;
    tripDataEndity.carType = itemDTO.carType;
    tripDataEndity.oilCost = itemDTO.oilCost;
    tripDataEndity.evalText = itemDTO.evalText;
    tripDataEndity.editor = itemDTO.editor;
    tripDataEndity.createTime = itemDTO.createTime;
    tripDataEndity.carImageUrl = itemDTO.carImageUrl;
    
    
    
    
    
    
    TLCarEvalDetailEntity *tripDetailEntity = [TLCarEvalDetailEntity MR_createEntity];
    tripDetailEntity.carEvaId = _detailDto.carEvaId;
    tripDetailEntity.carType = _detailDto.carType;
    tripDetailEntity.oilCost = _detailDto.oilCost;
    tripDetailEntity.publishTime = _detailDto.publishTime;
    tripDetailEntity.editor = _detailDto.editor;
    tripDetailEntity.createTime = _detailDto.createTime;
    tripDetailEntity.carEvalDesc = _detailDto.carEvalDesc;
    
    
    
    
    
    
    
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
    shareDto.shareDesc = self.detailDto.carEvalDesc.length>50?[self.detailDto.carEvalDesc substringToIndex:49]:self.detailDto.carEvalDesc;
    shareDto.shareTitle = self.detailDto.carType;//obj.title;
    shareDto.shareImageUrl = imageUrl;//obj.imageUrl;
    shareDto.patAwardId = @"";//obj.patAwardId;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHARE object:shareDto];
}

-(void)getDetailData{
    WEAK_SELF(self);
    TLCarEvalDetailRequestDTO *requestDTO = [[TLCarEvalDetailRequestDTO alloc] init];
    TLCarEvalutionDTO *itemDTO = self.itemData;
    requestDTO.carEvaId = itemDTO.carEvaId;
    requestDTO.dataType = self.dataType;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getCarEvalutionDetail:requestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
        
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
    TLCarEvalutionDTO *itemDTO = self.itemData;
    requestDTO.objId = itemDTO.carEvaId;
    requestDTO.type = @"6";
    
    
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
    
    NSDictionary *itemData = @{@"travelId":self.detailDto.carEvaId,@"type":MODULE_CARINFO_COMMENT_TYPE};
    
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
